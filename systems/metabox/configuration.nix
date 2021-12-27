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
      ../common/desktop/awesome.nix
    ];

  # services.k3s = {
  #   enable = false;
  #   docker = true;
  #   extraFlags = "--no-deploy traefik";
  # };

  services.kmonad = {
    enable = true;
    configfiles = [
      ../../keymaps/kmonad/spaceonly7.kbd
    ];
  };

  services.xserver.screenSection = ''
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    sync.enable = true;
    # offload.enable = true;
    nvidiaBusId = "PCI:1:0:0";
    intelBusId = "PCI:0:2:0";
  };

  # specialisation = {
  #   external-display.configuration = {
  #     system.nixos.tags = [ "external-display" ];
  #     hardware.nvidia.prime.offload.enable = lib.mkForce false;
  #     hardware.nvidia.powerManagement.enable = lib.mkForce false;
  #   };
  # };

}
