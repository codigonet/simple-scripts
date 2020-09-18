umount /dev/sda1
parted -s /dev/sda mklabel msdos
parted -s /dev/sda mkpart primary 1MiB 551MiB
parted -s /dev/sda set 1 esp on
parted -s /dev/sda set 1 boot on
mkfs.fat -F32 /dev/sda1
parted -s /dev/sda mkpart primary 551MiB 100%
mkfs.ext4 /dev/sda2
mkdir /media/{efi,data}
mount /dev/sda1 /media/efi
mount /dev/sda2 /media/data

grub-install \
--target=i386-pc \
--recheck \
--boot-directory="/media/data/boot" /dev/sda

grub-install \
--target=x86_64-efi \
--recheck \
--removable \
--efi-directory="/media/efi" \
--boot-directory="/media/data/boot"

mkdir /media/data/boot/iso

chown cas:cas /media/data/boot/iso

wget -O /media/data/boot/grub/grub.cfg \
pendrivelinux.com/downloads/multibootlinux/grub.cfg

gedit /media/data/boot/grub/grub.cfg

