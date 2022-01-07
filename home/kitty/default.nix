{ pkgs, ... }:
{
  programs.kitty = {
    enable = true;
    settings = {
      font_size = 11;
      font_family = "FiraCode Nerd Font";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      enable_audio_bell = "no";
      background_opacity = "0.9";


      # Tokyo Night color scheme for kitty terminal emulator
      # https://github.com/davidmathers/tokyo-night-kitty-theme
      #
      # Based on Tokyo Night color theme for Visual Studio Code
      # https://github.com/enkia/tokyo-night-vscode-theme

      foreground = "#a9b1d6";
      background = "#1a1b26";

      # Black
      color0 = "#414868";
      color8 = "#414868";

      # Red
      color1 = "#f7768e";
      color9 = "#f7768e";

      # Green
      color2 = "#73daca";
      color10 = "#73daca";

      # Yellow
      color3 = "#e0af68";
      color11 = "#e0af68";

      # Blue
      color4 = "#7aa2f7";
      color12 = "#7aa2f7";

      # Magenta
      color5 = "#bb9af7";
      color13 = "#bb9af7";

      # Cyan
      color6 = "#7dcfff";
      color14 = "#7dcfff";

      # White
      color7 = "#c0caf5";
      color15 = "#c0caf5";

      # Cursor
      cursor = "#c0caf5";
      cursor_text_color = "#1a1b26";

      # Selection highlight
      selection_foreground = "none";
      selection_background = "#28344a";

      # The color for highlighting URLs on mouse-over
      url_color = "#9ece6a";

      # Window borders
      active_border_color = "#3d59a1";
      inactive_border_color = "#101014";
      bell_border_color = "#e0af68";

      # Tab bar
      tab_bar_style = "fade";
      tab_fade = "1";
      active_tab_foreground = "#3d59a1";
      active_tab_background = "#16161e";
      active_tab_font_style = "bold";
      inactive_tab_foreground = "#787c99";
      inactive_tab_background = "#16161e";
      inactive_tab_font_style = "bold";
      tab_bar_background = "#101014";
    };

    # keybindings = {
    #   "kitty_mod+w" = "new_window_with_cwd";
    #   "kitty_mod+q" = "close_window";
    #   "kitty_mod+[" = "previous_window";
    #   "kitty_mod+]" = "next_window";
    #   "kitty_mod+t" = "new_tab";
    #   "kitty_mod+x" = "close_tab";
    #   "kitty_mod+<" = "previous_tab";
    #   "kitty_mod+>" = "next_tab";
    #   "alt+left" = "send_text all \\x1b\\x62";
    #   "alt+right" = "send_text all \\x1b\\x66";
    #   "ctrl+shift+c" = "copy_to_clipboard";
    #   "ctrl+shift+v" = "paste_from_clipboard";
    # };
  };
}
