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
  };

  outputs = { self, nixpkgs, nixpkgs-release, nixpkgs-unstable, nix-doom-emacs
    , home-manager, envy-sh, arion, sops-nix }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = f: lib.genAttrs systems (system: f system);

      createHomeConfig = config@{ system, extraImports ? [ ], ... }:
        let
          pkgs = import nixpkgs-unstable {
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

          pkgs-release = import nixpkgs-release {
            inherit system;
            config.allowUnfree = true;
          };
        in (home-manager.lib.homeManagerConfiguration {
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
          extraImports = [ ./tv.nix ];
        };

        immutable = personal // { email = "dane.lipscombe@immutable.com"; };

        immutable-nixos = immutable // { extraImports = [ ./graphical.nix ]; };

        root = personal // {
          username = "root";
          homeDirectory = "/root";
        };
      };

    in rec {
      pkgs = import nixpkgs-unstable { system = "x86_64-linux"; };
      homeConfigurations = builtins.mapAttrs (name: config:
        (forAllSystems (system:
          createHomeConfig (config // {
            inherit system;
            configName = "${name}.${system}";
          })))) configs;
      nixosConfigurations = {
        metabox = lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            [ ./systems/metabox/configuration.nix sops-nix.nixosModules.sops ];
        };
        dex = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./systems/dex/configuration.nix ];
        };
      };
      devShell.x86_64-linux = pkgs.mkShell {
        sopsPGPKeyDirs = [ "./keys/hosts" "./keys/users" ];
        nativeBuildInputs = [ (pkgs.callPackage sops-nix { }).sops-pgp-hook ];
      };
    };
}
