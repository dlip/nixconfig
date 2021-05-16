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
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    { self
    , nixpkgs
    , nixpkgs-release
    , nixpkgs-unstable
    , nix-doom-emacs
    , home-manager
    , envy-sh
    , arion
    , sops-nix
    , flake-compat
    , flake-utils
    }:
    let
      inherit (nixpkgs) lib;
      systems = [
        "x86_64-linux"
        "i686-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "armv6l-linux"
        "armv7l-linux"
      ];
      forAllSystems = f: lib.genAttrs systems (system: f system);
      forAllSystemPackages = p: f: (forAllSystems (system: f p.${system}));

      getPkgs = (system: import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
        overlays = [
          (final: prev: {
            my = import ./pkgs { pkgs = getPkgs system; };
            envy-sh = envy-sh.defaultPackage.${system};
            inherit (import arion { pkgs = getPkgs system; }) arion;
          })
        ];
      });

      getPkgs-release = (system: import nixpkgs-release {
        inherit system;
        config.allowUnfree = true;
      });

      createHomeConfig = config@{ system, extraImports ? [ ], ... }:
        let
          pkgs = getPkgs system;
          pkgs-release = getPkgs-release system;
        in
        (home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          inherit (config) system homeDirectory username;
          extraModules = [ nix-doom-emacs.hmModule ];
          configuration = {
            imports = [
              (_: { home.packages = [ pkgs-release.csvkit ]; })
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

        tv = rec {
          username = "tv";
          homeDirectory = "/home/tv";
          name = "TV Lipscombe";
          email = "tv@lipscombe.com.au";
          nixConfigPath = homeDirectory + "/code/nixconfig";
          extraImports = [ ./tv.nix ./emulation.nix ];
        };

        immutable = personal // { email = "dane.lipscombe@immutable.com"; };

        immutable-nixos = immutable // { extraImports = [ ./graphical.nix ]; };

        root = personal // {
          username = "root";
          homeDirectory = "/root";
        };
      };
    in
    rec {
      pkgs = forAllSystems getPkgs;
      homeConfigurations = (forAllSystems (system:
        builtins.mapAttrs
          (name: config:
            createHomeConfig (config // {
              inherit system;
              configName = "${system}.${name}";
            }))
          configs));
      nixosConfigurations = {
        metabox = lib.nixosSystem {
          system = "x86_64-linux";
          modules =
            [ ./systems/metabox/configuration.nix sops-nix.nixosModules.sops ];
        };
        dex = lib.nixosSystem {
          system = "x86_64-linux";
          modules = [ ./systems/dex/configuration.nix ];
        };
      };
      devShell = forAllSystemPackages pkgs (pkgs: pkgs.mkShell {
        sopsPGPKeyDirs = [ "./keys/hosts" "./keys/users" ];
        nativeBuildInputs = with pkgs; [ (callPackage sops-nix { }).sops-pgp-hook ];
      });
      repl = forAllSystemPackages pkgs (pkgs: flake-utils.lib.mkApp {
        drv = pkgs.writeShellScriptBin "repl" ''
          confnix=$(mktemp)
          echo "builtins.getFlake (toString $(git rev-parse --show-toplevel))" >$confnix
          trap "rm $confnix" EXIT
          nix repl $confnix
        '';
      });
    };
}
