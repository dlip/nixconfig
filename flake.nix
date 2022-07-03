{
  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
  };

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/70824bb5c790b820b189f62f643f795b1d2ade2e";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vim-plugins = {
      url = "path:./overlays/vimPlugins";
    };
    dap-adapters = {
      url = "path:./overlays/dapAdapters";
    };
    repos = {
      url = "path:./overlays/repos";
    };
    personal = {
      url = "./overlays/personal";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    poetry2nix = {
      url = "github:nix-community/poetry2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    # neovim = {
    #   url = "github:neovim/neovim/v0.6.0?dir=contrib";
    #   inputs.nixpkgs.follows = "nixpkgs";
    #   inputs.flake-utils.follows = "flake-utils";
    # };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , flake-utils
    , vim-plugins
    , dap-adapters
    , repos
    , personal
    , kmonad
    , nix-on-droid
    , poetry2nix
    }:
    let
      pkgsForSystem = { system, pkgs ? nixpkgs }: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          personal.overlay
          dap-adapters.overlay
          vim-plugins.overlay
          repos.overlay
          kmonad.overlays.default
          poetry2nix.overlay
          # (import ./overlays/personal/pythonPackages)
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
      (system:
      let
        pkgs = pkgsForSystem { inherit system; };

        createHomeConfiguration = name: config:
          flake-utils.lib.mkApp
            {
              drv =
                (home-manager.lib.homeManagerConfiguration
                  {
                    inherit pkgs system;
                    inherit (config) homeDirectory username;
                    configuration = { imports = config.imports; };
                  }
                ).activationPackage;
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
          homeConfigurations = builtins.mapAttrs createHomeConfiguration configs;
        };
        packages = with pkgs; {
          inherit juliusSpeech;
          pushNixStoreDockerImage = (pkgs.callPackage ./pkgs/pushNixStoreDockerImage { });
        };
      }) // (
      {
        nixosConfigurations =
          {
            metabox = nixpkgs.lib.nixosSystem rec {
              system = "x86_64-linux";
              pkgs = pkgsForSystem { system = "x86_64-linux"; };
              modules =
                [
                  ./systems/metabox/configuration.nix
                  kmonad.nixosModules.default
                  home-manager.nixosModules.home-manager
                  pkgs.sops-nix.nixosModule
                  {
                    home-manager = {
                      useGlobalPkgs = true;
                      useUserPackages = true;
                      users = {
                        dane = {
                          home.email = "dane.lipscombe@immutable.com.au";
                          home.xrandrCommand = "xrandr --auto --output HDMI-0 --mode 1920x1080 --right-of eDP-1-1";
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
              pkgs = pkgsForSystem { system = "x86_64-linux"; };
              modules = [
                ./systems/dex/configuration.nix
                home-manager.nixosModules.home-manager
                pkgs.sops-nix.nixosModule
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users = {
                      dane = {
                        imports = [
                          ./home
                          ./home/desktop.nix
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
              pkgs = pkgsForSystem { system = "x86_64-linux"; };
              modules = [
                ./systems/g/configuration.nix
                kmonad.nixosModules.default
                pkgs.sops-nix.nixosModule
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users = {
                      dane = {
                        home.xrandrCommand = "xrandr --auto --output HDMI-0 --mode 1920x1080 --right-of eDP-1-1";
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
          };
      }
    ) // ({
      nixOnDroidConfigurations = {
        device = nix-on-droid.lib.nixOnDroidConfiguration {
          config = ./systems/nix-on-droid/configuration.nix;
          system = "aarch64-linux";
          pkgs = pkgsForSystem { system = "aarch64-linux"; };
        };
      };
    });
}
