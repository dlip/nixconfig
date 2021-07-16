{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    userSettings = {
      "aws.telemetry" = false;
      "breadcrumbs.enabled" = true;
      "editor.fontFamily" = "FiraCode Nerd Font";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 12;
      "editor.formatOnSave" = true;
      "editor.lineHeight" = 20;
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "all";
      "editor.rulers" = [ 80 120 ];
      "editor.tabSize" = 2;
      "editor.useTabStops" = false;
      "extensions.autoUpdate" = false;
      "files.autoSave" = "onFocusChange";
      "files.exclude" = { "**/node_modules/**" = true; };
      "files.trimTrailingWhitespace" = true;
      "git.autofetch" = true;
      "git.confirmSync" = false;
      "git.enableSmartCommit" = true;
      "metaGo.decoration.additionalSingleCharCodeCharacters" = "E,S,N,T,I,R,O,A,C,H,D,G,M,X,Z,O,U,F,Y,W,U,P,Q";
      "metaGo.decoration.characters" = "e,s,n,t,i,r,o,a,c,h,d,g,m,x,z,o,u,f,y,w,u,p,q";
      "projectManager.git.baseFolders" = [ "$home/code" ];
      "telemetry.enableCrashReporter" = false;
      "telemetry.enableTelemetry" = false;
      "terminal.integrated.fontFamily" = "FiraCode Nerd Font";
      "terminal.integrated.fontSize" = 12;
      "todo-tree.general.tags" = [
        "BUG"
        "HACK"
        "FIXME"
        "TODO"
        "XXX"
        "[ ]"
        "[x]"
      ];
      "todo-tree.regex.regex" = "(//|#|<!--|;|/\\*|^|^\\s*(-|\\d+.))\\s*($TAGS)";
      "window.zoomLevel" = 1;
      "workbench.colorTheme" = "One Dark Pro";
      "workbench.editor.enablePreview" = false;
      "workbench.iconTheme" = "material-icon-theme";
      "workbench.startupEditor" = "none";
    };

    keybindings = [
      {
        "key" = "ctrl+j";
        "command" = "editor.action.joinLines";
      }
      {
        key = "ctrl+'";
        command = "projectManager.listProjectsNewWindow";
      }
      {
        "key" = "alt+g";
        "command" = "magit.status";
      }
      {
        "key" = "ctrl+o";
        "command" = "editor.action.openLink";
        "when" = "editorFocus";
      }
      {
        "key" = "alt+left";
        "command" = "workbench.action.navigateBack";
      }
      {
        "key" = "alt+right";
        "command" = "workbench.action.navigateForward";
      }
    ];

    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace (import ./vscode-extensions.nix).extensions ++ (with pkgs.vscode-extensions; [
      ms-vscode.cpptools
      ms-vsliveshare.vsliveshare
    ]);
  };

}
