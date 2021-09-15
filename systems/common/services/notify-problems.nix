{ config, lib, pkgs, modulesPath, ... }:
with lib;
let
  cfg = config.my.services.notify-problems;
in
{
  options.my.services.notify-problems = {
    adminEmail = mkOption {
      type = types.str;
      default = "dane@lipscombe.com.au";
      example = "user@example.com";
      description = ''
        Admin email address
      '';
    };
  };

  config = {
    systemd.services."notify-problems@" = {
      enable = true;
      description = "Alert email for %i to user";
      serviceConfig = {
        Type = "oneshot";
        User = "nobody";
        Group = "systemd-journal";
      };

      environment.SERVICE = "%i";
      script = ''
        ${pkgs.ssmtp}/bin/sendmail -t <<ERRMAIL
        To: ${cfg.adminEmail}
        From: ${cfg.adminEmail}
        Subject: $HOSTNAME: $SERVICE Error
        Content-Transfer-Encoding: 8bit
        Content-Type: text/plain; charset=UTF-8

        $(systemctl status --full "$SERVICE")
        ERRMAIL
      '';
    };
  };
}
