inputs@{ dap-adapters
, repos
, personal
, kmonad
, poetry2nix
, ...
}:
[
  personal.overlay
  dap-adapters.overlay
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
  repos.overlay
  kmonad.overlays.default
  poetry2nix.overlay
]
