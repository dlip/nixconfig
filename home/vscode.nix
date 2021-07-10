{ pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    userSettings = {
      "breadcrumbs.enabled" = true;
      "editor.fontFamily" = "FiraCode Nerd Font";
      "editor.fontLigatures" = true;
      "editor.fontSize" = 16;
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
      "metaGo.decoration.additionalSingleCharCodeCharacters" = "E,S,N,T,I,R,O,A,C,H,D,G,M,X,Z,O,U,F,Y,W,U,P,Q";
      "metaGo.decoration.characters" = "e,s,n,t,i,r,o,a,c,h,d,g,m,x,z,o,u,f,y,w,u,p,q";
      "projectManager.git.baseFolders" = [ "$home/code" ];
      "telemetry.enableCrashReporter" = false;
      "telemetry.enableTelemetry" = false;
      "terminal.integrated.fontFamily" = "FiraCode Nerd Font";
      "terminal.integrated.fontSize" = 16;
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
      "workbench.colorTheme" = "Default Dark+";
      "workbench.editor.enablePreview" = false;
      "workbench.iconTheme" = "vs-seti";
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
        "key" = "ctrl+e g";
        "command" = "magit.status";
      }
    ];

    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace
      (import ./vscode-extensions.nix).extensions;
  };
}
