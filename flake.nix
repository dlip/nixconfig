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
    kubenix.url = "github:xtruder/kubenix";
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
    , kubenix
    , flake-compat
    , flake-utils
    }:
    flake-utils.lib.eachDefaultSystem
      (system:
      let
        pkgs-release = import nixpkgs-release {
          inherit system;
          config.allowUnfree = true;
        };

        pkgs = import nixpkgs-unstable {
          inherit system;
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              my = final.callPackage ./pkgs { };
              envy-sh = envy-sh.defaultPackage.${system};
              kubenix = kubenix.defaultPackage.${system};
              inherit (final.callPackage arion { }) arion;
              csvkit = pkgs-release.csvkit; # unstable has a build error
            })
          ];
        };

        createHomeConfig = configName: config@{ extraImports ? [ ], ... }:
          flake-utils.lib.mkApp
            {
              drv =
                (home-manager.lib.homeManagerConfiguration
                  {
                    inherit pkgs;
                    inherit (config) system homeDirectory username;
                    extraModules = [ nix-doom-emacs.hmModule ];
                    configuration = {
                      imports = (import ./home { inherit config; inherit configName; }) ++ extraImports;
                    };
                  }
                ).activationPackage;
            };

        k8sConfig = kubenix.defaultPackage.${system}.buildResources { configuration = import ./k8s { }; };

        configs = rec {
          personal = rec {
            username = "dane";
            homeDirectory = "/home/dane";
            name = "Dane Lipscombe";
            email = "dane@lipscombe.com.au";
            nixConfigPath = homeDirectory + "/code/nixconfig";
          };

          personal-nixos = personal // { extraImports = [ ./home/graphical.nix ]; };

          tv = rec {
            username = "tv";
            homeDirectory = "/home/tv";
            name = "TV Lipscombe";
            email = "tv@lipscombe.com.au";
            nixConfigPath = homeDirectory + "/code/nixconfig";
            extraImports = [ ./home/media.nix ./home/emulation.nix ];
          };

          immutable = personal // { email = "dane.lipscombe@immutable.com"; };

          immutable-nixos = immutable // { extraImports = [ ./home/graphical.nix ]; };

          root = personal // {
            username = "root";
            homeDirectory = "/root";
          };
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
          k8s = flake-utils.lib.mkApp
            {
              drv = with pkgs; writeShellScriptBin "k8s" ''
                set -euo pipefail
                ${kubectl}/bin/kubectl apply -f https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml
                ${kubectl}/bin/kubectl apply -f https://storage.googleapis.com/tekton-releases/dashboard/latest/tekton-dashboard-release.yaml
                ${kubernetes-helm}/bin/helm repo add traefik https://helm.traefik.io/traefik
                ${kubernetes-helm}/bin/helm upgrade --install traefik traefik/traefik -f k8s/traefik.yaml -n kube-system --wait
                ${kubectl}/bin/kubectl apply -f ${k8sConfig}
              '';
            };
          homeConfigurations = builtins.mapAttrs createHomeConfig configs;
        };
        devShell = pkgs.mkShell {
          sopsPGPKeyDirs = [ "./keys/hosts" "./keys/users" ];
          nativeBuildInputs = with pkgs; [ (callPackage sops-nix { }).sops-pgp-hook ];
        };
        packages = {
          pushNixStoreDockerImage = with pkgs; dockerTools.buildLayeredImage {
            name = "push-nix-store-docker-image";
            tag = "latest";
            contents = [
              coreutils
              skopeo
              cacert
              nixUnstable
              (writeScriptBin "entrypoint" ''
                #!${runtimeShell}
                set -euo pipefail
                mkdir -p /var/tmp
                nix --experimental-features nix-command store cat --store $1 $2 | skopeo --insecure-policy copy docker-archive:/dev/stdin docker://$3
              '')
            ];
            config.Entrypoint = [ "entrypoint" ];
          };

        };
      }) // {
      nixosConfigurations = with nixpkgs;
        {
          metabox = lib.nixosSystem {
            system = "x86_64-linux";
            modules =
              [ ./systems/metabox/configuration.nix sops-nix.nixosModules.sops ];
          };
          dex = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./systems/dex/configuration.nix ];
          };
          Book = lib.nixosSystem {
            system = "x86_64-linux";
            modules = [ ./systems/Book/configuration.nix ];
          };
        };
    };
}
