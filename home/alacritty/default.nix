{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      bell = {
        animation = "EaseOutExpo";
        duration = 5;
        color = "#ffffff";
      };
      colors = {
        primary = {
          background = "#24283b";
          foreground = "#c0caf5";
        };
      };
      env = {
        TERM = "xterm-256color";
      };
      font = {
        normal = {
          family = "RobotoMono Nerd Font Mono";
          style = "Regular";
        };
        size = 10;
      };
      selection.save_to_clipboard = true;
      shell.program = "${pkgs.zsh}/bin/zsh";
      window = {
        opacity = 0.9;
        decorations = "full";
        padding = {
          x = 5;
          y = 5;
        };
      };
    };
  };
}
