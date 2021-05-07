{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [ traceroute ];

  networking = {
    firewall = {
      enable = true;
      allowedTCPPorts = [
        8989 # sonarr
        7878 # radarr
      ];
    };
  };

  services.sonarr = { enable = true; };
  services.radarr = { enable = true; };
  services.bazarr = { enable = true; };
}
