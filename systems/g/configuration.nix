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
      ../common/services/kmonad.nix
    ];

  services.acpid.handlers = {
    lid = {
      event = "button/lid LID (open|close)";
      action = ''
        if grep -q closed /proc/acpi/button/lid/LID0/state; then
          /etc/profiles/per-user/dane/bin/brightnessctl set 0
        else
          /etc/profiles/per-user/dane/bin/brightnessctl set 50%
        fi
      '';
    };
  };

  services.autorandr = {
    enable = true;
  };

  # disable suspend on lid closed
  services.logind.lidSwitch = "ignore";
  # services.logind.lidSwitchDocked = "lock";
  # services.logind.lidSwitchExternalPower = "lock";
  services.logind.extraConfig = ''
    # don’t shutdown when power button is short-pressed
    HandlePowerKey=ignore
  '';

  services.xserver.videoDrivers = [ "nvidia" ];
  services.xserver.screenSection = ''
    Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
    Option         "AllowIndirectGLXProtocol" "off"
    Option         "TripleBuffer" "on"
  '';

  hardware.nvidia.prime = {
    sync.enable = true;
    # offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };

  # services.k3s = {
  #   enable = false;
  #   docker = true;
  #   extraFlags = "--no-deploy traefik";
  # };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  services.flatpak.enable = true;

  # networking.wireguard.interfaces = {
  #   wg0 = {
  #     ips = [ "10.100.0.3/24" ];
  #
  #     peers = [
  #       (import ../common/wireguard/dex-peer.nix)
  #     ];
  #   };
  # };
}
