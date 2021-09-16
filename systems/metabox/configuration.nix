{ config, pkgs, lib, ... }:
let params = {
  hostname = "metabox";
};
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import ../common params)
    ];

  networking.interfaces.enp8s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;

  services.k3s = {
    enable = false;
    docker = true;
    extraFlags = "--no-deploy traefik";
  };

  services.xserver.screenSection = ''
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    sync.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

}
