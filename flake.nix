{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-20.09";
    nixpkgs-release.url = "github:NixOS/nixpkgs/release-20.09";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
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
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-release
    , nixpkgs-unstable
    , nix-doom-emacs
    , home-manager
    , envy-sh
    , arion
    , sops-nix
    , flake-compat
    , flake-utils
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        overlays = [
          (final: prev: {
            my = final.callPackage ./pkgs { };
            envy-sh = envy-sh.defaultPackage.${system};
            inherit (final.callPackage arion { }) arion;
          })
        ];

        pkgs = import nixpkgs-unstable {
          inherit system;
          inherit overlays;
          config.allowUnfree = true;
        };

        pkgs-release = import nixpkgs-release {
          inherit system;
          inherit overlays;
          config.allowUnfree = true;
        };

        createHomeConfig = configName: config@{ extraImports ? [ ], ... }:
          flake-utils.lib.mkApp
            {
              drv = (home-manager.lib.homeManagerConfiguration
                {
                  inherit pkgs;
                  inherit (config) system homeDirectory username;
                  extraModules = [ nix-doom-emacs.hmModule ];
                  configuration = {
                    imports = [
                      (_: { home.packages = [ pkgs-release.csvkit ]; })
                      ./emacs.nix
                      ./files.nix
                      (import ./git.nix config)
                      ./neovim.nix
                      ./packages.nix
                      ./starship.nix
                      ./services.nix
                      ./tmux.nix
                      (import ./zsh.nix (config // {
                        inherit configName;
                      }))
                    ] ++ extraImports;
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

          personal-nixos = personal // { extraImports = [ ./graphical.nix ]; };

          tv = rec {
            username = "tv";
            homeDirectory = "/home/tv";
            name = "TV Lipscombe";
            email = "tv@lipscombe.com.au";
            nixConfigPath = homeDirectory + "/code/nixconfig";
            extraImports = [ ./tv.nix ./emulation.nix ];
          };

          immutable = personal // { email = "dane.lipscombe@immutable.com"; };

          immutable-nixos = immutable // { extraImports = [ ./graphical.nix ]; };

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
      }) // {
      nixosConfigurations = with nixpkgs;
        {
          metabox = lib.nixosSystem {
            system = "x86_64-linux";
            modules =
              [ ./systems/metabox/configuration.nix sops-nix.nixosModules.sops ];
          };
          dex = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./systems/dex/configuration.nix ];
          };
          Book = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./systems/Book/configuration.nix ];
          };
        };
    };
}
