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
  };

  outputs = { self, nixpkgs, nixpkgs-release, nixpkgs-unstable, nix-doom-emacs
    , home-manager, envy-sh, arion }:
    let
      pkgs = import nixpkgs-unstable {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      pkgs-release = import nixpkgs-release {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };

      createHomeConfig =
        config@{ homeDirectory, username, extraImports ? [ ], ... }:
        (home-manager.lib.homeManagerConfiguration {
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
              ./tmux.nix
              (import ./zsh.nix config)
            ] ++ extraImports;
          };
          system = "x86_64-linux";
          homeDirectory = homeDirectory;
          username = username;
          pkgs = pkgs;
        }).activationPackage;

      configs = rec {
        personal = rec {
          configName = "personal";
          username = "dane";
          homeDirectory = "/home/dane";
          name = "Dane Lipscombe";
          email = "dane@lipscombe.com.au";
          nixConfigPath = homeDirectory + "/code/nixconfig";
        };

        personal-nixos = personal // {
          configName = "personal-nixos";
          extraImports = [ ./graphical.nix ];
        };

        immutable = personal // {
          configName = "immutable";
          email = "dane.lipscombe@immutable.com";
        };

        immutable-nixos = immutable // {
          configName = "immutable-nixos";
          extraImports = [ ./graphical.nix ];
        };

        root = personal // {
          configName = "root";
          username = "root";
          homeDirectory = "/root";
        };
      };

    in {
      pkgs = pkgs;
      homeConfigurations =
        builtins.mapAttrs (_: config: createHomeConfig config) configs;
      nixosConfigurations = {
        nixos = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./configuration.nix ];
        };
        dex = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./dex.nix ];
        };
      };
    };
}
