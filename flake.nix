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
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    vimPlugins = {
      url = "path:overlays/vimPlugins";
    };
    other = {
      url = "path:overlays/other";
    };
    envy-sh = {
      url = "github:dlip/envy.sh";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    kmonad = {
      url = "github:kmonad/kmonad?dir=nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    emoji-menu = {
      url = "github:jchook/emoji-menu";
      flake = false;
    };
    power-menu = {
      url = "github:jluttine/rofi-power-menu";
      flake = false;
    };
    wally-cli = {
      url = "github:zsa/wally-cli";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    neovim = {
      url = "github:neovim/neovim?dir=contrib";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    { self
    , nixpkgs
    , home-manager
    , envy-sh
    , flake-utils
    , kmonad
    , emoji-menu
    , power-menu
    , wally-cli
    , neovim
    , vimPlugins
    , other
    }:
    let
      pkgsForSystem = system: import nixpkgs {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            envy-sh = envy-sh.defaultPackage.${system};
            emoji-menu = final.writeShellScriptBin "emoji-menu" (builtins.readFile "${emoji-menu}/bin/emoji-menu");
            power-menu = final.writeShellScriptBin "power-menu" (builtins.readFile "${power-menu}/rofi-power-menu");
            wally-cli = wally-cli.defaultPackage.${system};
            nnn = prev.nnn.overrideAttrs (oldAttrs: {
              makeFlags = oldAttrs.makeFlags ++ [ "O_NERD=1" ];
            });
          })
          (import ./pkgs)
          neovim.overlay
          vimPlugins.overlay
          other.overlay
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
                          home.email = "dane@immutable.com.au";
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
