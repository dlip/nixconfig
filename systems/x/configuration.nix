# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: let
  params = {
    hostname = "x";
  };
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import ../common params)
    ../common/desktop/sway.nix
    # ../common/desktop/hyprland.nix
    # ../common/desktop/leftwm.nix
    # ../common/desktop/kde.nix
    ../common/desktop/i3.nix
    ../common/services/kmonad.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = ["ntfs"];
  #   networking.firewall.extraCommands = ''
        # Flush the tables. This may cut the system's internet.
        iptables -F

        # The default policy, if no other rules match, is to refuse traffic.
        iptables -P OUTPUT DROP
        iptables -P INPUT DROP
        iptables -P FORWARD DROP

        # Let the VPN client communicate with the outside world.
        iptables -A OUTPUT -j ACCEPT -m owner --gid-owner openvpn

        # The loopback device is harmless, and TUN is required for the VPN.
        iptables -A OUTPUT -j ACCEPT -o lo
        iptables -A OUTPUT -j ACCEPT -o tun+

        # We should permit replies to traffic we've sent out.
        iptables -A INPUT -j ACCEPT -m state --state ESTABLISHED
     # '';

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  hardware.enableAllFirmware = true;

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.modesetting.enable = true;
  # hardware.nvidia.powerManagement.enable = false;
  hardware.nvidia.prime = {
    # sync.enable = true;
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  # services.flatpak.enable = true;

  systemd.services.keyd = {
    description = "keyd daemon";
    wantedBy = ["sysinit.target"];
    requires = ["local-fs.target"];
    after = ["local-fs.target"];
    serviceConfig = {
      Type = "simple";
      ExecStart = ''${pkgs.keyd}/bin/keyd'';
    };
  };

  networking.firewall = {
    allowedUDPPorts = [51820]; # Clients and peers can use the same port, see listenport
  };

  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;

  # TODO: get this working
  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.100.0.5/24"];
      privateKeyFile = config.sops.secrets.wireguard-key.path;
      listenPort = 51820;

      peers = [
        (import ../common/wireguard/dex-peer.nix)
      ];
    };
  };

  system.stateVersion = "23.05";
}
