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
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = f: nixpkgs.lib.genAttrs systems (system: f system);

      createHomeConfig =
        config@{ system, homeDirectory, username, extraImports ? [ ], ... }:
        let
          pkgs = import nixpkgs-unstable {
            system = system;
            config.allowUnfree = true;
          };

          pkgs-release = import nixpkgs-release {
            system = system;
            config.allowUnfree = true;
          };
        in (home-manager.lib.homeManagerConfiguration {
          extraModules = [ nix-doom-emacs.hmModule ];
          configuration = {
            imports = [
              (_: {
                home.packages = [
                  envy-sh.defaultPackage.x86_64-linux
                  (import arion { pkgs = pkgs; }).arion
                  (import ./modules/unified-language-server {
                    pkgs = pkgs;
                  }).unified-language-server
                  pkgs-release.csvkit
                ];

              })
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
          system = system;
          homeDirectory = homeDirectory;
          username = username;
          pkgs = pkgs;
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
            configName = "${name}.${system}";
            system = system;
          })))) configs;
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration.nix sops-nix.nixosModules.sops ];
        };
        dex = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./systems/dex/configuration.nix ];
        };
        downloader = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./downloader.nix ];
        };
      };
      devShell.x86_64-linux = pkgs.mkShell {
        sopsPGPKeyDirs = [ "./keys/hosts" "./keys/users" ];
        nativeBuildInputs = [ (pkgs.callPackage sops-nix { }).sops-pgp-hook ];
      };
    };
}
