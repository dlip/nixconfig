{
  pkgs,
  config,
  ...
}: let
  cfg = config.programs.vscode;
  vscodePname = cfg.package.pname;
  configDir =
    {
      "vscode" = "Code";
      "vscode-insiders" = "Code - Insiders";
      "vscodium" = "VSCodium";
    }
    .${vscodePname};
  userDir =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "Library/Application Support/${configDir}/User"
    else "${config.xdg.configHome}/${configDir}/User";

  configFilePath = "${userDir}/settings.json";
  keybindingsFilePath = "${userDir}/keybindings.json";
in {
  home.file = {
    "${configFilePath}".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/vscode/settings.jsonc";
    "${keybindingsFilePath}".source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/code/nixconfig/home/vscode/keybindings.jsonc";
  };

  programs.vscode = {
    enable = true;
    extensions =
      pkgs.vscode-utils.extensionsFromVscodeMarketplace
      (import ./vscode-extensions.nix).extensions
      ++ (
        with pkgs.vscode-extensions;
          if pkgs.system == "aarch64-linux"
          then [
            ms-vscode.cpptools
            # ms-vsliveshare.vsliveshare
            # chenglou92.rescript-vscode
            hashicorp.terraform
          ]
          else [
          ]
      );
  };
}
