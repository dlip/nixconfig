# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  lib,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ../common/services/qbittorrent.nix
    ./hardware-configuration.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  #boot.loader.systemd-boot.configurationLimit = 1;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "ptv"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_AU.UTF-8";
    LC_IDENTIFICATION = "en_AU.UTF-8";
    LC_MEASUREMENT = "en_AU.UTF-8";
    LC_MONETARY = "en_AU.UTF-8";
    LC_NAME = "en_AU.UTF-8";
    LC_NUMERIC = "en_AU.UTF-8";
    LC_PAPER = "en_AU.UTF-8";
    LC_TELEPHONE = "en_AU.UTF-8";
    LC_TIME = "en_AU.UTF-8";
  };

  # Enable the XFCE Desktop Environment.
  services.xserver = {
    enable = true;
    desktopManager.xfce.enable = true;
    displayManager = {
      lightdm.enable = true;
      defaultSession = "xfce";
      autoLogin.enable = true;
      autoLogin.user = "tv";
    };
  };

  # Configure keymap in X11
  services.xserver = {
    layout = "au";
    xkbVariant = "";
  };

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "xfce4-session";
  networking.firewall.allowedTCPPorts = [3389];
  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  hardware.opengl = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
    ];
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.tv = {
    isNormalUser = true;
    description = "tv";
    extraGroups = ["networkmanager" "wheel"];
  };

  users.users.dane = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "networkmanager" "dialout" "adbusers"]; # Enable ‘sudo’ for the user.
    shell = "/etc/profiles/per-user/dane/bin/zsh";
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    #  wget
    pavucontrol
    xfce.xfce4-pulseaudio-plugin
    xfce.xfce4-volumed-pulse
    google-chrome
    kodi
    zoom-us
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;
  # Secrets
  sops.secrets.nordvpnLogin = {};

  services.openvpn.servers = {
    nordvpn = {
      updateResolvConf = true;
      config = "config /var/lib/openvpn/nordvpn.ovpn";
    };
  };

  services.jellyfin = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
  };

  services.sonarr = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
  };
  services.radarr = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
  };
  services.lidarr = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
  };

  services.prowlarr = {
    enable = true;
    openFirewall = true;
  };

  services.qbittorrent = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
  };

  # systemd.services.podgrab.environment.DATA = lib.mkForce "/media/media/podcasts";
  # systemd.services.podgrab.serviceConfig.DynamicUser = lib.mkForce false;
  # services.podgrab = {
  #   enable = true;
  #   port = 4242;
  # };
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
  };

  virtualisation.oci-containers = {
    backend = "docker";
    containers = {
      homepage = {
        image = "ghcr.io/benphelps/homepage:latest";
        volumes = [
          "/var/lib/homepage/config:/app/config"
          "/var/run/docker.sock:/var/run/docker.sock"
          "/media/media:/media/media"
        ];
        extraOptions = ["--network=host"];
      };
      audiobookshelf = {
        image = "ghcr.io/advplyr/audiobookshelf";
        ports = ["13378:80"];
        volumes = [
          "/var/lib/audiobookshelf/config:/config"
          "/var/lib/audiobookshelf/metadata:/metadata"
          "/media/media/audiobooks:/audiobooks"
          "/media/media/books:/books"
          "/media/media/podcasts:/podcasts"
        ];
      };
      readarr = {
        image = "lscr.io/linuxserver/readarr:develop";
        extraOptions = ["--network=host"];
        environment = {
          PUID = "0";
          PGID = "0";
          TZ = "Australia/Sydney";
        };

        volumes = [
          "/var/lib/readarr/config:/config"
          "/media/media:/media/media"
        ];
      };
      readarr-audiobook = {
        image = "lscr.io/linuxserver/readarr:develop";
        extraOptions = ["--network=host"];
        environment = {
          PUID = "0";
          PGID = "0";
          TZ = "Australia/Sydney";
          PORT = "8788";
        };

        volumes = [
          "/var/lib/readarr-audiobook/config:/config"
          "/media/media:/media/media"
        ];
      };
    };
  };

  # sops.secrets.wireguard-key = {};
  # networking.wireguard.interfaces = {
  #   wg0 = {
  #     ips = ["10.100.0.6/24"];
  #     privateKeyFile = config.sops.secrets.wireguard-key.path;
  #     listenPort = 51820;

  #     peers = [
  #       (import ../common/wireguard/dex-peer.nix)
  #     ];
  #   };
  # };
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?
}
