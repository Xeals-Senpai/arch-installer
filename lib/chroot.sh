#!/usr/bin/env bash

create_chroot_script() {
    cat > /mnt/root/chroot-setup.sh <<EOF
#!/usr/bin/env bash
set -euo pipefail

echo "Configuring timezone..."
ln -sf "/usr/share/zoneinfo/$TIMEZONE" /etc/localtime
hwclock --systohc

echo "Configuring locale..."
sed -i 's/^#en_GB.UTF-8 UTF-8/en_GB.UTF-8 UTF-8/' /etc/locale.gen
locale-gen
echo "LANG=en_GB.UTF-8" > /etc/locale.conf
echo "KEYMAP=uk" > /etc/vconsole.conf

echo "Configuring hostname..."
echo "$HOSTNAME" > /etc/hostname

cat > /etc/hosts <<HOSTS
127.0.0.1   localhost
::1         localhost
127.0.1.1   $HOSTNAME.localdomain $HOSTNAME
HOSTS

echo "Setting root password..."
echo "root:$ROOT_PASSWORD" | chpasswd

echo "Creating user..."
useradd -m -G wheel,audio,video,input -s /bin/zsh "$USERNAME"

echo "$USERNAME:$USER_PASSWORD" | chpasswd

echo "Configuring sudo..."
if [[ "$ENABLE_SUDO" == "y" ]]; then
    cat > /etc/sudoers.d/00-$USERNAME <<SUDOERS
$USERNAME ALL=(ALL) ALL
SUDOERS

    chmod 440 /etc/sudoers.d/00-$USERNAME
fi

if [[ "$ENABLE_NOPASSWD" == "y" ]]; then
    cat > /etc/sudoers.d/00-$USERNAME <<SUDOERS
$USERNAME ALL=(ALL) NOPASSWD: ALL
SUDOERS

    chmod 440 /etc/sudoers.d/00-$USERNAME
fi

echo "Enabling NetworkManager..."
systemctl enable NetworkManager

echo "Chroot configuration complete."
EOF

    chmod +x /mnt/root/chroot-setup.sh
}

run_chroot_script() {
    arch-chroot /mnt /root/chroot-setup.sh
}

run_chroot_setup() {
    create_chroot_script
    run_chroot_script
}