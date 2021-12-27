{ config, pkgs, ... }:
let downloader-services = import ./services.nix;
in
{
  imports = [
    ../common/services/qbittorrent.nix
    pkgs.sops-nix.nixosModule
  ];
  
  nixpkgs.config.allowUnfree = true;

  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

  environment.systemPackages = with pkgs; [ traceroute ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = pkgs.lib.attrsets.attrValues downloader-services;
    };
  };

  sops.defaultSopsFile = ./secrets/secrets.yaml;
  # This will automatically import SSH keys as age keys
  sops.age.sshKeyPaths = [ "/var/lib/ssh/ssh_host_ed25519_key" ];
  # This is using an age key that is expected to already be in the filesystem
  sops.age.keyFile = "/var/lib/sops-nix/key.txt";
  # This will generate a new key if the key specified above does not exist
  sops.age.generateKey = true;
  # qbittorrent stops downloading when vpn gets reconnected
  sops.secrets.restic-encryption = { };

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
    wantedBy = [ "timers.target" ];
    partOf = [ "restart-qbittorrent.service" ];
    timerConfig = {
      OnActiveSec = "4h";
      OnUnitActiveSec = "4h";
    };
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
  services.openvpn.servers = {
    nordvpn = {
      updateResolvConf = true;
      config = "config /mnt/services/openvpn/nordvpn.ovpn";
    };
  };
  systemd.services.transmission = {
    bindsTo = [ "openvpn-nordvpn.service" ];
    after = [ "openvpn-nordvpn.service" ];
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
  services.bazarr = { enable = true; };
  services.jackett = { enable = true; };

  services.qbittorrent = {
    enable = true;
    user = "root";
    group = "root";
  };
  services.nzbhydra2 = {
    enable = true;
  };

}
