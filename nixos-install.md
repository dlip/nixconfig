# NixOS Install

```sh
sudo -s
fdisk -l
export D=/dev/nvme0n1

# partition disk
gdisk $D
# create new partition table
o
# create efi partition
n
<enter>
<enter>
+512M
ef00
# create root partition
n
<enter>
<enter>
<enter>
<enter>
# wp write
w

export P1=${D}p1
export P2=${D}p2

mkfs.fat $P1
fatlabel $P1 BOOT

# format the disk with the luks structure
cryptsetup luksFormat $P2
# open the encrypted partition and map it to /dev/mapper/cryptroot
cryptsetup luksOpen $P2 cryptroot
# format encrypted partition
mkfs.ext4 /dev/mapper/cryptroot -L ROOT
# mount
mount /dev/disk/by-label/ROOT /mnt
mkdir /mnt/boot
mount /dev/disk/by-label/BOOT /mnt/boot

# create swap file
fallocate -l 8G /mnt/.swapfile
chmod 600 /mnt/.swapfile
mkswap /mnt/.swapfile

nixos-generate-config --root /mnt

mkdir /mnt/root
git clone https://github.com/dlip/nixconfig.git
cd nixconfig

nix-shell -p nixUnstable --run "nix build .#nixosConfigurations.$(hostname).config.system.build.toplevel"
nixos-install --system result

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



