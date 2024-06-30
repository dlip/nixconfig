# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
# trace: warning: using unmanaged configuration for homepage-dashboard is deprecated and will be removed in 24.05. please see the NixOS documentation for `services.homepage-dashboard' and add your bookmarks, services, widgets, and other configuration using the options provided.
{
  config,
  pkgs,
  lib,
  ...
}: let
  ptv-services = import ./services.nix;
  downloader-services = import ../downloader/services.nix;
  domain = "ptv-lips.duckdns.org";
in rec {
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

  nix = {
    settings.auto-optimise-store = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
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
  services = {
    displayManager = {
      defaultSession = "xfce";
      autoLogin.enable = true;
      autoLogin.user = "tv";
    };
    xserver = {
      enable = true;
      desktopManager.xfce.enable = true;
      displayManager.lightdm.enable = true;
      xkb = {
        layout = "au";
        variant = "";
      };
    };
  };

  services.xrdp.enable = true;
  services.xrdp.defaultWindowManager = "xfce4-session";
  networking.firewall.allowedTCPPorts = [80 443 3389];
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

  hardware.graphics = {
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
    shell = "/etc/profiles/per-user/tv/bin/zsh";
  };

  users.users.dane = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "networkmanager" "dialout" "adbusers"]; # Enable ‘sudo’ for the user.
    shell = "/etc/profiles/per-user/dane/bin/zsh";
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Allow unfree packages
  # nixpkgs.config.allowUnfree = true;

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
    # (pkgs.kodi.passthru.withPackages (kodiPkgs:
    #   with kodiPkgs; [
    #     jellyfin
    #   ]))
    # zoom-us
  ];

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;

  networking.nat.enable = true;
  networking.nat.internalInterfaces = ["wg0" "ve-+"];
  networking.nat.externalInterface = "wlp1s0";

  containers.downloader = {
    ephemeral = true;
    autoStart = true;
    enableTun = true;
    config = import ../downloader/configuration.nix {
      inherit pkgs config;
    };
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
      "/var/lib" = {
        hostPath = "/mnt/downloader/var/lib";
        isReadOnly = false;
      };
      "/var/run/secrets" = {
        hostPath = "/var/run/secrets";
        isReadOnly = false;
      };
      "/run/secrets.d" = {
        hostPath = "/run/secrets.d";
        isReadOnly = false;
      };
    };
  };

  sops.secrets.traefik-env = {
    owner = "traefik";
    group = "traefik";
    sopsFile = ../common/secrets/secrets.yaml;
  };

  services.cron.systemCronJobs = [
    ''*/10 * * * * root eval "export `cat /var/run/secrets/traefik-env`" && ${pkgs.curl}/bin/curl http://www.duckdns.org/update/plips-home/$DUCKDNS_TOKEN''
  ];

  systemd.services.traefik.serviceConfig.EnvironmentFile = ["/var/run/secrets/traefik-env"];
  services.traefik = {
    enable = true;
    staticConfigOptions = {
      log.level = "DEBUG";
      api = {
        dashboard = true;
      };
      certificatesResolvers.letsencrypt.acme = {
        email = "danelipscombe@gmail.com";
        storage = "/var/lib/traefik/acme.json";
        dnsChallenge = {
          provider = "duckdns";
          delayBeforeCheck = 5;
          resolvers = [
            "1.1.1.1:53"
            "8.8.8.8:53"
          ];
        };
      };
      entryPoints = {
        web = {
          address = ":80";
          http.redirections.entrypoint = {
            to = "websecure";
            scheme = "https";
          };
        };
        websecure = {
          address = ":443";

          http.tls = {
            certResolver = "letsencrypt";
          };
        };
      };
    };
    dynamicConfigOptions = {
      http = {
        routers =
          {
            traefik = {
              rule = "Host(`traefik.${domain}`)";
              service = "api@internal";
              tls = {
                domains = [
                  {
                    main = "*.${domain}";
                  }
                ];
                certResolver = "letsencrypt";
              };
            };
          }
          // pkgs.lib.attrsets.mapAttrs'
          (name: port:
            pkgs.lib.attrsets.nameValuePair "${name}"
            {
              rule = "Host(`${name}.${domain}`)";
              service = "${name}";
              tls = {
                domains = [
                  {
                    main = "*.${domain}";
                  }
                ];
                certResolver = "letsencrypt";
              };
            })
          (ptv-services // downloader-services);

        services =
          (pkgs.lib.attrsets.mapAttrs'
            (name: port:
              pkgs.lib.attrsets.nameValuePair "${name}"
              {
                loadBalancer.servers = [{url = "http://127.0.0.1:${toString port}/";}];
              })
            ptv-services)
          // (pkgs.lib.attrsets.mapAttrs'
            (name: port:
              pkgs.lib.attrsets.nameValuePair "${name}"
              {
                loadBalancer.servers = [{url = "http://${containers.downloader.localAddress}:${toString port}/";}];
              })
            downloader-services);
      };
    };
  };
  sops.secrets.nordvpnLogin = {
    sopsFile = ../common/secrets/secrets.yaml;
  };
  #
  services.jellyfin = {
    enable = true;
    user = "root";
    group = "root";
    openFirewall = true;
  };
  services.homepage-dashboard.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh = {
    enable = true;
    openFirewall = true;
  };
  services.audiobookshelf = {
    enable = true;
    port = 13378;
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
  system.stateVersion = "23.05"; # Did you read the comment?
}
