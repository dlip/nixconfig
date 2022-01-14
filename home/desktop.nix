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
      cargo
      cheat
      clang-tools
      delve
      deno
      dive
      docker-compose
      eksctl
      file
      fluxcd
      ghc
      ghostscript
      glow
      gnupg
      gnuplot
      go
      gobang
      graphviz
      helix
      hledger
      k9s
      kind
      kmonad
      kubectl
      kubernetes-helm
      kubetail
      ledger
      ledger-autosync
      lldb
      (lua.withPackages (ps: with ps; [ luacheck ]))
      massren
      mdl
      # myPythonPackages.shirah-reader
      myPythonPackages.adafruit-nrfutil
      niv
      nix-du
      nodePackages.node2nix
      nodePackages.quicktype
      nodePackages.reveal-md
      nodePackages.typescript
      nodejs
      openssl
      openvpn
      pandoc
      pinentry
      poetry
      postgresql
      python
      python3
      python39Packages.grip
      python39Packages.pip
      python39Packages.setuptools
      rclone
      renameutils
      rustc
      skopeo
      sops
      ssh-to-age
      tesseract4
      tldr
      tshark
      usbutils
      visidata
      xdotool
      yarn
      youtube-dl
      yq
      # yubikey-manager #broken
    ];
}
