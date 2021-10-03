{ lib, vscode-utils, callPackage }:
let
  rescript-editor-analysis = (callPackage ./rescript-editor-analysis.nix { });
in vscode-utils.buildVscodeMarketplaceExtension rec {
  mktplcRef = {
    name = "rescript-vscode";
    publisher = "chenglou92";
    version = "1.1.3";
    sha256 = "1c1ipxgm0f0a3vlnhr0v85jr5l3rwpjzh9w8nv2jn5vgvpas0b2a";
  };
  postPatch = ''
    rm -rf server/analysis_binaries/linux
    ln -s ${rescript-editor-analysis}/bin server/analysis_binaries/linux
  '';

  meta = with lib; {
    license = licenses.mit;
    maintainers = with maintainers; [ rhoriguchi ];
  };
}
