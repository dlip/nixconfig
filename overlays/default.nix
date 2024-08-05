inputs @ {
  # , poetry2nix
  # actual-server,
  emoji-menu,
  power-menu,
  # kanata,
  helix,
  sops-nix,
  nix-on-droid,
  mac-app-util,
  # vscodeNodeDebug2,
  nixvim,
  hyprland,
  hyprcursor-catppuccin,
  ...
}: [
  nix-on-droid.overlays.default
  helix.overlays.default
  # poetry2nix.overlay
  # packages
  (final: prev: {
    inherit sops-nix mac-app-util;
    # actualServer = final.callPackage ./actualServer {
    #   src = actual-server;
    #   nodejs = final.nodejs-16_x;
    # };
    # vscodeNodeDebug2 = final.callPackage ./vscodeNodeDebug2 {src = vscodeNodeDebug2;};
    emoji-menu = final.writeShellScriptBin "emoji-menu" (builtins.readFile "${emoji-menu}/bin/emoji-menu");
    # myEspanso = final.callPackage ./espanso {};
    hyprland = hyprland.packages.${final.system}.hyprland;
    hyprcursor-catppuccin = hyprcursor-catppuccin.packages.${final.system}.hyprcursor-catppuccin;
    power-menu = final.writeShellScriptBin "power-menu" (builtins.readFile "${power-menu}/rofi-power-menu");
    nnn = prev.nnn.overrideAttrs (oldAttrs: {
      makeFlags = oldAttrs.makeFlags ++ ["O_NERD=1"];
    });

    nixvim = nixvim.legacyPackages.${final.system}.makeNixvimWithModule {
      module = import ./nixvim;
      extraSpecialArgs = {
        extraPluginsSrc = final.lib.filterAttrs (n: v: final.lib.hasPrefix "vimplugin-" n) inputs;
      };
    };

    rofimoji = prev.rofimoji.overrideAttrs (oldAttrs: {
      rofi = final.rofi-wayland;
    });
    # kanata = final.callPackage ./kanata {src = kanata;};
    # helix = helix.packages.${final.system}.default;

    myNodePackages = final.callPackage ./nodePackages {};
    # myPythonPackages = final.callPackage ./pythonPackages { };
    # skyscraper = final.callPackage ./skyscraper { };
    # solang = final.callPackage ./solang { };
    # juliusSpeech = final.callPackage ./juliusSpeech { };
    talon = final.callPackage ./talon {};
    # inherit (final.callPackages "${openvpn-aws}/derivations/openvpn.nix" { }) openvpn_aws;
  })
  # Repos with no build step
  (final: prev: prev.lib.filterAttrs (k: v: prev.lib.hasPrefix "repo" k) inputs)
  # vim plugins
  (final: prev: {
    vimPlugins =
      prev.vimPlugins
      // builtins.listToAttrs (map
        (input: let
          name = final.lib.removePrefix "vimplugin-" input;
        in {
          inherit name;
          value = final.vimUtils.buildVimPlugin {
            inherit name;
            pname = name;
            src = builtins.getAttr input inputs;
          };
        })
        (builtins.attrNames (final.lib.filterAttrs (k: v: final.lib.hasPrefix "vimplugin" k) inputs)));
  })
]
