{ lib, pkgs, config, modulesPath, ... }:

with lib;
let
  defaultUser = "dane";
  syschdemd = import ./syschdemd.nix { inherit lib pkgs config defaultUser; };
  systemd-email = pkgs.writeShellScriptBin "systemd-email" ''
    ${pkgs.ssmtp}/bin/sendmail -t <<ERRMAIL
    To: $1
    From: systemd <root@$HOSTNAME>
    Subject: $2
    Content-Transfer-Encoding: 8bit
    Content-Type: text/plain; charset=UTF-8

    $(systemctl status --full "$2")
    ERRMAIL
  '';
in
{
  imports = [
    "${modulesPath}/profiles/minimal.nix"
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
    shell = "/home/dane/.nix-profile/bin/zsh";
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

  systemd.services."email-alert@" = {
    enable = true;
    description = "Alert email for %i to user";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${systemd-email}/bin/systemd-email dane@lipscombe.com.au %i";
      User = "nobody";
      Group = "systemd-journal";
    };
  };


  systemd.services.restic-backups-remotebackup.unitConfig.OnFailure = "email-alert@%i.service";
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

  services.ssmtp = {
    enable = true;
    # The user that gets all the mails (UID < 1000, usually the admin)
    root = "dane@lipscombe.com.au";
    useTLS = true;
    useSTARTTLS = true;
    hostName = "smtp.gmail.com:587";
    # The address where the mail appears to come from for user authentication.
    domain = "lipscombe.com.au";
    # Username/Password File
    authUser = "dane@lipscombe.com.au";
    authPassFile = "/mnt/services/ssmtp/pass";
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
