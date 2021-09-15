{ config, pkgs, lib, ... }:
let params = {
  hostname = "metabox";
  nvidiaBusId = "PCI:1:0:0";
  intelBusId = "PCI:0:2:0";
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
}
