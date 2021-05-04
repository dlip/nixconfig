{ config, lib, pkgs, ... }:

{
  boot.isContainer = true;

  nixpkgs.config.allowUnfree = true;
  # Let 'nixos-version --json' know about the Git revision
  # of this flake.
  #system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

  # Network configuration.
  networking.useDHCP = false;
  networking.firewall.allowedTCPPorts = [
    22 # ssh
    8989 # sonarr
    7878 # radarr
  ];

  services.openssh.enable = true;
  services.plex = {
    enable = true;
    openFirewall = true;
  };
  services.sonarr = { enable = true; };
  services.radarr = { enable = true; };
  services.bazarr = { enable = true; };
  #services.qbittorrent = { enable = true; };
}
