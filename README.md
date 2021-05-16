# nixconfig

My dotfiles managed in Nix [home-manager](https://github.com/nix-community/home-manager)

## Setup

### Install Nix

https://nixos.org/guides/install-nix.html

### Enable flakes

https://nixos.wiki/wiki/Flakes

### Clone repo

```sh
git clone https://github.com/dlip/nixconfig.git
cd nixconfig
```

### Run home configuration

```sh
nix run .#homeConfigurations.x86_64-linux.personal
```

### Set zsh as default shell

```sh
echo "$(which zsh)" | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

### Run NixOS configuration

```sh
sudo nixos-rebuild switch --flake '.#'
```

### Run REPL

```sh
nix run .#repl.x86_64-linux
```
