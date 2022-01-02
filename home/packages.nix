{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
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
    nvimpager
    p7zip
    ripgrep
    ripgrep-all
    sqlite
    sshfs
    openssh
    stack
    tcpdump
    unzip
    wget
    wireguard
    zip
  ] ++ (builtins.attrValues scripts.scripts);
}
