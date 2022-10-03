{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
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
    # nvimpager # Build hanging
    p7zip
    ripgrep
    ripgrep-all
    speedread
    sqlite
    sshfs
    openssh
    stack
    tcpdump
    unzip
    wget
    wireguard-tools
    zip
  ] ++ (builtins.attrValues scripts.scripts);
}
