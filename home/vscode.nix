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
      "editor.formatOnSave" = false;
      "editor.lineHeight" = 20;
      "editor.minimap.enabled" = false;
      "editor.renderWhitespace" = "all";
      "editor.rulers" = [ 80 120 ];
      "editor.tabSize" = 2;
      "editor.useTabStops" = false;
      "extensions.autoUpdate" = false;
      "files.autoSave" = "onFocusChange";
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
      "vscode-lua-format.binaryPath" = "~/.nix-profile/bin/lua-format";
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
      {
        "key" = "space";
        "command" = "vspacecode.space";
        "when" = "activeEditorGroupEmpty && focusedView == '' && !whichkeyActive && !inputFocus";
      }
      {
        "key" = "space";
        "command" = "vspacecode.space";
        "when" = "sideBarFocus && !inputFocus && !whichkeyActive";
      }
      {
        "key" = "tab";
        "command" = "extension.vim_tab";
        "when" = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert' && editorLangId != 'magit'";
      }
      {
        "key" = "tab";
        "command" = "-extension.vim_tab";
        "when" = "editorFocus && vim.active && !inDebugRepl && vim.mode != 'Insert'";
      }
      {
        "key" = "x";
        "command" = "magit.discard-at-point";
        "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
      }
      {
        "key" = "k";
        "command" = "-magit.discard-at-point";
      }
      {
        "key" = "-";
        "command" = "magit.reverse-at-point";
        "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
      }
      {
        "key" = "v";
        "command" = "-magit.reverse-at-point";
      }
      {
        "key" = "shift+-";
        "command" = "magit.reverting";
        "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
      }
      {
        "key" = "shift+v";
        "command" = "-magit.reverting";
      }
      {
        "key" = "shift+o";
        "command" = "magit.resetting";
        "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode =~ /^(?!SearchInProgressMode|CommandlineInProgress).*$/";
      }
      {
        "key" = "shift+x";
        "command" = "-magit.resetting";
      }
      {
        "key" = "x";
        "command" = "-magit.reset-mixed";
      }
      {
        "key" = "ctrl+u x";
        "command" = "-magit.reset-hard";
      }
      {
        "key" = "y";
        "command" = "-magit.show-refs";
      }
      {
        "key" = "y";
        "command" = "vspacecode.showMagitRefMenu";
        "when" = "editorTextFocus && editorLangId == 'magit' && vim.mode == 'Normal'";
      }
      {
        "key" = "ctrl+j";
        "command" = "workbench.action.quickOpenSelectNext";
        "when" = "inQuickOpen";
      }
      {
        "key" = "ctrl+k";
        "command" = "workbench.action.quickOpenSelectPrevious";
        "when" = "inQuickOpen";
      }
      {
        "key" = "ctrl+j";
        "command" = "selectNextSuggestion";
        "when" = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        "key" = "ctrl+k";
        "command" = "selectPrevSuggestion";
        "when" = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        "key" = "ctrl+l";
        "command" = "acceptSelectedSuggestion";
        "when" = "suggestWidgetMultipleSuggestions && suggestWidgetVisible && textInputFocus";
      }
      {
        "key" = "ctrl+j";
        "command" = "showNextParameterHint";
        "when" = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
      }
      {
        "key" = "ctrl+k";
        "command" = "showPrevParameterHint";
        "when" = "editorFocus && parameterHintsMultipleSignatures && parameterHintsVisible";
      }
      {
        "key" = "ctrl+h";
        "command" = "file-browser.stepOut";
        "when" = "inFileBrowser";
      }
      {
        "key" = "ctrl+l";
        "command" = "file-browser.stepIn";
        "when" = "inFileBrowser";
      }
    ];

    extensions = pkgs.vscode-utils.extensionsFromVscodeMarketplace (import ./vscode-extensions.nix).extensions ++ (with pkgs.vscode-extensions; [
      ms-vscode.cpptools
      ms-vsliveshare.vsliveshare
    ]);
  };

}
