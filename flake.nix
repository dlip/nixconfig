{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:t184256/nix-on-droid/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    arion = {
      url = "github:hercules-ci/arion";
    };
    envy-sh = {
      url = "github:dlip/envy.sh";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    actual-server = {
      url = "github:actualbudget/actual-server";
      flake = false;
    };
    emoji-menu = {
      url = "github:jchook/emoji-menu";
      flake = false;
    };
    keyd = {
      url = "github:rvaiya/keyd";
      flake = false;
    };
    power-menu = {
      url = "github:jluttine/rofi-power-menu";
      flake = false;
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    repo-nnn = {
      url = "github:jarun/nnn";
      flake = false;
    };
    # helix = {
    #   url = "github:helix-editor/helix";
    # };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-unstable,
    home-manager,
    flake-utils,
    nix-on-droid,
    kmonad,
    sops-nix,
    arion,
    ...
  }: let
    pkgsForSystem = {
      system,
      pkgs ? nixpkgs,
    }:
      import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays =
          (import ./overlays inputs)
          ++ [
            (final: prev: {
              unstable = pkgsForSystem {
                inherit system;
                pkgs = nixpkgs-unstable;
              };
            })
          ];
      };

    configs = rec {
      dane = {
        username = "dane";
        homeDirectory = "/home/dane";
        imports = [
          ./home
        ];
      };
    };
  in
    flake-utils.lib.eachDefaultSystem
    (system: let
      pkgs = pkgsForSystem {inherit system;};

      createHomeConfiguration = name: config:
        flake-utils.lib.mkApp
        {
          drv =
            (
              home-manager.lib.homeManagerConfiguration
              {
                inherit pkgs system;
                inherit (config) homeDirectory username;
                configuration = {imports = config.imports;};
              }
            )
            .activationPackage;
        };
    in rec {
      inherit pkgs;
      defaultApp = apps.repl;
      apps = {
        repl =
          flake-utils.lib.mkApp
          {
            drv = pkgs.writeShellScriptBin "repl" ''
              confnix=$(mktemp)
              echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" >$confnix
              trap "rm $confnix" EXIT
              nix repl $confnix
            '';
          };
        homeConfigurations = builtins.mapAttrs createHomeConfiguration configs;
      };
      packages = with pkgs; {
        inherit actualServer;

        pushNixStoreDockerImage = pkgs.callPackage ./pkgs/pushNixStoreDockerImage {};
      };
    })
    // {
      nixosConfigurations = {
        metabox = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = pkgsForSystem {system = "x86_64-linux";};
          modules = [
            ./systems/metabox/configuration.nix
            kmonad.nixosModules.default
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users = {
                  dane = {
                    home.email = "dane.lipscombe@immutable.com.au";
                    imports = [
                      ./home
                      ./home/desktop.nix
                      ./home/graphical.nix
                      ./home/gaming.nix
                    ];
                  };
                };
              };
            }
          ];
        };
        dex = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = pkgsForSystem {system = "x86_64-linux";};
          modules = [
            ./systems/dex/configuration.nix
            arion.nixosModules.arion
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users = {
                  dane = {
                    imports = [
                      ./home
                      ./home/desktop.nix
                      ./home/graphical.nix
                    ];
                  };
                };
              };
            }
          ];
        };
        g = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = pkgsForSystem {system = "x86_64-linux";};
          modules = [
            ./systems/g/configuration.nix
            kmonad.nixosModules.default
            sops-nix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users = {
                  dane = {
                    imports = [
                      ./home
                      ./home/desktop.nix
                      ./home/graphical.nix
                      ./home/gaming.nix
                    ];
                  };
                };
              };
            }
          ];
        };
        x = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = pkgsForSystem {system = "x86_64-linux";};
          modules = [
            ./systems/x/configuration.nix
            kmonad.nixosModules.default
            sops-nix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users = {
                  dane = {
                    home.email = "dane.lipscombe@planpay.com";
                    imports = [
                      ./home
                      ./home/desktop.nix
                      ./home/graphical.nix
                      ./home/gamedev.nix
                    ];
                  };
                };
              };
            }
          ];
        };
        ptv = nixpkgs.lib.nixosSystem rec {
          system = "x86_64-linux";
          pkgs = pkgsForSystem {system = "x86_64-linux";};
          modules = [
            ./systems/ptv/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users = {
                  tv = {
                    home.name = "TV Lipscombe";
                    home.email = "tv@lipscombe.com.au";
                    imports = [
                      ./home
                    ];
                  };
                };
              };
            }
          ];
        };
      };
    }
    // {
      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        modules = [
          ./systems/nix-on-droid/configuration.nix
        ];
        pkgs = pkgsForSystem {system = "aarch64-linux";};
        home-manager-path = home-manager.outPath;
      };
    };
}
