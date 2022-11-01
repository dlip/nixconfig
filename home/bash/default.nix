{ config, pkgs, lib, ... }:
{
  programs.bash = {
    enable = true;
    bashrcExtra = ''
      export GOPATH=$HOME/go
      export PATH=$HOME/code/nixconfig/scripts:$HOME/.local/bin:$GOPATH/bin:$HOME/.cargo/bin:$PATH
    '';
  };
}
