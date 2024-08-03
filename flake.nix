{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.05";
    flake-utils = {
      url = "github:numtide/flake-utils";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprland = {
      url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    hyprcursor-catppuccin = {
      url = "github:NotAShelf/hyprcursor-catppuccin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    # kanata = {
    #   url = "github:jtroo/kanata";
    #   flake = false;
    # };
    nix-on-droid = {
      url = "github:t184256/nix-on-droid/release-22.11";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    actual-server = {
      url = "github:actualbudget/actual-server";
      flake = false;
    };
    emoji-menu = {
      url = "github:jchook/emoji-menu";
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
    helix = {
      url = "github:mattwparas/helix/steel-event-system";
    };
    mac-app-util.url = "github:hraban/mac-app-util";
    vimplugin-telescope-gitsigns = {
      url = "github:radyz/telescope-gitsigns";
      flake = false;
    };
    vimplugin-one-small-step-for-vimkind = {
      url = "github:jbyuki/one-small-step-for-vimkind";
      flake = false;
    };
    vimplugin-nu = {
      url = "github:LhKipp/nvim-nu";
      flake = false;
    };
    repo-nnn = {
      url = "github:jarun/nnn";
      flake = false;
    };
    repo-tmux-catppuccin = {
      url = "github:catppuccin/tmux";
      flake = false;
    };
    repo-catppuccin-zsh-syntax-highlighting = {
      url = "github:catppuccin/zsh-syntax-highlighting";
      flake = false;
    };
    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-23.05";

      # inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    home-manager,
    flake-utils,
    nix-on-droid,
    sops-nix,
    nix-darwin,
    ...
  }: let
    pkgsForSystem = {
      system,
      pkgs ? nixpkgs,
    }:
      import pkgs {
        inherit system;
        config.allowUnfree = true;
        # https://github.com/NixOS/nixpkgs/issues/273611
        config.permittedInsecurePackages = [
          "electron-25.9.0"
        ];
        overlays =
          (import ./overlays inputs)
          ++ [
            (final: prev: {
              stable = pkgsForSystem {
                inherit system;
                pkgs = nixpkgs-stable;
              };
            })
          ];
      };

    configs = {
      dane = [
        ./home
        {
          home = {
            username = "dane";
            homeDirectory = "/home/dane";
          };
        }
      ];
      docker = [
        ./home/default.nix
        ./home/desktop.nix
        {
          home = {
            username = "root";
            homeDirectory = "/root";
          };
        }
      ];
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
                inherit pkgs;
                modules = config;
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
      devShell = pkgs.mkShell {
        buildInputs = [
          pkgs.nixvim
        ];
      };
    })
    // {
      nixosConfigurations = {
        metabox = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = pkgsForSystem {system = "x86_64-linux";};
          modules = [
            ./systems/metabox/configuration.nix
            sops-nix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users = {
                  dane = {
                    imports = [
                      ./home/linux-desktop.nix
                      ./home/gamedev.nix
                      ./home/gaming.nix
                    ];
                  };
                };
              };
            }
          ];
        };
        dex = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = pkgsForSystem {system = "x86_64-linux";};
          modules = [
            ./systems/dex/configuration.nix
            home-manager.nixosModules.home-manager
            sops-nix.nixosModules.default
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users = {
                  dane = {
                    imports = [
                      ./home/linux-desktop.nix
                    ];
                  };
                };
              };
            }
          ];
        };
        g = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = pkgsForSystem {system = "x86_64-linux";};
          modules = [
            ./systems/g/configuration.nix
            sops-nix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                users = {
                  dane = {
                    imports = [
                      ./home/linux-desktop.nix
                      ./home/gaming.nix
                    ];
                  };
                };
              };
            }
          ];
        };
        x = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";
          pkgs = pkgsForSystem {system = "x86_64-linux";};
          modules = [
            ./systems/x/configuration.nix
            sops-nix.nixosModules.default
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                backupFileExtension = "backup";
                users = {
                  dane = {
                    home.email = "dane.lipscombe@planpay.com";
                    imports = [
                      ./home/linux-desktop.nix
                      ./home/linux-graphical.nix
                      ./home/gamedev.nix
                      ./home/gaming.nix
                    ];
                  };
                };
              };
            }
          ];
        };
        ptv = nixpkgs.lib.nixosSystem {
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
                      ./home/default.nix
                    ];
                  };
                };
              };
            }
          ];
        };
      };
      # nix-on-droid switch --flake .#default
      nixOnDroidConfigurations.default = nix-on-droid.lib.nixOnDroidConfiguration {
        modules = [
          ./systems/nix-on-droid/configuration.nix
          {
            # Configure home-manager
            home-manager = {
              config = ./home/nix-on-droid.nix;
              backupFileExtension = "hm-bak";
              useGlobalPkgs = true;
            };
          }
        ];
        pkgs = pkgsForSystem {system = "aarch64-linux";};
        home-manager-path = home-manager.outPath;
      };
      # nix run nix-darwin -- switch --flake .#default
      darwinConfigurations.default = nix-darwin.lib.darwinSystem {
        modules = [
          ./systems/darwin/configuration.nix
          home-manager.darwinModules.default
          {
            users.users.dane.home = "/Users/dane";
            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              backupFileExtension = "backup";
              users = {
                dane = {
                  home = {
                    email = "danelipscombe@gmail.com";
                  };
                  imports = [
                    ./home/macos.nix
                  ];
                };
              };
            };
          }
        ];
        specialArgs = {pkgs = pkgsForSystem {system = "aarch64-darwin";};};
      };
    };
}
