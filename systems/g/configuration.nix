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
    ];

  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  services.kmonad = {
    enable = true;
    configfiles = [
      ../../keymaps/kmonad/superspace.kbd
    ];
  };
}

