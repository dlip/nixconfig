{ hostname }:

{ config, pkgs, lib, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec "$@"
  '';
  restic-dex = pkgs.writeShellScriptBin "restic-dex" ''
    export RESTIC_REPOSITORY="/media/backup/restic"
    export RESTIC_PASSWORD_FILE="${config.sops.secrets.restic-encryption.path}"

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

  system.autoUpgrade = {
    enable = true;
    flake = "github:dlip/nixconfig";
    flags = [ "--no-write-lock-file" ];
  };

  nixpkgs.config.allowUnfree = true;
  nixpkgs.config.permittedInsecurePackages = [
    "electron-13.6.9"
  ];
  nix = {
    package = pkgs.nixUnstable;
    settings.auto-optimise-store = true;
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
    10.10.0.123 dex.local
  '';

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_AU.UTF-8";
    extraLocaleSettings = { LC_ALL = "en_AU.UTF-8"; };
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

  zramSwap = {
    enable = true;
    memoryPercent = 100;
  };

  sops.defaultSopsFile = ./.. + builtins.toPath "/${hostname}/secrets/secrets.yaml";
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;

  sops.secrets.restic-encryption = { };
  sops.secrets.wireguard-key = { };

  services = {
    gnome.gnome-keyring.enable = true;
    upower.enable = true;

    dbus = {
      enable = true;
      packages = [ pkgs.dconf ];
    };
    xserver = {
      enable = true;
      layout = "us";
      # Enable touchpad support (enabled default in most desktopManager).
      libinput.enable = true;
      libinput.touchpad.disableWhileTyping = true;
    };
  };

  services.gvfs = {
    enable = true;
    package = lib.mkForce pkgs.gnome.gvfs;
  };

  services.avahi = {
    enable = true;
    nssmdns = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };

  networking.firewall = {
    allowedUDPPorts = [ 51820 ]; # wireguard
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
  services.printing.drivers = with pkgs; [ brgenml1lpr brgenml1cupswrapper ];

  programs.nm-applet.enable = true;
  hardware.opengl.driSupport32Bit = true;

  programs.adb.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;


  # disable suspend on lid closed
  services.logind.lidSwitch = "ignore";
  services.autorandr = {
    enable = true;
  };
  services.acpid = {
    enable = true;
    lidEventCommands = ''
      export PATH=/run/wrappers/bin:/run/current-system/sw/bin:$PATH
      export DISPLAY=":0"
      export XAUTHORITY="/home/dane/.Xauthority"
      export LID_STATE=$(awk '{print$NF}' /proc/acpi/button/lid/LID/state)
      if [[ $LID_STATE == "closed" ]]; then
        xrandr --output eDP-1-1 --off
      else
        xrandr --auto
        autorandr --change horizontal
      fi
    '';
  };

  # Pipewire sound
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

  virtualisation.docker.enable = true;
  virtualisation.docker.enableNvidia = true;
  systemd.enableUnifiedCgroupHierarchy = false;

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
    nvidia-offload
    wine
    wine64
    winetricks
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

  environment.pathsToLink = [ "share/hunspell" "share/myspell" "share/hyphen" ];
  environment.variables.DICPATH = "/run/current-system/sw/share/hunspell:/run/current-system/sw/share/hyphen";

  hardware.ledger.enable = true;
  services.udev.packages = with pkgs; [ yubikey-personalization via vial ];
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

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.11"; # Did you read the comment?

}
