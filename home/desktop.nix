{ pkgs, lib, ... }: {


  services.dropbox.enable = true;
  imports = [
    ./espanso
  ];

  home.packages = with pkgs;
    [
      acpi
      age
      air
      ansifilter
      appimage-run
      autoreconfHook
      avrdude
      aws-google-auth
      awscli2
      bat
      binutils
      docker-buildx
      cargo
      cheat
      clang-tools
      delve
      deno
      dive
      docker-compose
      eksctl
      evtest
      exiv2
      file
      fluxcd
      ghc
      ghostscript
      glow
      gnupg
      gnuplot
      go
      gobang
      gotypist
      graphviz
      hexdino
      helix
      hledger
      jdk11
      k9s
      kind
      kmonad
      krename
      kubectl
      kubectx
      kubernetes-helm
      kubetail
      ledger
      ledger-autosync
      lldb
      (lua.withPackages (ps: with ps; [ luacheck ]))
      mangal
      massren
      mdl
      # musikcube
      # myPythonPackages.shirah-reader
      # myPythonPackages.adafruit-nrfutil
      mysql80
      myNodePackages."@prisma/language-server"
      niv
      nix-du
      nodePackages.node2nix
      nodePackages.pnpm
      nodePackages.quicktype
      nodePackages.reveal-md
      nodePackages.typescript
      nodejs
      notify
      openssl
      openvpn
      # openvpn_aws
      pandoc
      pinentry
      # poetry
      postgresql
      python3
      # python39Packages.grip
      # python39Packages.pip
      # python39Packages.pynvim
      # python39Packages.setuptools
      rclone
      renameutils
      rustc
      stern
      skopeo
      sops
      ssh-to-age
      teams
      tesseract4
      tldr
      traceroute
      # turbo
      unrar
      wireshark-cli
      ttyper
      typespeed
      usbutils
      ventoy-bin
      visidata
      xdotool
      yarn
      yarn2nix
      youtube-dl
      yq
      # yubikey-manager #broken
      zgrviewer
    ];
}
