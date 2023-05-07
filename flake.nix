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
    plasma-manager = {
      url = "github:pjones/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    # https://github.com/NixOS/nixpkgs/issues/198137
    # poetry2nix = {
    #   url = "github:nix-community/poetry2nix";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };
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
    openvpn-aws = {
      url = "github:abhibansal530/dotfiles";
      flake = false;
    };
    repo-nnn = {
      url = "github:jarun/nnn";
      flake = false;
    };
    repo-awesome-wm-widgets = {
      url = "github:streetturtle/awesome-wm-widgets";
      flake = false;
    };
    repo-arc-icon-theme = {
      url = "github:horst3180/arc-icon-theme";
      flake = false;
    };
    repo-json-lua = {
      url = "github:rxi/json.lua";
      flake = false;
    };
    helix = {
      url = "github:helix-editor/helix";
    };
    vscodeNodeDebug2 = {
      url = "github:microsoft/vscode-node-debug2";
      flake = false;
    };
    vimplugin-auto-save-nvim = {
      url = "github:pocco81/auto-save.nvim";
      flake = false;
    };
    vimplugin-leap-nvim = {
      url = "github:ggandor/leap.nvim";
      flake = false;
    };
    vimplugin-lsp-format-nvim = {
      url = "github:lukas-reineke/lsp-format.nvim";
      flake = false;
    };
    vimplugin-kmonad-vim = {
      url = "github:kmonad/kmonad-vim";
      flake = false;
    };
    vimplugin-neotest-jest = {
      url = "github:haydenmeade/neotest-jest";
      flake = false;
    };
    vimplugin-neotest-plenary = {
      url = "github:nvim-neotest/neotest-plenary";
      flake = false;
    };
    vimplugin-neotest-vim-test = {
      url = "github:nvim-neotest/neotest-vim-test";
      flake = false;
    };
    vimplugin-nvim-neotest = {
      url = "github:nvim-neotest/neotest";
      flake = false;
    };
    vimplugin-fix-cursor-hold-nvim = {
      url = "github:antoinemadec/FixCursorHold.nvim";
      flake = false;
    };
    vimplugin-nvim-dap-ui = {
      url = "github:rcarriga/nvim-dap-ui";
      flake = false;
    };
    vimplugin-telescope-nvim = {
      url = "github:nvim-telescope/telescope.nvim";
      flake = false;
    };
    vimplugin-vim-test = {
      url = "github:excalios/vim-test";
      flake = false;
    };
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
                sharedModules = [
                  inputs.plasma-manager.homeManagerModules.plasma-manager
                ];
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
                  tv = {
                    home.name = "TV Lipscombe";
                    home.email = "tv@lipscombe.com.au";
                    imports = [
                      ./home
                      ./home/media.nix
                      ./home/desktop.nix
                      ./home/emulation.nix
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
                sharedModules = [
                  inputs.plasma-manager.homeManagerModules.plasma-manager
                ];
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
                sharedModules = [
                  inputs.plasma-manager.homeManagerModules.plasma-manager
                ];
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
      nixOnDroidConfigurations = {
        device = nix-on-droid.lib.nixOnDroidConfiguration {
          config = ./systems/nix-on-droid/configuration.nix;
          system = "aarch64-linux";
          pkgs = pkgsForSystem {system = "aarch64-linux";};
        };
      };
    };
}
