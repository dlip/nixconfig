{ pkgs, ... }: {
  home.packages = with pkgs; [
    (kodi.withPackages (p:
      with p; [
        #  (import ./pkgs/kodiPackages/vfs-rar p)
        vfs-libarchive
        vfs-sftp
      ]))
    spotify
  ];
}
