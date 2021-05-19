{ config, pkgs, ... }:
let downloader-services = import ./services.nix;
in
{
  imports = [
    ../../services/qbittorrent.nix
  ];
  environment.systemPackages = with pkgs; [ traceroute ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = pkgs.lib.attrsets.attrValues downloader-services;
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
  services.bazarr = { enable = true; };
  services.jackett = { enable = true; };

  services.qbittorrent = {
    enable = true;
  };
}
