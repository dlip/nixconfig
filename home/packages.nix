{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    dig
    direnv
    envy-sh
    exa
    fd
    fzf
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
    sshfs
    stack
    tcpdump
    unzip
    wget
    zip
  ] ++ (if !pkgs.stdenv.hostPlatform.isAarch64 then [
    delve
  ] else [ ]) ++ (builtins.attrValues scripts.scripts);
}
