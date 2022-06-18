{ ... }:
{
  services.kmonad = {
    enable = true;
    keyboards =
      {
        sweep = {
          name = "sweep";
          device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
          config = builtins.readFile (../../../keymaps/kmonad/sweep17.kbd);
        };
      };
  };
}
