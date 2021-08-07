{ config, lib, pkgs, ... }:

{
  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableExtraSocket = true;
    extraConfig = ''
      pinentry-program ${pkgs.pinentry.qt}/bin/pinentry
    '';
    defaultCacheTtl = 34560000;
    defaultCacheTtlSsh = 34560000;
    maxCacheTtl = 34560000;
    maxCacheTtlSsh = 34560000;
  };
}
