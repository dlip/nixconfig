


scpid(){
    FILE=dane@lipscombe.com.au.pub
    scp ~/code/nixconfig/keys/users/${FILE} ${1}:
ssh -t ${1} << EOF
cat ${FILE} >> .ssh/authorized_keys
rm -f ${FILE}
EOF
}

nixconfig(){
    pushd ~/code/nixconfig > /dev/null
    nix run .#homeConfigurations.$NIXCONFIG
    popd > /dev/null
}

nixosconfig(){
    pushd ~/code/nixconfig > /dev/null
    sudo nixos-rebuild switch --flake '.#'
    popd > /dev/null
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
