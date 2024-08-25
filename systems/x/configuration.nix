# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).
{
  config,
  pkgs,
  ...
}: let
  params = {
    hostname = "x";
  };
in {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    (import ../common params)
    # ../common/desktop/sway.nix
    ../common/desktop/hyprland.nix
    # ../common/desktop/leftwm.nix
    # ../common/desktop/kde.nix
    # ../common/desktop/awesome.nix
    # ../common/desktop/i3.nix
  ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";
  boot.supportedFilesystems = ["ntfs"];

  users.users.dane = {
    isNormalUser = true;
    extraGroups = ["wheel" "docker" "networkmanager" "dialout" "adbusers" "cdrom"]; # Enable ‘sudo’ for the user.
    shell = "/etc/profiles/per-user/dane/bin/zsh";
  };

  environment.systemPackages = with pkgs; [
    plex-mpv-shim
  ];

  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver # LIBVA_DRIVER_NAME=iHD
      vaapiIntel # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  hardware.enableAllFirmware = true;
  hardware.opentabletdriver.enable = true;

  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia = {
    # Modesetting is required.
    modesetting.enable = true;

    # Nvidia power management. Experimental, and can cause sleep/suspend to fail.
    # Enable this if you have graphical corruption issues or application crashes after waking
    # up from sleep. This fixes it by saving the entire VRAM memory to /tmp/ instead
    # of just the bare essentials.
    powerManagement.enable = true;

    # Fine-grained power management. Turns off GPU when not in use.
    # Experimental and only works on modern Nvidia GPUs (Turing or newer).
    powerManagement.finegrained = false;

    # Use the NVidia open source kernel module (not to be confused with the
    # independent third-party "nouveau" open source driver).
    # Support is limited to the Turing and later architectures. Full list of
    # supported GPUs is at:
    # https://github.com/NVIDIA/open-gpu-kernel-modules#compatible-gpus
    # Only available from driver 515.43.04+
    # Currently alpha-quality/buggy, so false is currently the recommended setting.
    open = false;

    # Enable the Nvidia settings menu,
    # accessible via `nvidia-settings`.
    # nvidiaSettings = true;

    # Optionally, you may need to select the appropriate driver version for your specific GPU.
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
  hardware.nvidia.prime = {
    # sync.enable = true;
    offload = {
      enable = true;
      enableOffloadCmd = true;
    };
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
  # services.flatpak.enable = true;

  sops.secrets.nordvpnLogin = {
    sopsFile = ../common/secrets/secrets.yaml;
  };

  # systemd.services.keyd = {
  #   description = "keyd daemon";
  #   wantedBy = ["sysinit.target"];
  #   requires = ["local-fs.target"];
  #   after = ["local-fs.target"];
  #   serviceConfig = {
  #     Type = "simple";
  #     ExecStart = ''${pkgs.keyd}/bin/keyd'';
  #   };
  # };

  services.kanata = {
    enable = true;
    keyboards = {
      laptop = {
        devices = ["/dev/input/by-path/platform-i8042-serio-0-event-kbd"];
        config = builtins.readFile ../../keymaps/kanata/engram.kbd;
      };
    };
  };

  networking.firewall = {
    allowedTCPPorts = [3000];
    allowedUDPPorts = [51820 32412]; # Clients and peers can use the same port, see listenport
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
    dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
    localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  };
  hardware.steam-hardware.enable = true;

  programs.talon.enable = true;
  # TODO: get this working
  networking.wireguard.interfaces = {
    wg0 = {
      ips = ["10.100.0.5/24"];
      privateKeyFile = config.sops.secrets.wireguard-key.path;
      listenPort = 51820;

      peers = [
        (import ../common/wireguard/dex-peer.nix)
      ];
    };
  };

  system.stateVersion = "23.05";
}
