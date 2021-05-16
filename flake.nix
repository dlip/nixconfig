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
        pkgs = import nixpkgs-unstable rec {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              my = import ./pkgs { inherit pkgs; };
              envy-sh = envy-sh.defaultPackage.${system};
              inherit (import arion { inherit pkgs; }) arion;
            })
          ];
        };

        pkgs-release = import nixpkgs-release rec {
          inherit system;
          config.allowUnfree = true;
        };

        createHomeConfig = config@{ extraImports ? [ ], ... }:
          (home-manager.lib.homeManagerConfiguration {
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
                (import ./zsh.nix config)
              ] ++ extraImports;
            };
          }).activationPackage;

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

        homeConfigurations = builtins.mapAttrs
          (name: config:
            createHomeConfig (config // {
              configName = "${system}.${name}";
            }))
          configs;

        defaultApp = apps.repl;
        apps.repl = flake-utils.lib.mkApp
          {
            drv = pkgs.writeShellScriptBin "repl" ''
              confnix=$(mktemp)
              echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" >$confnix
              trap "rm $confnix" EXIT
              nix repl $confnix
            '';
          };

        devShell = pkgs.mkShell {
          sopsPGPKeyDirs = [ "./keys/hosts" "./keys/users" ];
          nativeBuildInputs = with pkgs; [ (callPackage sops-nix { }).sops-pgp-hook ];
        };
      }) // {
      nixosConfigurations = {
        metabox = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            [ ./systems/metabox/configuration.nix sops-nix.nixosModules.sops ];
        };
        dex = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./systems/dex/configuration.nix ];
        };
      };
    };
}
