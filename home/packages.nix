{pkgs, ...}: {
  home.packages = with pkgs; [
    cargo
    bat
    bc
    delta
    dig
    direnv
    entr
    # envy-sh
    fd
    findutils
    fzf
    gcc
    gh
    gnugrep
    gnumake
    gotop
    htop
    jq
    killall
    lsd
    ncdu
    neofetch
    nettools
    nmap
    p7zip
    ripgrep
    # ripgrep-all
    gnused
    iputils
    openssh
    speedread
    sops
    sqlite
    sshfs
    stack
    tcpdump
    tree
    unzip
    util-linux
    wget
    wireguard-tools
    zip
    zoxide
  ];
}
