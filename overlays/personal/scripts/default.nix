{ config, writeShellScriptBin, betterlockscreen }:
let
  home = "/home/dane";
  codepath = "${home}/code";
  nixconfigpath = "${codepath}/nixconfig";
  projectfile = "${codepath}/projects.txt";

  scripts = {
    launch-default-programs = ''
      brave&
      kitty --class Work work&
      kitty --class Notes notes&
      slack&
      plexamp&
    '';

    work = ''
      session="work"
      tmux new-session -d -s $session
      tmux send-keys -t $session 'p nixconfig' C-m
      tmux wait project_opened
      tmux attach -t $session
      zsh
    '';

    notes = ''
      session="notes"
      tmux new-session -d -s $session
      tmux send-keys -t $session 'cd ~/notes/personal && nvim index.md' C-m
      sleep 1
      tmux new-window -t $session:1
      tmux send-keys -t $session 'cd ~/notes/immutable && nvim index.md' C-m
      tmux attach -t $session
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
          cd ${home}/$repo_path
          tmux split-window -p 20
          tmux wait -S project_opened
          tmux select-pane -U
          nvim
      fi
    '';
    # Project add current dir

    pa = ''
      pwd | sed "s|${home}/||" >> ${projectfile}
    '';

    # Project add git folders
    pag = ''
      find ~+ -maxdepth 4 -name .git -prune | sed 's|/.git$||' | sed "s|${home}/||" >> ${projectfile}
    '';

    # Git new feature
    gn = ''
      if [ -z "''${1:-}" ]; then
        echo "Error: gn <branch>"
        exit 1
      fi
      branch=$1
      remote=origin
      main=$(git remote show origin | grep 'HEAD branch' | cut -d' ' -f5)
      git fetch $remote $main
      git checkout $remote/$main
      git checkout -b $branch
      git push -u $remote $branch
    '';
  };
in
{
  scripts = builtins.mapAttrs
    (name: val: writeShellScriptBin name ''
      set -euo pipefail
      ${val}'')
    scripts;
}
