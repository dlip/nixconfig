{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-21.05";
    nixpkgs-release.url = "github:NixOS/nixpkgs/release-21.05";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    envy-sh.url = "github:dlip/envy.sh";
    arion = {
      url = "github:hercules-ci/arion";
      flake = false;
    };
    sops-nix.url = "github:Mic92/sops-nix";
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
    emacs-overlay.url = "github:nix-community/emacs-overlay";
    kmonad = {
      url = "github:kmonad/kmonad";
      flake = false;
    };
    emoji-menu = {
      url = "github:jchook/emoji-menu";
      flake = false;
    };
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-release
    , nixpkgs-unstable
    , home-manager
    , envy-sh
    , arion
    , sops-nix
    , flake-compat
    , flake-utils
    , emacs-overlay
    , kmonad
    , emoji-menu
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs-release = import nixpkgs-release {
          inherit system;
          config.allowUnfree = true;
        };

        pkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              my = final.callPackage ./pkgs { };
              envy-sh = envy-sh.defaultPackage.${system};
              inherit (final.callPackage arion { }) arion;
              kmonad = final.haskellPackages.callPackage (import "${kmonad}/nix/kmonad.nix") { stdenv = { lib = final.lib; }; };
              csvkit = pkgs-release.csvkit; # unstable has a build error
              emoji-menu = final.writeShellScriptBin "emoji-menu" (builtins.readFile "${emoji-menu}/bin/emoji-menu");
            })
            emacs-overlay.overlay
          ];
        };

        createHomeConfig = configName: config@{ extraImports ? [ ], ... }:
          flake-utils.lib.mkApp
            {
              drv =
                (home-manager.lib.homeManagerConfiguration
                  {
                    inherit pkgs;
                    inherit (config) system homeDirectory username;
                    configuration = {
                      imports = (import ./home { inherit config; inherit configName; }) ++ extraImports;
                    };
                  }
                ).activationPackage;
            };

        configs = rec {
          personal = rec {
            username = "dane";
            homeDirectory = "/home/dane";
            name = "Dane Lipscombe";
            email = "dane@lipscombe.com.au";
            nixConfigPath = homeDirectory + "/code/nixconfig";
          };

          personal-nixos = personal // { extraImports = [ ./home/graphical.nix ]; };

          tv = rec {
            username = "tv";
            homeDirectory = "/home/tv";
            name = "TV Lipscombe";
            email = "tv@lipscombe.com.au";
            nixConfigPath = homeDirectory + "/code/nixconfig";
            extraImports = [ ./home/media.nix ./home/emulation.nix ];
          };

          immutable = personal // { email = "dane.lipscombe@immutable.com"; };

          immutable-nixos = immutable // { extraImports = [ ./home/graphical.nix ]; };

          root = personal // {
            username = "root";
            homeDirectory = "/root";
          };
        };
      in
      rec {
        inherit pkgs;
        defaultApp = apps.repl;
        apps = {
          repl = flake-utils.lib.mkApp
            {
              drv = pkgs.writeShellScriptBin "repl" ''
                confnix=$(mktemp)
                echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" >$confnix
                trap "rm $confnix" EXIT
                nix repl $confnix
              '';
            };
          homeConfigurations = builtins.mapAttrs createHomeConfig configs;
        };
        devShell = pkgs.mkShell {
          sopsPGPKeyDirs = [ "./keys/hosts" "./keys/users" ];
          nativeBuildInputs = with pkgs; [ (callPackage sops-nix { }).sops-pgp-hook ];
        };
        packages = {
          pushNixStoreDockerImage = with pkgs; dockerTools.buildLayeredImage {
            name = "push-nix-store-docker-image";
            tag = "latest";
            contents = [
              coreutils
              skopeo
              cacert
              nixUnstable
              (writeScriptBin "entrypoint" ''
                #!${runtimeShell}
                set -euo pipefail
                mkdir -p /var/tmp
                nix --experimental-features nix-command store cat --store $1 $2 | skopeo --insecure-policy copy docker-archive:/dev/stdin docker://$3
              '')
            ];
            config.Entrypoint = [ "entrypoint" ];
          };

        };
      }) // {
      nixosConfigurations =
        {
          metabox = with nixpkgs; lib.nixosSystem {
            system = "x86_64-linux";
            modules =
              [ ./systems/metabox/configuration.nix sops-nix.nixosModules.sops ];
          };
          dex = with nixpkgs; lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./systems/dex/configuration.nix ];
          };
          Book = with nixpkgs; lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./systems/Book/configuration.nix ];
          };
          g = with nixpkgs; lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./systems/g/configuration.nix ];
          };
        };
    };
}
