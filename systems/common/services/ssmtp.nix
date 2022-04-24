{ config, lib, pkgs, modulesPath, ... }:
with lib;
let
  cfg = config.my.services.ssmtp;
in
{
  options.my.services.ssmtp = {
    adminEmail = mkOption {
      type = types.str;
      default = "danelipscombe@gmail.com";
      example = "user@example.com";
      description = ''
        Admin email address
      '';
    };
  };

  config = {
    sops.secrets.ssmtpPassword = {
      sopsFile = ../secrets/secrets.yaml;
    };
    # services.ssmtp = {
    #   enable = true;
    #   # The user that gets all the mails (UID < 1000, usually the admin)
    #   root = cfg.adminEmail;
    #   useTLS = true;
    #   useSTARTTLS = true;
    #   hostName = "smtp.gmail.com:587";
    #   # The address where the mail appears to come from for user authentication.
    #   domain = "gmail.com";
    #   # Username/Password File
    #   authUser = cfg.adminEmail;
    #   authPassFile = config.sops.secrets.ssmtpPassword.path;
    # };
  };

}
