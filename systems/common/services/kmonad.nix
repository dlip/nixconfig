{...}: {
  services.kmonad = {
    enable = false;
    keyboards = {
      sweep = {
        name = "sweep";
        device = "/dev/input/by-path/platform-i8042-serio-0-event-kbd";
        config = builtins.readFile ../../../keymaps/kmonad/sweep25.kbd;
      };
      # charachorder = {
      #   name = "charachorder";
      #   device = "/dev/input/by-id/usb-CharaChorder_CharaChorder_1_A21D040450583234352E3120FF070B2A-if02-event-kbd";
      #   config = builtins.readFile (../../../keymaps/kmonad/charachorder-silver.kbd);
      # };
    };
  };
}
