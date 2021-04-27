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
      createConfig = config@{ homeDirectory, username, ... }:
        home-manager.lib.homeManagerConfiguration {
          extraModules = [ nix-doom-emacs.hmModule ];
          configuration = {
            imports = [
              ./emacs.nix
              ./files.nix
              (import ./git.nix config)
              (import ./packages.nix [ envy-sh.defaultPackage.x86_64-linux ])
              ./starship.nix
              ./tmux.nix
              ./zsh.nix
            ];
          };
          system = "x86_64-linux";
          homeDirectory = homeDirectory;
          username = username;
        };

      configs = rec {
        personal = {
          username = "dane";
          homeDirectory = "/home/dane";
          name = "Dane Lipscombe";
          email = "dane@lipscombe.com.au";
        };

        immutable = personal // { email = "dane.lipscombe@immutable.com"; };
        root = personal // {
          username = "root";
          homeDirectory = "/root";
        };
      };

    in builtins.mapAttrs (_: config: createConfig config) configs;
}
