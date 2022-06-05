{ pkgs, lib, ... }: {
  home.packages = with pkgs;
    [
      acpi
      age
      air
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
      helix
      hledger
      k9s
      kind
      kmonad
      kubectl
      kubectx
      kubernetes-helm
      kubetail
      ledger
      ledger-autosync
      lldb
      (lua.withPackages (ps: with ps; [ luacheck ]))
      massren
      mdl
      # musikcube
      # myPythonPackages.shirah-reader
      # myPythonPackages.adafruit-nrfutil
      niv
      # nix-du broken
      nodePackages.node2nix
      nodePackages.quicktype
      nodePackages.reveal-md
      nodePackages.typescript
      nodejs
      notify
      openssl
      # openvpn
      openvpn_aws
      pandoc
      pinentry
      poetry
      postgresql
      python
      python3
      python39Packages.grip
      python39Packages.pip
      python39Packages.pynvim
      python39Packages.setuptools
      rclone
      renameutils
      rustc
      skopeo
      sops
      ssh-to-age
      teams
      tesseract4
      tldr
      wireshark-cli
      ttyper
      typespeed
      usbutils
      visidata
      xdotool
      yarn
      youtube-dl
      yq
      # yubikey-manager #broken
    ];
}
