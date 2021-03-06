{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils = {
      url = "github:numtide/flake-utils";
      inputs.nixpkgs.follows = "nixpkgs";
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
  };

  outputs =
    { self
    , nixpkgs
    , flake-utils
    , actual-server
    , envy-sh
    , emoji-menu
    , power-menu
    , sops-nix
    , openvpn-aws
    }:
    {
      overlay = final: prev: {
        actualServer = final.callPackage ./actualServer { src = actual-server; };
        envy-sh = envy-sh.defaultPackage.${final.system};
        emoji-menu = final.writeShellScriptBin "emoji-menu" (builtins.readFile "${emoji-menu}/bin/emoji-menu");
        power-menu = final.writeShellScriptBin "power-menu" (builtins.readFile "${power-menu}/rofi-power-menu");
        nnn = prev.nnn.overrideAttrs (oldAttrs: {
          makeFlags = oldAttrs.makeFlags ++ [ "O_NERD=1" ];
        });
        myNodePackages = final.callPackage ./nodePackages { };
        myPythonPackages = final.callPackage ./pythonPackages { };
        scripts = final.callPackage ./scripts { };
        skyscraper = final.callPackage ./skyscraper { };
        solang = final.callPackage ./solang { };
        juliusSpeech = final.callPackage ./juliusSpeech { };
        # talon = final.callPackage ./talon { };
        inherit sops-nix;
        inherit (final.callPackages "${openvpn-aws}/derivations/openvpn.nix" { }) openvpn_aws;
      };
    };
}
