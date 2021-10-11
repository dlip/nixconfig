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
      TMUX_FZF_LAUNCH_KEY="C-f"
      TMUX_FZF_POPUP=0
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "config reloaded"
    '';
  };
}
