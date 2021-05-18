{ config, pkgs, ... }:
let downloader-services = import ./services.nix;
in
{
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
  services.transmission = {
    enable = true;
    settings = {
      download-dir = "/f/downloads/transmission";
      incomplete-dir = "/f/downloads/transmission/incomplete";
      incomplete-dir-enabled = true;
      message-level = 1;
      umask = "002";
      user = "root";
      group = "root";
      rpc-bind-address = "0.0.0.0";
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
      # Start torrents as soon as they are added.
      start-added-torrents = true;

      # Stop seeding after being idle for N minutes.
      idle-seeding-limit = 10;
      idle-seeding-limit-enabled = true;
      ratio-limit = 2.0;
      ratio-limit-enabled = true;

      # notify me when download finished
      script-torrent-done-enabled = true;
      script-torrent-done-filename =
        (pkgs.writers.writeBash "torrent-finished" ''
          echo -e "Subject: Torrent Completed: $TR_TORRENT_NAME\n\n$TR_TORRENT_NAME" | ${pkgs.ssmtp} -v dane@lipscombe.com.au
        '');
    };
  };
}
