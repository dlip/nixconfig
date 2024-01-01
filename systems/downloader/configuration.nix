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
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = with pkgs; [traceroute];
  #-P INPUT ACCEPT
  #-P FORWARD ACCEPT
  #-P OUTPUT ACCEPT
  #-N nixos-fw
  #-N nixos-fw-accept
  #-N nixos-fw-log-refuse
  #-N nixos-fw-refuse
  #-A INPUT -j nixos-fw
  #-A nixos-fw -i lo -j nixos-fw-accept
  #-A nixos-fw -m conntrack --ctstate RELATED,ESTABLISHED -j nixos-fw-accept
  #-A nixos-fw -p tcp -m tcp --dport 6767 -j nixos-fw-accept
  #-A nixos-fw -p tcp -m tcp --dport 7878 -j nixos-fw-accept
  #-A nixos-fw -p tcp -m tcp --dport 8080 -j nixos-fw-accept
  #-A nixos-fw -p tcp -m tcp --dport 8686 -j nixos-fw-accept
  #-A nixos-fw -p tcp -m tcp --dport 8989 -j nixos-fw-accept
  #-A nixos-fw -p tcp -m tcp --dport 9696 -j nixos-fw-accept
  #-A nixos-fw -p icmp -m icmp --icmp-type 8 -j nixos-fw-accept
  #-A nixos-fw -j nixos-fw-log-refuse
  #-A nixos-fw-accept -j ACCEPT
  #-A nixos-fw-log-refuse -p tcp -m tcp --tcp-flags FIN,SYN,RST,ACK SYN -j LOG --log-prefix "refused connection: " --log-level 6
  #-A nixos-fw-log-refuse -m pkttype ! --pkt-type unicast -j nixos-fw-refuse
  #-A nixos-fw-log-refuse -j nixos-fw-refuse
  #-A nixos-fw-refuse -j DROP
  networking = {
    nameservers = ["1.1.1.1" "8.8.8.8" "8.8.4.4"];
    firewall = {
      enable = true;
      allowedTCPPorts = pkgs.lib.attrsets.attrValues downloader-services;
      # extraCommands = ''
      #   # Flush the tables. This may cut the system's internet.
      #   iptables -F
      #
      #   # The default policy, if no other rules match, is to refuse traffic.
      #   iptables -P OUTPUT DROP
      #   iptables -P INPUT DROP
      #   iptables -P FORWARD DROP
      #
      #   # Let the VPN client communicate with the outside world.
      #   iptables -A OUTPUT -j ACCEPT -m owner --gid-owner openvpn
      #
      #   # The loopback device is harmless, and TUN is required for the VPN.
      #   iptables -A OUTPUT -j ACCEPT -o lo
      #   iptables -A OUTPUT -j ACCEPT -o tun+
      #
      #   # We should permit replies to traffic we've sent out.
      #   iptables -A INPUT -j ACCEPT -m state --state ESTABLISHED
      # '';
    };
  };

  users.users.openvpn = {
    isSystemUser = true;
    group = "openvpn";
  };
  users.groups.openvpn = {};

  systemd.services.nordvpn = {
    enable = true;
    wantedBy = ["sysinit.target"];
    after = ["network.target"];
    description = "nordvpn";
    serviceConfig = {
      Type = "notify";
      Restart = "always";
      ExecStart = "${pkgs.openvpn}/bin/openvpn --user openvpn --config /mnt/services/openvpn/nordvpn.ovpn";
    };
  };

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = ["/var/lib/ssh/ssh_host_ed25519_key"];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;
  # Secrets
  sops.secrets.restic-encryption = {};
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
  services.bazarr = {enable = true;};
  services.prowlarr = {enable = true;};

  services.qbittorrent = {
    enable = true;
    user = "root";
    group = "root";
  };

  system.stateVersion = "23.05";
}
