# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let
  dex-services = import ./services.nix;
  downloader-services = import ../downloader/services.nix;
  domain = "home.lipscombe.com.au";
in
rec {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../cachix.nix
  ];

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "dex"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  i18n = {
    defaultLocale = "en_US.UTF-8";
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ anthy ];
    };
  };

  fonts.fonts = with pkgs; [
    overpass
    source-han-code-jp
    source-serif-pro
    (nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; })
  ];

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the Plasma 5 Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

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
      ${pkgs.cryptsetup}/bin/cryptsetup --key-file /root/lukskey luksOpen /dev/sdf backup
      /run/wrappers/bin/mount /dev/mapper/backup /media/backup
    '';
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dane = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
    shell = "/home/dane/.nix-profile/bin/zsh";
  };

  users.users.tv = {
    isNormalUser = true;
    initialPassword = "password";
    extraGroups = [ ]; # Enable ‘sudo’ for the user.
    shell = "/home/tv/.nix-profile/bin/zsh";
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    firefox
    glxinfo
    pciutils
    git
    restic
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

  services.plex = {
    enable = true;
    openFirewall = true;
    dataDir = "/mnt/services/plex";
    user = "root";
    group = "root";
  };

  services.cron = {
    enable = true;
    mailto = "dane@lipscombe.com.au";
    systemCronJobs = [
      "46 16 * * *      root    cd /root/backup && ./restic-backup.sh"
    ];
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
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  services.samba = {
    enable = true;
    securityType = "user";
    extraConfig = ''
      workgroup = WORKGROUP
      server string = ${networking.hostName}
      netbios name = ${networking.hostName}
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
  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.enable = true;
  networking.firewall.allowPing = true;

  networking.firewall.allowedTCPPorts = [ 445 139 80 22 ];
  networking.firewall.allowedUDPPorts = [ 137 138 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}
