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

#   services.xserver.videoDrivers = [ "nvidia" ];
#   hardware.opengl.enable = true;
#
#   hardware.nvidia.prime = {
#     sync.enable = true;
#     # offload.enable = true;
#     intelBusId = "PCI:0:2:0";
#     nvidiaBusId = "PCI:1:0:0";
#   };

  system.stateVersion = "22.11";
}
