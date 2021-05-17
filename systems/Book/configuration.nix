{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  defaultUser = "dane";
  syschdemd = import ./syschdemd.nix { inherit lib pkgs config defaultUser; };
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
    ../../services/notify-problems.nix
    ../../services/ssmtp.nix
  ];

  # WSL is closer to a container than anything else
  boot.isContainer = true;

  environment.etc.hosts.enable = false;
  environment.etc."resolv.conf".enable = false;

  networking.hostName = "Book"; # Define your hostname.
  networking.dhcpcd.enable = false;

  time.timeZone = "Australia/Sydney";
  users.users.${defaultUser} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = "/home/${defaultUser}/.nix-profile/bin/zsh";
  };

  users.users.root = {
    shell = "${syschdemd}/bin/syschdemd";
    # Otherwise WSL fails to login as root with "initgroups failed 5"
    extraGroups = [ "root" ];
  };

  security.sudo.wheelNeedsPassword = false;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  systemd.services.restic-backups-remotebackup.unitConfig.OnFailure = "notify-problems@%i.service";
  services.restic.backups = {
    remotebackup = {
      paths = [ "/home" "/root" ];
      repository = "sftp:dane@10.10.0.123:/media/media/dane-backup/restic";
      passwordFile = "/root/backup/restic-password";
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };


  environment.systemPackages = with pkgs; [
    git
    vim
    restic
  ];
  # Disable systemd units that don't make sense on WSL
  systemd.services."serial-getty@ttyS0".enable = false;
  systemd.services."serial-getty@hvc0".enable = false;
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@".enable = false;

  systemd.services.firewall.enable = false;
  systemd.services.systemd-resolved.enable = false;
  systemd.services.systemd-udevd.enable = false;

  # Don't allow emergency mode, because we don't have a console.
  systemd.enableEmergencyMode = false;
}
