


scpid(){
    FILE=dane@lipscombe.com.au.pub
    scp ~/code/nixconfig/keys/users/${FILE} ${1}:
ssh -t ${1} << EOF
cat ${FILE} >> .ssh/authorized_keys
rm -f ${FILE}
EOF
}

nixconfig(){
    export HOME_MANAGER_BACKUP_EXT=backup-$(date +"%Y%m%d")
    pushd ~/code/nixconfig > /dev/null
    nix run .#homeConfigurations.$NIXCONFIG
    popd > /dev/null
}

nixosconfig(){
    pushd ~/code/nixconfig > /dev/null
    sudo nixos-rebuild switch --flake .
    popd > /dev/null
}

nixosconfigboot(){
    pushd ~/code/nixconfig > /dev/null
    sudo nixos-rebuild boot --flake .
    popd > /dev/null
}

reset-k3s(){
    sudo systemctl stop k3s
    sudo rm -rf /etc/rancher
    sudo rm -rf /var/lib/rancher
    sudo systemctl start k3s
    sudo cat /etc/rancher/k3s/k3s.yaml > ~/.kube/k3s.yaml
    export KUBECONFIG=~/.kube/k3s.yaml
}

vterm_printf(){
    if [ -n "$TMUX" ] && ([ "${TERM%%-*}" = "tmux" ] || [ "${TERM%%-*}" = "screen" ] ); then
        # Tell tmux to pass the escape sequences through
        printf "\ePtmux;\e\e]%s\007\e\\" "$1"
    elif [ "${TERM%%-*}" = "screen" ]; then
        # GNU screen (screen, screen-256color, screen-256color-bce)
        printf "\eP\e]%s\007\e\\" "$1"
    else
        printf "\e]%s\e\\" "$1"
    fi
}

easyocr(){
    nvidia-docker run -it --rm -v $HOME/.EasyOCR:/root/.EasyOCR -v $PWD:/workspace challisa/easyocr easyocr -l en --detail 0 --gpu true -f "$1"
}
