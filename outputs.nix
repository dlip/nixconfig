inputs@{ self
, nixpkgs
, nixpkgs-unstable
, home-manager
, flake-utils
, nix-on-droid
, kmonad
, ...
}:
let
  pkgsForSystem = { system, pkgs ? nixpkgs }: import pkgs {
    inherit system;
    config.allowUnfree = true;
    overlays = (import ./overlays inputs) ++
      [ (final: prev: { unstable = pkgsForSystem { inherit system; pkgs = nixpkgs-unstable; }; }) ];
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
        inherit actualServer;

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
          pkgs = pkgsForSystem { system = "x86_64-linux"; };
          modules = [
            ./systems/g/configuration.nix
            kmonad.nixosModules.default
            pkgs.sops-nix.nixosModule
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
          pkgs = pkgsForSystem { system = "x86_64-linux"; };
          modules = [
            ./systems/x/configuration.nix
            kmonad.nixosModules.default
            pkgs.sops-nix.nixosModule
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
})
