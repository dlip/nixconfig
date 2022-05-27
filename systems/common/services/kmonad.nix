{ ... }:
{
  services.kmonad = {
    enable = true;
    configfiles = [
      ../../../keymaps/kmonad/sweep17.kbd
    ];
  };
}
