# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../cachix.nix
      ../../services/notify-problems.nix
      ../../services/ssmtp.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  networking.hostName = "g"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp0s20f3.useDHCP = true;
  networking.networkmanager.enable = true;
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
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = true;
          enableXfwm = false;
          thunarPlugins = [ pkgs.xfce.thunar-archive-plugin ];
        };
      };
      windowManager = {
        xmonad = {
          enable = true;
          enableContribAndExtras = true;
          extraPackages = haskellPackages: [
            haskellPackages.xmonad-contrib
            haskellPackages.xmonad-extras
            haskellPackages.xmonad
          ];
        };
      };

      displayManager = {
        lightdm.enable = true;
        defaultSession = "none+xmonad";
        autoLogin.enable = true;
        autoLogin.user = "dane";
      };

      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
      libinput.touchpad.disableWhileTyping = true;

    };
  };

  programs.nm-applet.enable = true;

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia.prime = {
    offload.enable = true;
    # Bus ID of the Intel GPU. You can find it using lspci, either under 3D or VGA
    intelBusId = "PCI:0:2:0";
    # Bus ID of the NVIDIA GPU. You can find it using lspci, either under 3D or VGA
    nvidiaBusId = "PCI:1:0:0";
  };

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

  nixpkgs.config.allowUnfree = true;
  # Configure keymap in X11
  # services.xserver.layout = "us";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.bluetooth.enable = true;
  services.blueman.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.dane = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "networkmanager" ]; # Enable ‘sudo’ for the user.
    shell = "/home/dane/.nix-profile/bin/zsh";
  };

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
    yubikey-personalization
  ];
  services.udev.packages = with pkgs; [ yubikey-personalization ];
  # To use the smart card mode (CCID) of Yubikey, you will need the PCSC-Lite daemon:
  services.pcscd.enable = true;


  environment.etc.restic-ignore.text = ''
    .cache
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
      repository = "rest:http://10.10.0.123:8000/q";
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

  systemd.services.kmonad = {
    enable = true;
    description = "kmonad";
    wantedBy = [ "multi-user.target" ];
    script = ''
      ${pkgs.kmonad}/bin/kmonad -i 'device-file "/dev/input/by-path/platform-i8042-serio-0-event-kbd"' ${../../keymaps/kmonad/spaceonly.kbd}
    '';
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

