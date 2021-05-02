{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs.url = "github:vlaci/nix-doom-emacs";
    envy-sh.url = "github:dlip/envy.sh";
  };

  outputs = { self, nixpkgs, nix-doom-emacs, home-manager, envy-sh }:
    let
      createConfig =
        config@{ homeDirectory, username, extraImports ? [ ], ... }:
        home-manager.lib.homeManagerConfiguration {
          extraModules = [ nix-doom-emacs.hmModule ];
          configuration = {
            imports = [
              (_: { home.packages = [ envy-sh.defaultPackage.x86_64-linux ]; })
              ./emacs.nix
              ./files.nix
              (import ./git.nix config)
              ./packages.nix
              ./starship.nix
              ./tmux.nix
              (import ./zsh.nix config)
            ] ++ extraImports;
          };
          system = "x86_64-linux";
          homeDirectory = homeDirectory;
          username = username;
          pkgs = import nixpkgs {
            system = "x86_64-linux";
            config.allowUnfree = true;
          };
        };

      configs = rec {
        personal = {
          configName = "personal";
          username = "dane";
          homeDirectory = "/home/dane";
          name = "Dane Lipscombe";
          email = "dane@lipscombe.com.au";
        };

        personal-nixos = personal // {
          configName = "personal-nixos";
          extraImports = [ ./graphical.nix ];
        };

        immutable = personal // {
          configName = "immutable";
          email = "dane.lipscombe@immutable.com";
        };

        immutable-nixos = immutable // {
          configName = "immutable-nixos";
          extraImports = [ ./graphical.nix ];
        };

        root = personal // {
          configName = "root";
          username = "root";
          homeDirectory = "/root";
        };
      };

    in builtins.mapAttrs (_: config: createConfig config) configs;
}
