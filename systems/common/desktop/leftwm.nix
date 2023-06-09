{...}: {
  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = false;
      xfce = {
        enable = true;
        noDesktop = true;
        enableXfwm = false;
      };
    };
    displayManager = {
      lightdm.enable = true;
      defaultSession = "xfce+leftwm";
      # autoLogin.enable = true;
      # autoLogin.user = "dane";
      # job.preStart = "sleep 2"; # Hack to ensure X is ready for autoLogin
    };
    windowManager.leftwm.enable = true;
  };
}
