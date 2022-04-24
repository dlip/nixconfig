{ config, lib, pkgs, modulesPath, ... }:
{
  config.sops.secrets.notify = {
    sopsFile = ../secrets/secrets.yaml;
  };
  config.systemd.services."notify-problems@" = {
    enable = true;
    description = "Alert email for %i to user";
    serviceConfig = {
      Type = "oneshot";
      User = "root";
      Group = "systemd-journal";
    };

    environment.SERVICE = "%i";
    script = ''
      echo "
      $HOSTNAME: $SERVICE Error
      $(systemctl status --full "$SERVICE")
      " | ${pkgs.notify}/bin/notify -provider-config ${config.sops.secrets.notify.path}
    '';
  };
}
