{ pkgs, ... }:

{
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
      vim-tmux-navigator
      prefix-highlight
      sensible
      yank
      resurrect
      continuum
      nord
      pain-control
      extrakto
      tmux-fzf
    ];
    keyMode = "vi";
    extraConfig = ''
      set -g default-terminal "tmux-256color"
      set -ag terminal-overrides ",xterm-256color:RGB"
      set-option -g prefix C-a
      bind C-a send-prefix
      set -g mouse on
      bind s split-window -h
      bind v split-window -v
      TMUX_FZF_LAUNCH_KEY="f" # Key Prefix + f

      TMUX_FZF_OPTIONS="-p -w 62% -h 38%"
      TMUX_FZF_PANE_FORMAT="[#{window_name}] #{pane_current_command}  [#{pane_width}x#{pane_height}] [history #{history_size}/#{history_limit}, #{history_bytes} bytes] #{?pane_active,[active],[inactive]}"
      TMUX_FZF_POPUP=0
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "config reloaded"
      set-option -g status-interval 5
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'
      bind -n M-Left  previous-window
      bind -n M-Right next-window
      bind-key -n M-S-Left swap-window -t -1\; select-window -t -1
      bind-key -n M-S-Right swap-window -t +1\; select-window -t +1
    '';
  };
}
