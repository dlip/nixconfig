{
  inputs = {
    nnn-git = {
      url = "github:jarun/nnn";
      flake = false;
    };
    awesome-wm-widgets = {
      url = "github:streetturtle/awesome-wm-widgets";
      flake = false;
    };
    arc-icon-theme = {
      url = "github:horst3180/arc-icon-theme";
      flake = false;
    };
    json-lua = {
      url = "github:rxi/json.lua";
      flake = false;
    };
  };

  outputs =
    inputs: {
      overlay = self: super:
        builtins.listToAttrs (map
          (input: {
            name = input;
            value = inputs."${input}";
          })
          (builtins.attrNames (super.lib.filterAttrs (n: v: n != "self") inputs)));
    };
}
