{pkgs, ...}: {
  home.packages = with pkgs.unstable; [
    bat
    delta
    dig
    direnv
    envy-sh
    exa
    fd
    findutils
    fzf
    gcc
    gh
    gnugrep
    gnumake
    gotop
    htop
    iotop
    iputils
    jq
    killall
    ncdu
    neofetch
    nettools
    nmap
    p7zip
    ripgrep
    ripgrep-all
    gnused
    speedread
    sqlite
    sshfs
    openssh
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
