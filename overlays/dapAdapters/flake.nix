{
  inputs = {
    vscode-node-debug2 = {
      url = "github:microsoft/vscode-node-debug2";
      flake = false;
    };
  };

  outputs =
    inputs: {
      overlay = final: prev: {
        dapAdapters = builtins.listToAttrs (map
          (input: {
            name = input;
            value = builtins.getAttr input inputs;
          })
          (builtins.attrNames (final.lib.filterAttrs (n: v: n != "self") inputs)));
      };
    };
}
