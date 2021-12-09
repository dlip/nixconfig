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
    neovim = {
      url = "github:neovim/neovim/v0.5.1?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , flake-utils
    , kmonad
    , neovim
    , vim-plugins
    , repos
    , personal
    }:
    let
      pkgsForSystem = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          personal.overlay
          neovim.overlay
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
        pkgs = pkgsForSystem system;

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
              pkgs = pkgsForSystem "x86_64-linux";
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
              pkgs = pkgsForSystem "x86_64-linux";
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
              pkgs = pkgsForSystem "x86_64-linux";
              modules = [
                ./systems/g/configuration.nix
                kmonad.nixosModule
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
    );
}
