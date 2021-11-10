{ hostname }:
{ config, pkgs, lib, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
  restic-dex = pkgs.writeShellScriptBin "restic-dex" ''
    export RESTIC_REPOSITORY="rest:http://10.10.0.123:8000/metabox"
    export RESTIC_PASSWORD="$(cat /root/restic-password)"

    ${pkgs.restic}/bin/restic $@
  '';
in
{
  imports =
    [
      ./cachix.nix
      ./services/notify-problems.nix
      ./services/ssmtp.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nixpkgs.config.allowUnfree = true;
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.hostName = hostname; # Define your hostname.
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    10.10.0.1 dex
  '';
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    extraLocaleSettings = { LC_ALL = "en_US.UTF-8"; };
    inputMethod = {
      enabled = "ibus";
      ibus.engines = with pkgs.ibus-engines; [ anthy ];
    };
  };

  fonts.fonts = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.gnome3.dconf ];
    };
    xserver = {
      enable = true;

      layout = "us";

      displayManager = {
        lightdm.enable = true;
        defaultSession = "xfce+awesome";
        autoLogin.enable = true;
        autoLogin.user = "dane";
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
          thunarPlugins = [ pkgs.xfce.thunar-archive-plugin ];
        };
      };
      windowManager.awesome = {
        enable = true;
        luaModules = with pkgs.luaPackages; [
          luarocks # is the package manager for Lua modules
          luadbi-mysql # Database abstraction layer
        ];
      };
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
      libinput.touchpad.disableWhileTyping = true;
    };
  };


  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome3.gvfs;
  };
  services.avahi = {
    enable = true;
    nssmdns = true;
  };

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [ brgenml1lpr brgenml1cupswrapper ];

  programs.nm-applet.enable = true;
  hardware.opengl.driSupport32Bit = true;

  # Enable the Plasma 5 Desktop Environment.
  # services.xserver.displayManager.sddm.enable = true;
  # services.xserver.desktopManager.plasma5.enable = true;
  # services.xserver.windowManager.session =
  #   let
  #     # Allow for per-system injected Emacs configuration.
  #     loadScript = pkgs.writeText "emacs-exwm-load" ''
  #       (require 'init-exwm)
  #     '';
  #   in
  #   lib.singleton {
  #     name = "exwm";
  #     start = ''
  #       ${pkgs.dbus.dbus-launch} --exit-with-session emacs -mm --fullscreen \
  #         -l "${loadScript}"
  #     '';
  #   };

  # services.xserver.windowManager.xmonad = {
  #   # displayManager = {
  #   #   defaultSession = lib.mkDefault "none+xmonad";
  #   # };

  #   enable = true;
  #   enableContribAndExtras = true;
  # };

  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

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
    media-session.config.bluez-monitor.rules = [
      {
        # Matches all cards
        matches = [{ "device.name" = "~bluez_card.*"; }];
        actions = {
          "update-props" = {
            "bluez5.reconnect-profiles" = [ "hfp_hf" "hsp_hs" "a2dp_sink" ];
            # mSBC is not expected to work on all headset + adapter combinations.
            "bluez5.msbc-support" = true;
            # SBC-XQ is not expected to work on all headset + adapter combinations.
            "bluez5.sbc-xq-support" = true;
          };
        };
      }
      {
        matches = [
          # Matches all sources
          { "node.name" = "~bluez_input.*"; }
          # Matches all outputs
          { "node.name" = "~bluez_output.*"; }
        ];
        actions = {
          "node.pause-on-idle" = false;
        };
      }
    ];
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dane = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = "/home/dane/.nix-profile/bin/zsh";
  };

  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;
  systemd.enableUnifiedCgroupHierarchy = false;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    git
    glxinfo
    pciutils
    nvidia-offload
    wine
    dropbox
    pavucontrol
    restic
    restic-dex
    yubikey-personalization
    pulseaudio
  ];

  hardware.ledger.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization via vial ];
  # To use the smart card mode (CCID) of Yubikey, you will need the PCSC-Lite daemon:
  services.pcscd.enable = true;


  environment.etc.restic-ignore.text = ''
    .cache
    .Cache
    /var/lib/docker
    .rustup
    .spago
    .vscode
    Dropbox
    Google Drive
    Temp
    VirtualBox VMs
    node_modules
  '';
  systemd.services.restic-backups-dex.unitConfig.OnFailure = "notify-problems@%i.service";
  services.restic.backups = {
    dex = {
      paths = [ "/home" "/root" "/var/lib" ];
      repository = "rest:http://dex:8000/${hostname}";
      passwordFile = "/root/restic-password";
      pruneOpts = [
        "--keep-daily 7"
        "--keep-weekly 4"
      ];
      extraBackupArgs = [ "--exclude-file=/etc/restic-ignore" "--verbose" "2" ];
      timerConfig = {
        OnCalendar = "daily";
        Persistent = true;
      };
    };
  };

  services.syncthing = {
    enable = true;
    user = "dane";
    group = "users";
  };

  services.espanso.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?

}

