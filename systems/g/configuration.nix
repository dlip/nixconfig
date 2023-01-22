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
      # ../common/desktop/awesome.nix
      ../common/desktop/kde.nix
      ../common/services/kmonad.nix
    ];

  virtualisation.virtualbox.host.enable = true;
  users.extraGroups.vboxusers.members = [ "dane" ];

  users.users.dane = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "dialout" "adbusers" ]; # Enable ‘sudo’ for the user.
    shell = "/etc/profiles/per-user/dane/bin/zsh";
  };

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


  sops.secrets.dex-dane = { };
  fileSystems."/mnt/dex-dane" = {
    device = "//10.10.0.123/dane";
    fsType = "cifs";
    options = [ "credentials=${config.sops.secrets.dex-dane.path},uid=1000,gid=100,x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s" ];
  };
  fileSystems."/mnt/dex-media" = {
    device = "//10.10.0.123/media";
    fsType = "cifs";
    options = [ "credentials=${config.sops.secrets.dex-dane.path},uid=1000,gid=100,x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s" ];
  };
  fileSystems."/mnt/dex-media2" = {
    device = "//10.10.0.123/media2";
    fsType = "cifs";
    options = [ "credentials=${config.sops.secrets.dex-dane.path},uid=1000,gid=100,x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s" ];
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
