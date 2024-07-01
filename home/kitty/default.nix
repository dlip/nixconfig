{pkgs, ...}: {
  programs.kitty = {
    enable = true;
    settings = {
      font_size = 15;
      macos_option_as_alt = true;
      font_family = "RobotoMono Nerd Font Mono";
      bold_font = "auto";
      italic_font = "auto";
      bold_italic_font = "auto";
      enable_audio_bell = "no";
      background_opacity = "0.9";
      kitty_mod = "ctrl+alt";

      # https://github.com/catppuccin/kitty/blob/main/themes/macchiato.conf
      # The basic colors
      foreground = "#cad3f5";
      background = "#24273a";
      selection_foreground = "#24273a";
      selection_background = "#f4dbd6";

      # Cursor colors
      cursor = "#f4dbd6";
      cursor_text_color = "#24273a";

      # URL underline color when hovering with mouse
      url_color = "#f4dbd6";

      # Kitty window border colors
      active_border_color = "#b7bdf8";
      inactive_border_color = "#6e738d";
      bell_border_color = "#eed49f";

      # OS Window titlebar colors
      wayland_titlebar_color = "system";
      macos_titlebar_color = "system";

      # Tab bar colors
      active_tab_foreground = "#181926";
      active_tab_background = "#c6a0f6";
      inactive_tab_foreground = "#cad3f5";
      inactive_tab_background = "#1e2030";
      tab_bar_background = "#181926";

      # Colors for marks (marked text in the terminal)
      mark1_foreground = "#24273a";
      mark1_background = "#b7bdf8";
      mark2_foreground = "#24273a";
      mark2_background = "#c6a0f6";
      mark3_foreground = "#24273a";
      mark3_background = "#7dc4e4";

      # The 16 terminal colors

      # black
      color0 = "#494d64";
      color8 = "#5b6078";

      # red
      color1 = "#ed8796";
      color9 = "#ed8796";

      # green
      color2 = "#a6da95";
      color10 = "#a6da95";

      # yellow
      color3 = "#eed49f";
      color11 = "#eed49f";

      # blue
      color4 = "#8aadf4";
      color12 = "#8aadf4";

      # magenta
      color5 = "#f5bde6";
      color13 = "#f5bde6";

      # cyan
      color6 = "#8bd5ca";
      color14 = "#8bd5ca";

      # white
      color7 = "#b8c0e0";
      color15 = "#a5adcb";

      # Tab bar
      tab_bar_style = "fade";
      tab_fade = "1";
      tab_bar_edge = "top";
      active_tab_font_style = "bold";
      inactive_tab_font_style = "bold";
    };

    keybindings = {
      "ctrl+backspace" = "send_text all \\x17";
      "kitty_mod+t" = "new_tab";
      "kitty_mod+shift+t" = "new_tab_with_cwd";
      "kitty_mod+w" = "close_tab";
      "kitty_mod+r" = "set_tab_title";
      "kitty_mod+shift+left" = "move_tab_backward";
      "kitty_mod+shift+right" = "move_tab_forward";
      "kitty_mod+1" = "goto_tab 1";
      "kitty_mod+2" = "goto_tab 2";
      "kitty_mod+3" = "goto_tab 3";
      "kitty_mod+4" = "goto_tab 4";
      "kitty_mod+5" = "goto_tab 5";
      "kitty_mod+6" = "goto_tab 6";
      "kitty_mod+7" = "goto_tab 7";
      "kitty_mod+8" = "goto_tab 8";
      "kitty_mod+9" = "goto_tab 9";
      "kitty_mod+0" = "goto_tab 10";
      "ctrl+shift+c" = "copy_to_clipboard";
      "ctrl+shift+v" = "paste_from_clipboard";
      # "alt+left" = "send_text all \\x1b\\x62";
      # "alt+right" = "send_text all \\x1b\\x66";
    };
  };
}
