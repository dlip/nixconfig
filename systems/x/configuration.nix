# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let params = {
  hostname = "x";
};
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      (import ../common params)
      ../common/desktop/kde.nix
      ../common/services/kmonad.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-f677fb62-e4b4-4816-847f-1ad76aebd4c2".device = "/dev/disk/by-uuid/f677fb62-e4b4-4816-847f-1ad76aebd4c2";
  boot.initrd.luks.devices."luks-f677fb62-e4b4-4816-847f-1ad76aebd4c2".keyFile = "/crypto_keyfile.bin";

  users.users.dane = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" "dialout" "adbusers" ]; # Enable ‘sudo’ for the user.
    shell = "/etc/profiles/per-user/dane/bin/zsh";
  };

  virtualisation.virtualbox.host.enable = true;
  # boot.extraModprobeConfig = ''
  #   options snd-intel-dspcfg dsp_driver=2
  # '';

  hardware.opengl.enable = true;
  hardware.enableAllFirmware = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    sync.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  services.flatpak.enable = true;

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # Clients and peers can use the same port, see listenport
  };

  # Enable WireGuard
  # networking.wireguard.interfaces = {
  #   # "wg0" is the network interface name. You can name the interface arbitrarily.
  #   wg0 = {
  #     # Determines the IP address and subnet of the client's end of the tunnel interface.
  #     ips = [ "10.100.0.4/32" ];
  #     listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
  #
  #     # Path to the private key file.
  #     #
  #     # Note: The private key can also be included inline via the privateKey option,
  #     # but this makes the private key world-readable; thus, using privateKeyFile is
  #     # recommended.
  #     privateKeyFile = "/home/dane/privatekey";
  #
  #     peers = [
  #       # For a client configuration, one peer entry for the server will suffice.
  #
  #       {
  #         # Public key of the server (not a file path).
  #         publicKey = "+YVMX+HXcyFsfxGWdWC+WdI6nUMkyMdtxsohVDJavlQ=";
  #
  #         # Forward all the traffic via VPN.
  #         allowedIPs = [ "10.10.0.0/24" ];
  #         # Or forward only particular subnets
  #         #allowedIPs = [ "10.100.0.1" "91.108.12.0/22" ];
  #
  #         # Set this to the server IP and port.
  #         endpoint = "lipscombe.ddns.net:51820"; # ToDo: route to endpoint not automatically configured https://wiki.archlinux.org/index.php/WireGuard#Loop_routing https://discourse.nixos.org/t/solved-minimal-firewall-setup-for-wireguard-client/7577
  #
  #         # Send keepalives every 25 seconds. Important to keep NAT tables alive.
  #         persistentKeepalive = 25;
  #       }
  #     ];
  #   };
  # };

  system.stateVersion = "22.11";
}
