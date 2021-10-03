{ pkgs, config, ... }:
let
  cfg = config.programs.vscode;
  vscodePname = cfg.package.pname;
  configDir = {
    "vscode" = "Code";
    "vscode-insiders" = "Code - Insiders";
    "vscodium" = "VSCodium";
  }.${vscodePname};
  userDir =
    if pkgs.stdenv.hostPlatform.isDarwin then
      "Library/Application Support/${configDir}/User"
    else
      "${config.xdg.configHome}/${configDir}/User";

  configFilePath = "${userDir}/settings.json";
  keybindingsFilePath = "${userDir}/keybindings.json";
in
{

  home.file = {
    "${configFilePath}".source = ./settings.jsonc;
    "${keybindingsFilePath}".source = ./keybindings.jsonc;
  };

  programs.vscode = {
    enable = true;
    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace
      (import ./vscode-extensions.nix).extensions ++ (with pkgs.vscode-extensions; [
      ms-vscode.cpptools
      ms-vsliveshare.vsliveshare
      (pkgs.callPackage ./rescript { })
    ]);
  };

}
