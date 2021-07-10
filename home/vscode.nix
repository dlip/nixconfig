{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    userSettings = {
      "editor.renderWhitespace" = "all";
      "files.autoSave" = "onFocusChange";
      "editor.rulers" = [ 80 120 ];
      "telemetry.enableTelemetry" = false;
      "telemetry.enableCrashReporter" = false;
      "editor.tabSize" = 2;
      "files.exclude" = { "**/node_modules/**" = true; };
      "editor.formatOnSave" = false;
      "breadcrumbs.enabled" = true;
      "editor.useTabStops" = false;
      "editor.fontFamily" = "FiraCode Nerd Font";
      "editor.fontSize" = 16;
      "editor.fontLigatures" = true;
      "editor.lineHeight" = 20;
      "files.trimTrailingWhitespace" = true;
      "editor.minimap.enabled" = false;
      "workbench.colorTheme" = "Default Dark+";
      "workbench.editor.enablePreview" = false;
      "workbench.iconTheme" = "vs-seti";
      "workbench.startupEditor" = "none";
      "terminal.integrated.fontFamily" = "FiraCode Nerd Font";
      "files.watcherExclude" = { "**/*" = true; };
    };

    keybindings = [{
      key = "shift+cmd+d";
      command = "editor.action.copyLinesDownAction";
      when = "editorTextFocus && !editorReadonly";
    }];

    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace
      (import ./vscode-extensions.nix).extensions;
  };
}
