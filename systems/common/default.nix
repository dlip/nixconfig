{hostname}: {
  config,
  pkgs,
  lib,
  ...
}: let
  restic-dex = pkgs.writeShellScriptBin "restic-dex" ''
    export RESTIC_REPOSITORY="/media/backup/restic"
    export RESTIC_PASSWORD_FILE="${config.sops.secrets.restic-encryption.path}"

    ${pkgs.restic}/bin/restic $@
  '';
in {
  imports = [
    ./cachix.nix
    ./services/notify-problems.nix
    ./services/ssmtp.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Enable OBS virtual camera
  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback
  ];
  boot.extraModprobeConfig = ''
    options v4l2loopback devices=1 video_nr=21 card_label="OBS Cam" exclusive_caps=1
  '';
  security.polkit.enable = true;

  system.autoUpgrade = {
    enable = false;
    flake = "github:dlip/nixconfig";
    flags = ["--no-write-lock-file"];
  };

  nix = {
    # package = pkgs.nixUnstable;
    settings.auto-optimise-store = true;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Australia/Sydney";

  i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5.addons = with pkgs; [fcitx5-mozc];
  };

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.hostName = hostname; # Define your hostname.
  networking.useDHCP = false;
  networking.networkmanager.enable = true;
  networking.extraHosts = ''
    10.10.0.123 dex.local
  '';
  networking.enableIPv6 = false;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_AU.UTF-8";
    extraLocaleSettings = {LC_ALL = "en_AU.UTF-8";};
  };

  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
  ];

  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  sops.defaultSopsFile = ./.. + builtins.toPath "/${hostname}/secrets/secrets.yaml";
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;

  sops.secrets.restic-encryption = {};
  sops.secrets.wireguard-key = {};

  # keyring
  services.gnome.gnome-keyring.enable = true;
  programs.seahorse.enable = true;

  # services = {
  #   gnome.gnome-keyring.enable = true;
  #   upower.enable = true;

  #   dbus = {
  #     enable = true;
  #     packages = [pkgs.dconf];
  #   };
  #   xserver = {
  #     enable = true;
  #     layout = "us";
  #     # Enable touchpad support (enabled default in most desktopManager).
  #     libinput.enable = true;
  #     libinput.touchpad.disableWhileTyping = true;
  #   };
  # };

  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome.gvfs;
  };

  services.avahi = {
    enable = true;
    openFirewall = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  networking.firewall = {
    enable = true;
    allowedUDPPorts = [51820]; # wireguard
    allowedTCPPorts = [
      1701
      9001 # weylus
      33455 # remote-touchpad
    ];
  };

  # networking.wireguard.interfaces = {
  #   wg0 = {
  #     listenPort = 51820; # to match firewall allowedUDPPorts (without this wg uses random port numbers)
  #     privateKeyFile = config.sops.secrets.wireguard-key.path;
  #   };
  # };

  services.printing.enable = true;
  services.printing.drivers = with pkgs; [brgenml1lpr brgenml1cupswrapper];

  programs.nm-applet.enable = true;
  hardware.graphics.enable32Bit = true;
  hardware.enableAllFirmware = true;

  programs.adb.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # disable suspend on lid closed
  services.logind.lidSwitch = "ignore";
  # services.autorandr = {
  #   enable = true;
  # };

  services.udev = {
    enable = true;
    # extraRules = ''
    #   ACTION=="change", SUBSYSTEM=="drm", ENV{DISPLAY}=":0", ENV{XAUTHORITY}="/home/dane/.Xauthority", RUN+="${pkgs.bash}/bin/bash /home/dane/code/nixconfig/bin/display-change"
    # '';
  };

  services.acpid = {
    enable = true;
    # lidEventCommands = "${pkgs.bash}/bin/bash /home/dane/code/nixconfig/bin/display-change";
  };

  services.locate.enable = true;

  # Pipewire sound
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
    wireplumber.configPackages = [
      (pkgs.writeTextDir "share/wireplumber/bluetooth.lua.d/51-bluez-config.lua" ''
        bluez_monitor.properties = {
          ["bluez5.enable-sbc-xq"] = true,
          ["bluez5.enable-msbc"] = true,
          ["bluez5.enable-hw-volume"] = true,
          ["bluez5.headset-roles"] = "[ hsp_hs hsp_ag hfp_hf hfp_ag ]",
          ["bluez5.autoswitch-profile"] = true
        }
      '')
    ];
  };

  hardware.bluetooth.enable = true;
  services.blueman.enable = true;
  # services.clamav.daemon.enable = true;
  # services.clamav.updater.enable = true;

  virtualisation.docker.enable = true;
  hardware.nvidia-container-toolkit.enable = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    firefox
    google-chrome
    git
    glxinfo
    pciutils
    pavucontrol
    restic
    restic-dex
    # yubikey-personalization #broken
    pulseaudio
    hunspell
    hunspellDicts.en_US-large
    hunspellDicts.en_AU-large
    hyphen
  ];

  environment.pathsToLink = ["share/hunspell" "share/myspell" "share/hyphen"];
  environment.variables.DICPATH = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";

  hardware.ledger.enable = true;
  # services.udev.packages = with pkgs; [yubikey-personalization via vial];
  # To use the smart card mode (CCID) of Yubikey, you will need the PCSC-Lite daemon:
  services.pcscd.enable = true;

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
}
