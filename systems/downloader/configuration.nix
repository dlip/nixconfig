{
  config,
  pkgs,
  ...
}: let
  downloader-services = import ./services.nix;
in {
  imports = [
    ../common/services/qbittorrent.nix
    ../common/services/ssmtp.nix
    pkgs.sops-nix.nixosModules.default
  ];

  nixpkgs.config.allowUnfree = true;

  nix = {
    # package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = with pkgs; [traceroute];
  networking = {
    nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];
    firewall = {
      enable = true;
      allowedTCPPorts = pkgs.lib.attrsets.attrValues downloader-services;
      extraCommands = ''
        # The default policy, if no other rules match, is to refuse traffic.
        iptables -P OUTPUT DROP

        # Let the VPN client communicate with the outside world.
        iptables -A OUTPUT -p udp -m udp --dport 1194 -j ACCEPT

        # The loopback device is harmless, and TUN is required for the VPN.
        iptables -A OUTPUT -j ACCEPT -o lo
        iptables -A OUTPUT -j ACCEPT -o tun+

        # Allow to communicate within the LAN
        iptables -A OUTPUT -s 10.1.0.0/24 -d 10.1.0.0/24 -j ACCEPT
      '';
    };
  };

  sops.defaultSopsFile = ../common/secrets/secrets.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = ["/var/lib/ssh/ssh_host_ed25519_key"];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;
  # Secrets
  sops.secrets.nordvpnLogin = {};

  # qbittorrent stops downloading when vpn gets reconnected
  systemd.services.restart-qbittorrent = {
    enable = true;
    description = "Restart qbittorrent";

    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "root";
    };
    script = ''
      systemctl restart qbittorrent
    '';
  };

  systemd.timers.restart-qbittorrent = {
    wantedBy = ["timers.target"];
    partOf = ["restart-qbittorrent.service"];
    timerConfig = {
      OnActiveSec = "4h";
      OnUnitActiveSec = "4h";
    };
  };

  services.openvpn.servers = {
    nordvpn = {
      updateResolvConf = true;
      config = "config /mnt/services/openvpn/nordvpn.ovpn";
    };
  };

  systemd.services.transmission = {
    bindsTo = ["openvpn-nordvpn.service"];
    after = ["openvpn-nordvpn.service"];
    serviceConfig.Restart = "always";
  };

  services.sonarr = {
    enable = true;
    user = "root";
    group = "root";
  };
  services.radarr = {
    enable = true;
    user = "root";
    group = "root";
  };
  services.lidarr = {
    enable = true;
    user = "root";
    group = "root";
  };
  services.readarr = {
    enable = true;
    user = "root";
    group = "root";
  };
  services.bazarr = {enable = true;};
  # https://github.com/NixOS/nixpkgs/issues/155475
  systemd.services.prowlarr.environment.HOME = "/var/empty";
  services.prowlarr = {enable = true;};

  services.qbittorrent = {
    enable = true;
    user = "root";
    group = "root";
  };

  # services.suwayomi-server = {
  #   enable = true;
  #   user = "root";
  #   group = "root";
  #   dataDir = "/media/media/manga";
  #   settings = {
  #     server.port = 4567;
  #   };
  # };

  system.stateVersion = "23.05";
}
