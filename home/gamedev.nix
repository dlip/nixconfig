{ pkgs, ... }: {

  home.packages = with pkgs.unstable; [
    godot_4
  ];
}
