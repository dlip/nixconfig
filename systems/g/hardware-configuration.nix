# Do not modify this file!  It was generated by ‘nixos-generate-config’
# and may be overwritten by future invocations.  Please make changes
# to /etc/nixos/configuration.nix instead.
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/753d3e68-9a95-4238-9f78-af31847bfda2";
      fsType = "ext4";
    };

  boot.initrd.luks.devices."cryptroot".device = "/dev/disk/by-uuid/5de849de-b7fd-47af-b535-b2e2402914b8";

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/5CC5-A822";
      fsType = "vfat";
    };

  # fileSystems."/mnt/share" = {
  #     device = "//10.10.0.123/media/media/dane";
  #     fsType = "cifs";
  #     options = let
  #       # this line prevents hanging on network split
  #       automount_opts = "x-systemd.automount,noauto,x-systemd.idle-timeout=60,x-systemd.device-timeout=5s,x-systemd.mount-timeout=5s";

  #     in ["${automount_opts},credentials=/etc/nixos/smb-secrets"];
  # };

  swapDevices = [{ device = "/.swapfile"; }];

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
}
