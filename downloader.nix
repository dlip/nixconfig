{ config, pkgs, ... }:
let
  domain = "downloader.lipscombe.com.au";
  services = import ./downloader-services.nix;
in {
  environment.systemPackages = with pkgs; [ traceroute ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        80 # nginx
        8989 # sonarr
        7878 # radarr
        9091 # transmission
      ];
    };
  };

  services.openvpn.servers = {
    nordvpn = {
      updateResolvConf = true;
      config = "config /root/openvpn/nord.conf";
    };
  };
  systemd.services.transmission = {
    bindsTo = [ "openvpn-nordvpn.service" ];
    after = [ "openvpn-nordvpn.service" ];
    serviceConfig.Restart = "always";
  };

  services.nginx = {
    enable = true;
    recommendedProxySettings = true;
    virtualHosts = pkgs.lib.attrsets.mapAttrs' (name: port:
      pkgs.lib.attrsets.nameValuePair ("${name}.${domain}") ({
        locations."/" = { proxyPass = "http://127.0.0.1:${toString port}"; };
      })) services;
  };
  services.sonarr = { enable = true; };
  services.radarr = { enable = true; };
  services.bazarr = { enable = true; };
  services.transmission = {
    enable = true;
    settings = {
      download-dir = "/mnt/transmission";
      incomplete-dir = "/mnt/transmission/incomplete";
      incomplete-dir-enabled = true;
      message-level = 1;
      umask = "002";
      rpc-whitelist-enabled = false;
      rpc-host-whitelist-enabled = false;

      # "normal" speed limits
      speed-limit-down-enabled = false;
      speed-limit-down = 800;
      speed-limit-up-enabled = true;
      speed-limit-up = 50;
      upload-slots-per-torrent = 8;
      # Queuing
      # When true, Transmission will only download
      # download-queue-size non-stalled torrents at once.
      download-queue-enabled = true;
      download-queue-size = 3;

      # When true, torrents that have not shared data for
      # queue-stalled-minutes are treated as 'stalled'
      # and are not counted against the queue-download-size
      # and seed-queue-size limits.
      queue-stalled-enabled = true;
      queue-stalled-minutes = 60;

      # When true. Transmission will only seed seed-queue-size
      # non-stalled torrents at once.
      seed-queue-enabled = false;
      seed-queue-size = 10;

      # Enable UPnP or NAT-PMP.
      peer-port = 51413;
      port-forwarding-enabled = false;
      # Start torrents as soon as they are added

      start-added-torrents = true;

      # notify me when download finished
      # script-torrent-done-enabled = true;
      # script-torrent-done-filename =
      #   (pkgs.writers.writeBash "torrent-finished" ''
      #     JSON_STRING=$( ${pkgs.jq}/bin/jq -n --arg torrent_name "$TR_TORRENT_NAME" \
      #       '{text: ":tada: finished : \($torrent_name)", channel: "torrent"}' )
      #     ${pkgs.curl}/bin/curl \
      #       --include \
      #       --request POST \
      #       --data-urlencode \
      #       "payload=$JSON_STRING" \
      #       ${lib.fileContents <common_secrets/mattermost_sink_url>}
      #   '');
    };
  };
}
