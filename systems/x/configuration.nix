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
    ../common/desktop/leftwm.nix
    # ../common/desktop/kde.nix
    ../common/services/kmonad.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = ["ntfs"];
  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable swap on luks
  boot.initrd.luks.devices."luks-f677fb62-e4b4-4816-847f-1ad76aebd4c2".device = "/dev/disk/by-uuid/f677fb62-e4b4-4816-847f-1ad76aebd4c2";
  boot.initrd.luks.devices."luks-f677fb62-e4b4-4816-847f-1ad76aebd4c2".keyFile = "/crypto_keyfile.bin";

  users.users.dane = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "networkmanager" "dialout" "adbusers"]; # Enable ‘sudo’ for the user.
    shell = "/etc/profiles/per-user/dane/bin/zsh";
  };

  virtualisation.virtualbox.host.enable = true;
  # boot.extraModprobeConfig = ''
  #   options snd-intel-dspcfg dsp_driver=2
  # '';

  hardware.opengl.enable = true;
  hardware.enableAllFirmware = true;

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.modesetting.enable = true;
  # hardware.nvidia.powerManagement.enable = false;
  hardware.nvidia.prime = {
    # sync.enable = true;
    offload.enable = true;
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  # services.flatpak.enable = true;

  networking.firewall = {
    allowedUDPPorts = [51820]; # Clients and peers can use the same port, see listenport
  };

  # programs.steam.enable = true;
  # hardware.steam-hardware.enable = true;

  # TODO: get this working
  # networking.wireguard.interfaces = {
  #   wg0 = {
  #     ips = ["10.100.0.5/24"];
  #     privateKeyFile = config.sops.secrets.wireguard-key.path;
  #     listenPort = 51820;

  #     peers = [
  #       (import ../common/wireguard/dex-peer.nix)
  #     ];
  #   };
  # };

  system.stateVersion = "23.05";
}
