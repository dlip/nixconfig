{ config, lib, pkgs, ... }:

{
  boot.isContainer = true;

  # Let 'nixos-version --json' know about the Git revision
  # of this flake.
  #system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;

  # Network configuration.
  networking.useDHCP = false;
  networking.firewall.allowedTCPPorts = [ 80 ];

  # Enable a web server.
  services.httpd = {
    enable = true;
    adminAddr = "morty@example.org";
  };
}
