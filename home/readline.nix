{ pkgs, ... }:
{
  programs.readline = {
    enable = true;
    extraConfig = ''
      # Use Vi, not Emacs, style editing
      set editing-mode vi

      # Show all completions on tab.
      set show-all-if-ambiguous on
      set completion-ignore-case on
      # On menu-complete, display the common prefix, then cycle through the options with tab.
      set menu-complete-display-prefix on

      ####################################################################################################
      # Vi Command Mode Keymaps
      ####################################################################################################
      set keymap vi-command

      # Colemak
      "r": backward-char
      "s": next-history
      "f": previous-history
      "i": forward-char
      "u": undo
      # readline doesn't have redo. Wat?!
      "l": vi-first-print
      "L": end-of-line
      "j": vi-end-word
      "J": vi-end-word

      # Option-Up/Option-Down cycles through history that begins with the current prefix.
      "\e\e[A": history-search-backward
      "\e\e[B": history-search-forward

      ####################################################################################################
      # Vi Insert Mode Keymaps
      ####################################################################################################
      set keymap vi-insert

      # Tab lists all completions and selects the first one.
      TAB: menu-complete
      # Shift-Tab cycles completions backward
      "\e[Z": menu-complete-backward

      # Option-up/option-down should also apply to insert mode
      "\e\e[A": history-search-backward
      "\e\e[B": history-search-forward
    '';
  };
}
