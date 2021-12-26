# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
let
  dex-services = import ./services.nix;
  downloader-services = import ../downloader/services.nix;
  domain = "home.lipscombe.com.au";

  params = {
    hostname = "dex";
  };
in
rec {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import ../common params)
    ../common/desktop/kde.nix
  ];

  networking.interfaces.enp0s31f6.useDHCP = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  networking.firewall.allowedTCPPorts = [ 445 139 80 22 8000 6443 1234 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];

  services.xserver.videoDrivers = [ "nvidia" ];

  systemd.services.mount-backup = {
    enable = true;
    description = "Mount backup";

    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "root";
    };
    script = ''
      if ! /run/wrappers/bin/mount | grep -q -wi "/media/backup"; then
         ${pkgs.cryptsetup}/bin/cryptsetup --key-file /root/lukskey luksOpen /dev/sdf backup
         /run/wrappers/bin/mount /dev/mapper/backup /media/backup
      fi
    '';
  };

  users.users.tv = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ ]; # Enable ‘sudo’ for the user.
    shell = "/etc/profiles/per-user/tv/bin/zsh";
  };

  environment.systemPackages = with pkgs; [
    google-chrome
  ];

  networking.nat.enable = true;
  networking.nat.internalInterfaces = [ "ve-+" ];
  networking.nat.externalInterface = "enp0s31f6";

  containers.downloader = {
    ephemeral = true;
    autoStart = true;
    enableTun = true;
    config = (import ../downloader/configuration.nix {
      pkgs = pkgs;
      config = config;
    });
    privateNetwork = true;
    hostAddress = "10.1.0.1";
    localAddress = "10.1.0.2";
    bindMounts = {
      "/mnt/services" = {
        hostPath = "/mnt/services";
        isReadOnly = false;
      };
      "/media/media" = {
        hostPath = "/media/media";
        isReadOnly = false;
      };
      "/media/media2" = {
        hostPath = "/media/media2";
        isReadOnly = false;
      };
      "/d" = {
        hostPath = "/d";
        isReadOnly = false;
      };
      "/f" = {
        hostPath = "/f";
        isReadOnly = false;
      };
      "/var/lib" = {
        hostPath = "/mnt/downloader/var/lib";
        isReadOnly = false;
      };
    };
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = (pkgs.lib.attrsets.mapAttrs'
      (name: port:
        pkgs.lib.attrsets.nameValuePair ("${name}.${domain}") ({
          locations."/" = { proxyPass = "http://127.0.0.1:${toString port}"; };
        }))
      dex-services) // (pkgs.lib.attrsets.mapAttrs'
      (name: port:
        pkgs.lib.attrsets.nameValuePair ("${name}.${domain}") ({
          locations."/" = {
            proxyPass =
              "http://${containers.downloader.localAddress}:${toString port}";
          };
        }))
      downloader-services);
  };

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    guiAddress = "0.0.0.0:8384";
    user = "dane";
    group = "users";
  };

  services.plex = {
    enable = true;
    openFirewall = true;
    dataDir = "/mnt/services/plex";
    user = "root";
    group = "root";
  };

  services.restic.backups = {
    dex = {
      paths = [
        "/home"
        "/root"
        "/media/media/dane"
        "/media/media/ryoko"
        "/mnt/services"
        "/mnt/downloader"
        "/var/lib"
      ];
    };
  };
  
  services.restic.server = {
    enable = true;
    listenAddress = "0.0.0.0:8000";
    dataDir = "/media/backup/restic";
    extraFlags = [ "--no-auth" ];
  };

  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = ${params.hostname}
      netbios name = ${params.hostname}
      security = user
      #use sendfile = yes
      #max protocol = smb2
      guest account = nobody
      map to guest = bad user
    '';
    shares = {
      homes = {
        browseable = "no";
        writable = "yes";
      };
      media = {
        path = "/media/media";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
      media2 = {
        path = "/media/media2";
        browseable = "yes";
        "read only" = "no";
        "guest ok" = "no";
        "create mask" = "0644";
        "directory mask" = "0755";
      };
    };
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  sops.secrets.test = { };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}
