{pkgs, ...}: {
  programs.tmux = {
    enable = true;
    clock24 = true;
    plugins = with pkgs.tmuxPlugins; [
      yank
      extrakto
      tmux-fzf
    ];
    keyMode = "vi";
    baseIndex = 1;
    prefix = "C-t";
    shortcut = "a";
    mouse = true;
    terminal = "tmux-256color";
    escapeTime = 0;
    extraConfig = ''
      set -ag terminal-overrides ",xterm-kitty:RGB"
      set -as terminal-features ",xterm-kitty:clipboard"
      set-option -g status-position top
      set -g @catppuccin_flavour 'macchiato'
      set -g @catppuccin_window_default_text "#W"
      set -g @catppuccin_window_current_text "#W"
      set -g @catppuccin_status_modules_left "session"
      set -g @catppuccin_status_modules_right "null"
      run-shell ${pkgs.repo-tmux-catppuccin}/catppuccin.tmux

      bind-key a last-window
      bind C-s copy-mode
      bind S choose-tree
      set-option -g history-limit 20000
      set-option -g set-titles on
      set-option -g set-titles-string "#S"
      TMUX_FZF_LAUNCH_KEY="f" # Key Prefix + f

      set-option -g allow-passthrough on
      TMUX_FZF_OPTIONS="-p -w 62% -h 38%"
      TMUX_FZF_PANE_FORMAT="[#{window_name}] #{pane_current_command}  [#{pane_width}x#{pane_height}] [history #{history_size}/#{history_limit}, #{history_bytes} bytes] #{?pane_active,[active],[inactive]}"
      TMUX_FZF_POPUP=0
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "config reloaded"
      bind-key e run-shell "tmux-edit-output"
      # set-option -g status-interval 5
      # set-option -g automatic-rename on
      # set-option -g automatic-rename-format '#{b:pane_current_path}'
      bind -n M-Left  previous-window
      bind -n M-Right next-window
      bind-key -n M-S-Left swap-window -t -1\; select-window -t -1
      bind-key -n M-S-Right swap-window -t +1\; select-window -t +1
      bind -n M-0 select-window -t 0
      bind -n M-1 select-window -t 1
      bind -n M-2 select-window -t 2
      bind -n M-3 select-window -t 3
      bind -n M-4 select-window -t 4
      bind -n M-5 select-window -t 5
      bind -n M-6 select-window -t 6
      bind -n M-7 select-window -t 7
      bind -n M-8 select-window -t 8
      bind -n M-9 select-window -t 9

      # Smart pane switching with awareness of Vim splits.
      # See: https://github.com/christoomey/vim-tmux-navigator
      is_vim="ps -o state= -o comm= -t '#{pane_tty}' \
        | grep -iqE '^[^TXZ ]+ +(\\S+\\/)?g?(view|n?vim?x?)(diff)?$'"
      bind-key -n 'C-Left' if-shell "$is_vim" 'send-keys C-Left'  'select-pane -L'
      bind-key -n 'C-Down' if-shell "$is_vim" 'send-keys C-Down'  'select-pane -D'
      bind-key -n 'C-Up' if-shell "$is_vim" 'send-keys C-Up'  'select-pane -U'
      bind-key -n 'C-Right' if-shell "$is_vim" 'send-keys C-Right'  'select-pane -R'
      tmux_version='$(tmux -V | sed -En "s/^tmux ([0-9]+(.[0-9]+)?).*/\1/p")'
      if-shell -b '[ "$(echo "$tmux_version < 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\'  'select-pane -l'"
      if-shell -b '[ "$(echo "$tmux_version >= 3.0" | bc)" = 1 ]' \
        "bind-key -n 'C-\\' if-shell \"$is_vim\" 'send-keys C-\\\\'  'select-pane -l'"

      bind-key -T copy-mode-vi / command-prompt -i -p "search down" "send -X search-forward-incremental \"%%%\""
      bind-key -T copy-mode-vi ? command-prompt -i -p "search up" "send -X search-backward-incremental \"%%%\""

      bind-key -r -T prefix Up resize-pane -U 5
      bind-key -r -T prefix Down resize-pane -D 5
      bind-key -r -T prefix Left resize-pane -L 5
      bind-key -r -T prefix Right resize-pane -R 5

      bind-key -T copy-mode-vi 'C-Left' select-pane -L
      bind-key -T copy-mode-vi 'C-Down' select-pane -D
      bind-key -T copy-mode-vi 'C-Up' select-pane -U
      bind-key -T copy-mode-vi 'C-Right' select-pane -R
      bind-key -T copy-mode-vi 'C-\' select-pane -l

      # Don't jump to the end of the pane after selection
      unbind-key -T copy-mode-vi MouseDragEnd1Pane
      bind-key -T copy-mode-vi y send-keys -X copy-selection

      # Ensure path is maintained
      bind c new-window -c "#{pane_current_path}" -n ""
      bind s split-window -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"

      bind X kill-window
      bind Q kill-session
    '';
  };
}
