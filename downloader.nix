{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ traceroute ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        8989 # sonarr
        7878 # radarr
        9091 # transmission
      ];
    };
  };

  services.sonarr = { enable = true; };
  services.radarr = { enable = true; };
  services.bazarr = { enable = true; };
  services.transmission = {
    enable = true;
    settings = {
      rpc-bind-address = "0.0.0.0";
      rpc-whitelist = "127.0.0.1,10.0.0.*";
    };
  };
}
