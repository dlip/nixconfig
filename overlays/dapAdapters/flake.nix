{
  inputs = {
    vscodeNodeDebug2 = {
      url = "github:microsoft/vscode-node-debug2";
      flake = false;
    };
  };

  outputs =
    { self, vscodeNodeDebug2 }: {
      overlay = final: prev: {
        dapAdapters = {
          vscodeNodeDebug2 = final.callPackage ./vscodeNodeDebug2 { src = vscodeNodeDebug2; };
        };
      };
    };
}
