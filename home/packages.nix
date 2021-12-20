{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    dig
    direnv
    envy-sh
    exa
    fd
    fzf
    gcc
    gnumake
    gotop
    htop
    iotop
    jq
    killall
    ncdu
    neofetch
    nmap
    nvimpager
    p7zip
    ripgrep
    ripgrep-all
    sqlite
    sshfs
    stack
    tcpdump
    unzip
    wget
    zip
  ] ++ (builtins.attrValues scripts.scripts);
}
