# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [ (modulesPath + "/installer/scan/not-detected.nix") ];

  boot.initrd.availableKernelModules = [
    "vfat"
    "nls_cp437"
    "nls_iso8859-1"
    "xhci_hcd"
    "xhci_pci"
    "ahci"
    "usbhid"
    "usb_storage"
    "sd_mod"
  ];
  boot.initrd.luks.yubikeySupport = true;
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  boot.initrd.luks.devices = {
    "nixos-enc" = {
      device = "/dev/sda2";
      preLVM =
        true; # You may want to set this to false if you need to start a network service first
      yubikey = {
        slot = 2;
        twoFactor = true; # Set to false if you did not set up a user password.
        storage = { device = "/dev/sda1"; };
      };
    };
  };

  boot.initrd.secrets = { "lukskey" = "/root/lukskey"; };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/0ce174dc-b00d-4285-ab07-797a67519093";
    fsType = "btrfs";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/0ce174dc-b00d-4285-ab07-797a67519093";
    fsType = "btrfs";
    options = [ "subvol=home" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/F102-2386";
    fsType = "vfat";
  };

  fileSystems."/media/media" = {
    device = "/dev/disk/by-uuid/ffea1765-0616-4311-ac3b-fde6e83ef011"; # UUID for /dev/mapper/media
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = "media";
      blkDev =
        "/dev/disk/by-uuid/7c1152e4-b2a0-421a-815a-ea10ee700667"; # UUID for /dev/sda1
      keyFile = "/lukskey";
    };
  };
  fileSystems."/media/media2" = {
    device = "/dev/disk/by-uuid/bd148b15-4950-4da8-9fd1-17d8a32390d5"; # UUID for /dev/mapper/media2
    fsType = "btrfs";
    encrypted = {
      enable = true;
      label = "media2";
      blkDev =
        "/dev/disk/by-uuid/d5f1a797-6655-4ae4-995a-f42dc02f832a"; # UUID for /dev/sda1
      keyFile = "/lukskey";
    };
  };

  # Why does this not work???
  # fileSystems."/media/backup" = {
  #   device =
  #     "/dev/disk/by-uuid/52c6c483-1036-4bc8-b019-1064e6bc5593"; # UUID for /dev/mapper/media2
  #   fsType = "ext4";
  #   options = [ "nofail" "x-systemd.device-timeout=10" ];
  #   encrypted = {
  #     enable = true;
  #     label = "backup";
  #     blkDev =
  #       "/dev/disk/by-uuid/8c4746b9-7ccb-4a94-8e72-502ea6ff4a49"; # UUID for /dev/sda1
  #     keyFile = "/lukskey";
  #   };
  # };

  fileSystems."/media/games" = {
    device = "/dev/disk/by-uuid/0BB20EC37670AE62";
    fsType = "ntfs";
    options = [ "rw" "uid=1000" ];
  };

  fileSystems."/d" = {
    device = "/media/media";
    options = [ "bind" ];
  };

  fileSystems."/f" = {
    device = "/media/media2";
    options = [ "bind" ];
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/718617a6-3335-48cf-a7ae-e985664a6e64"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
