{ dap-adapters
, vim-plugins
, repos
, personal
, kmonad
, poetry2nix
, ...
}:
[
  personal.overlay
  dap-adapters.overlay
  vim-plugins.overlay
  repos.overlay
  kmonad.overlays.default
  poetry2nix.overlay
]
