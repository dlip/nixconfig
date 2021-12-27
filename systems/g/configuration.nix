{ config, pkgs, lib, ... }:
let params = {
  hostname = "g";
};
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import ../common params)
      ../common/desktop/awesome.nix
    ];

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    sync.enable = true;
    # offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services.kmonad = {
    enable = true;
    configfiles = [
      ../../keymaps/kmonad/sweep.kbd
    ];
  };


  xdg.portal.enable = true;
  services.flatpak.enable = true;

}

