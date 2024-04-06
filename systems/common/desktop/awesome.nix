{
  config,
  pkgs,
  lib,
  ...
}: {
  hardware.pulseaudio.enable = false;
  services.xserver = {
    enable = true;
    displayManager = {
      lightdm.enable = true;
      defaultSession = "none+awesome";
      autoLogin.enable = true;
      autoLogin.user = "dane";
      job.preStart = "sleep 2"; # Hack to ensure X is ready for autoLogin
    };

    windowManager.awesome.enable = true;
  };
}
