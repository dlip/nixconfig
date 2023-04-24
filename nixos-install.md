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
cd /mnt/root
git clone https://github.com/dlip/nixconfig.git
cd nixconfig

export HOST=metabox
mkdir systems/$HOST
cp /mnt/etc/nixos/* systems/$HOST
vim systems/$HOST/hardware-configuration.nix
```

Add

```
swapDevices = [{ device = "/.swapfile"; }];
```

```
vim systems/$HOST/configuration.nix

```

```nix
  networking.hostName = "HOSTNAME";
  # Enable wifi
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
vim flake.nix
```

Copy an existing nixosConfigurations, replace HOST with name above and remove sops import

Install system

```
git add .
nixos-install --flake .#$HOST
reboot
```

Setup SOPS

If not using sshd generate keyfile

```sh
sudo ssh-keygen -t ed25519 -f /etc/ssh/ssh_host_ed25519_key -N ""
mkdir -p ~/.config/sops/age
sudo ssh-to-age -private-key -i /etc/ssh/ssh_host_ed25519_key | tee -a ~/.config/sops/age/keys.txt | age-keygen -y
```


On an existing machine, add public key to .sops.yaml and update keys in the common secrets

```sh
sops updatekeys systems/common/secrets/secrets.yaml
```

Create secrets

```sh
mkdir systems/<HOSTNAME>/secrets
touch systems/<HOSTNAME>/secrets/secrets.yaml
sops systems/<HOSTNAME>/secrets/secrets.yaml
```

Generate wireguard key

```
wg genkey | tee /dev/tty | wg pubkey
```

Add the first line as `wireguard-key` in hosts secret file and add the second line to the peers in `systems/dex/configuration.nix`
