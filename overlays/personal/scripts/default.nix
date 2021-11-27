{ config, writeShellScriptBin, betterlockscreen }:
let

  projectdir = "~/code";
  nixconfigpath = "${projectdir}/nixconfig";
  projectfile = "${projectdir}/projects.txt";

  scripts = {
    launch-default-programs = ''
      brave&
      alacritty&
      slack&
      obsidian&
    '';

    update-wallpaper = ''
      nice -19 ${betterlockscreen}/bin/betterlockscreen -u ~/wallpapers --fx dim --dim 20
      ${betterlockscreen}/bin/betterlockscreen -w dim
    '';

    lock-screen = ''
      ${betterlockscreen}/bin/betterlockscreen -l dim
    '';

    nixconfig = ''
      export HOME_MANAGER_BACKUP_EXT=$(date +"%Y%m%d%H%M%S").nixbackup
      nix run ${nixconfigpath}/#homeConfigurations.$NIXCONFIG "$@"
    '';

    nixosconfig = ''
      sudo nixos-rebuild switch --flake ${nixconfigpath} "$@"
    '';

    nixosconfigboot = ''
      sudo nixos-rebuild boot --flake ${nixconfigpath} "$@"
    '';

    reset-k3s = ''
      sudo systemctl stop k3s
      sudo rm -rf /etc/rancher
      sudo rm -rf /var/lib/rancher
      sudo systemctl start k3s
      sudo cat /etc/rancher/k3s/k3s.yaml > ~/.kube/k3s.yaml
      export KUBECONFIG=~/.kube/k3s.yaml
    '';

    easyocr = ''
      nvidia-docker run -it --rm -v $HOME/.EasyOCR:/root/.EasyOCR -v $PWD:/workspace challisa/easyocr easyocr -l en --detail 0 --gpu true -f "$1"
    '';

    jsontoyaml = ''
      xclip -o -selection clipboard | sed 's/\t//g' | yq -y | xclip -sel c
    '';

    # Open project
    p = ''
      filter_params=""
      if [ -n "''${1:-}" ]; then
          filter_params="-q $1"
      fi
      repo_path=$(cat ${projectfile} | fzf $filter_params --select-1)
      if [ -n "$repo_path" ]; then
          cd ${projectdir}/$repo_path
          tmux split-window -p 20
          tmux select-pane -U
          nvim
      fi
    '';

    # Project add current dir
    pa = ''
      pwd | sed "s|${projectdir}/||" >> ${projectfile}
    '';

    # Project add git folders
    pag = ''
      find ~+ -maxdepth 4 -name .git -prune | sed 's|/.git$||' | sed "s|${projectdir}/||" >> ${projectfile}
    '';
  };
in
{
  scripts = builtins.mapAttrs (name: val: writeShellScriptBin name ''
    set -euo pipefail
    ${val}
  '') scripts;
}
