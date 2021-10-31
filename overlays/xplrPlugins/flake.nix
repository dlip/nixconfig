{
  inputs = {
    comex = {
      url = "github:sayanarijit/comex.xplr";
      flake = false;
    };
    command-mode = {
      url = "github:sayanarijit/command-mode.xplr";
      flake = false;
    };
  };

  outputs =
    inputs: {
      overlay = self: super: {
        xplrPlugins = self.lib.filterAttrs (n: v: n != "self") inputs;
      };
    };
}
