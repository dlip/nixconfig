inputs@{ kmonad
, poetry2nix
, actual-server
, envy-sh
, emoji-menu
, power-menu
, sops-nix
, vscodeNodeDebug2
, ...
}:
[
  kmonad.overlays.default
  poetry2nix.overlay
  # packages
  (final: prev: {
    inherit sops-nix;
    actualServer = final.callPackage ./actualServer { src = actual-server; nodejs = final.nodejs-16_x; };
    envy-sh = envy-sh.defaultPackage.${final.system};
    emoji-menu = final.writeShellScriptBin "emoji-menu" (builtins.readFile "${emoji-menu}/bin/emoji-menu");
    myEspanso = final.callPackage ./espanso { };
    power-menu = final.writeShellScriptBin "power-menu" (builtins.readFile "${power-menu}/rofi-power-menu");
    nnn = prev.nnn.overrideAttrs (oldAttrs: {
      makeFlags = oldAttrs.makeFlags ++ [ "O_NERD=1" ];
    });
    vscodeNodeDebug2 = final.callPackage ./vscodeNodeDebug2 { src = vscodeNodeDebug2; };
    # myNodePackages = final.callPackage ./nodePackages { };
    # myPythonPackages = final.callPackage ./pythonPackages { };
    # skyscraper = final.callPackage ./skyscraper { };
    # solang = final.callPackage ./solang { };
    # juliusSpeech = final.callPackage ./juliusSpeech { };
    # talon = final.callPackage ./talon { };
    # inherit (final.callPackages "${openvpn-aws}/derivations/openvpn.nix" { }) openvpn_aws;
  })
  # Repos with no build step
  (final: prev: prev.lib.filterAttrs (k: v: prev.lib.hasPrefix "repo" k) inputs)
  # vim plugins
  (final: prev:
    {
      vimPlugins = prev.vimPlugins // builtins.listToAttrs (map
        (input:
          let name = final.lib.removePrefix "vimplugin-" input; in
          {
            inherit name;
            value = (final.vimUtils.buildVimPluginFrom2Nix {
              inherit name;
              pname = name;
              src = (builtins.getAttr input inputs);
            });
          })
        (builtins.attrNames (final.lib.filterAttrs (k: v: final.lib.hasPrefix "vimplugin" k) inputs)));
    })
]
