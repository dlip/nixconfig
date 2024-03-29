{pkgs, ...}: {
  home.packages = with pkgs; [
    bat
    bc
    curl
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
    iconv
    jq
    killall
    lsd
    ncdu
    ncurses
    neofetch
    nettools
    nmap
    p7zip
    ripgrep
    # ripgrep-all
    gnused
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
