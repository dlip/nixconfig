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
    ];
    keyMode = "vi";
    extraConfig = ''
      set-option -g default-terminal "screen-256color"
      set -ga terminal-overrides ",*256col*:Tc"
      set-option -g prefix C-a
      bind C-a send-prefix
      set -g mouse on
      bind s split-window -h
      bind v split-window -v
      bind-key r source-file ~/.config/tmux/tmux.conf \; display-message "config reloaded"
    '';
  };
}
