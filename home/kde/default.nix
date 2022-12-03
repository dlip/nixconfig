{ pkgs, lib, ... }:
{
  imports = [
    ./config.nix
  ];

  home.packages = with pkgs; [
    libsForQt5.bismuth
    rc2nix
  ];


  # programs.plasma = {
  #   enable = true;
  #
  #   # Some high-level settings:
  #   workspace.clickItemTo = "select";
  #
  #   hotkeys.commands."Launch Konsole" = {
  #     key = "Meta+Alt+K";
  #     command = "konsole";
  #   };
  #
  #   # Some mid-level settings:
  #   shortcuts = {
  #     ksmserver = {
  #       "Lock Session" = [ "Screensaver" "Meta+Ctrl+Alt+L" ];
  #     };
  #
  #     kwin = {
  #       "Expose" = "Meta+,";
  #       "Switch Window Down" = "Meta+J";
  #       "Switch Window Left" = "Meta+H";
  #       "Switch Window Right" = "Meta+L";
  #       "Switch Window Up" = "Meta+K";
  #     };
  #
  #     bismuth = {
  #       "focus_bottom_window" = "Meta+Down";
  #       "focus_left_window" = "Meta+Left";
  #       "focus_next_window" = "Meta+N";
  #       "focus_prev_window" = "Meta+P";
  #       "focus_right_window" = "Meta+Right";
  #       "focus_upper_window" = "Meta+Up";
  #       "move_window_to_bottom_pos" = "Meta+Shift+J";
  #       "move_window_to_left_pos" = "Meta+Shift+H";
  #       "move_window_to_right_pos" = "Meta+Shift+L";
  #       "move_window_to_upper_pos" = "Meta+Shift+K";
  #       "toggle_float_layout" = "Meta+Shift+F";
  #       "toggle_monocle_layout" = "Meta+M";
  #     };
  #   };
  #
  #   files = {
  #     "kwinrc"."Plugins"."bismuthEnabled" = true;
  #     "kwinrc"."Script-bismuth"."maximizeSoleTile" = true;
  #     "kwinrc"."Script-bismuth"."preventMinimize" = true;
  #     "kwinrc"."Script-bismuth"."screenGapBottom" = 4;
  #     "kwinrc"."Script-bismuth"."screenGapLeft" = 4;
  #     "kwinrc"."Script-bismuth"."screenGapRight" = 4;
  #     "kwinrc"."Script-bismuth"."screenGapTop" = 4;
  #     "kwinrc"."Script-bismuth"."tileLayoutGap" = 4;
  #     "kwinrc"."Script-bismuth"."untileByDragging" = false;
  #     "kwinrc"."org.kde.kdecoration2"."BorderSize" = "None";
  #     "kwinrc"."org.kde.kdecoration2"."BorderSizeAuto" = false;
  #     "kwinrc"."org.kde.kdecoration2"."library" = lib.mkForce "org.kde.bismuth.decoration";
  #     "kwinrc"."org.kde.kdecoration2"."theme" = lib.mkForce "Bismuth";
  #     "baloofilerc"."Basic Settings"."Indexing-Enabled" = false;
  #   };
  # };
}
