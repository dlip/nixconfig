# nixconfig

My dotfiles managed in Nix [home-manager](https://github.com/nix-community/home-manager)

## Setup

### Install Nix

https://nixos.org/guides/install-nix.html

### Enable flakes

``` sh
nix-env -iA nixpkgs.nixUnstable
mkdir -p ~/.config/nix
echo "experimental-features = nix-command flakes" >> ~/.config/nix/nix.conf
```

### Either clone and run locally

``` sh
git clone https://github.com/dlip/nixconfig.git
cd nixconfig
nix run .#homeConfigurations.personal
```

``` sh
sudo nixos-rebuild switch --flake '.#'
```

### Or run directly

``` sh
nix run github:dlip/nixconfig#homeConfigurations.personal
```

### Set zsh as default shell

``` sh
echo "$(which zsh)" | sudo tee -a /etc/shells
chsh -s $(which zsh)
```

