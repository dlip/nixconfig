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
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vim-plugins = {
      url = "path:overlays/vimPlugins";
    };
    repos = {
      url = "path:overlays/repos";
    };
    personal = {
      url = "path:overlays/personal";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-on-droid = {
      url = "github:t184256/nix-on-droid";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
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
    , repos
    , personal
    , kmonad
    , sops-nix
    , nix-on-droid
    }:
    let
      pkgsForSystem = { system, pkgs ? nixpkgs }: import pkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          personal.overlay
          vim-plugins.overlay
          repos.overlay
          kmonad.overlay
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
        packages = {
          rescript = (pkgs.callPackage ./home/vscode/rescript { });
          solang = (pkgs.callPackage ./pkgs/solang { });
          pushNixStoreDockerImage = (pkgs.callPackage ./pkgs/pushNixStoreDockerImage { });
        };
      }) // (
      {
        nixosConfigurations =
          {
            metabox = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              pkgs = pkgsForSystem { system = "x86_64-linux"; };
              modules =
                [
                  ./systems/metabox/configuration.nix
                  kmonad.nixosModule
                  home-manager.nixosModules.home-manager
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
                            ./home/graphical.nix
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
              pkgs = pkgsForSystem { system = "x86_64-linux"; };
              modules = [
                ./systems/dex/configuration.nix
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users = {
                      dane = {
                        imports = [
                          ./home
                        ];
                      };
                      tv = {
                        home.name = "TV Lipscombe";
                        home.email = "tv@lipscombe.com.au";
                        imports = [
                          ./home
                          ./home/media.nix
                          ./home/emulation.nix
                        ];
                      };
                    };
                  };
                }
              ];
            };
            g = nixpkgs.lib.nixosSystem {
              system = "x86_64-linux";
              pkgs = pkgsForSystem { system = "x86_64-linux"; };
              modules = [
                ./systems/g/configuration.nix
                kmonad.nixosModule
                sops-nix.nixosModules.sops
                home-manager.nixosModules.home-manager
                {
                  home-manager = {
                    useGlobalPkgs = true;
                    useUserPackages = true;
                    users = {
                      dane = {
                        imports = [
                          ./home
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
