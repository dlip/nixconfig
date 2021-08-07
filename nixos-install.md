# NixOS Install Steps

```sh
# format the disk with the luks structure
cryptsetup luksFormat /dev/sda4
# open the encrypted partition and map it to /dev/mapper/cryptroot
cryptsetup luksOpen /dev/sda4 cryptroot
# mount
mount /dev/disk/by-label/nixos /mnt
mkdir /mnt/boot
mount /dev/sda1 /mnt/boot

parted /dev/sda -- mklabel gpt

```

```nix
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };

	networking.networkmanager.enable = true;

	users.users.dane = {
     isNormalUser = true;
     extraGroups = [ "wheel" ]; # Enable ‘sudo’ for the user.
   };

  environment.systemPackages = with pkgs; [
     vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
     wget
     firefox
     git
  ];
```

```
fallocate -l 8G /.swapfile
chmod 600 /.swapfile
mkswap /.swapfile
```

