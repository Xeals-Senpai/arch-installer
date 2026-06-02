#!/usr/bin/env bash

AUR_PACKAGES=(
    nemo-terminal
    autotiling
    swappy
)

create_aur_script() {
    cat > /mnt/root/aur-setup.sh <<EOF
#!/usr/bin/env bash
set -euo pipefail

AUR_PACKAGES=(
$(printf '    %q\n' "${AUR_PACKAGES[@]}")
)

echo "Installing yay build dependencies..."
pacman -S --needed --noconfirm git base-devel go

echo "Preparing temporary sudo access for AUR installation..."
cat > /etc/sudoers.d/99-aur-install <<SUDOERS
$USERNAME ALL=(ALL) NOPASSWD: /usr/bin/pacman
SUDOERS

chmod 440 /etc/sudoers.d/99-aur-install

echo "Installing yay..."
install -d -o "$USERNAME" -g "$USERNAME" /home/"$USERNAME"/.cache/aur-build

sudo -u "$USERNAME" git clone https://aur.archlinux.org/yay.git /home/"$USERNAME"/.cache/aur-build/yay
cd /home/"$USERNAME"/.cache/aur-build/yay

sudo -u "$USERNAME" makepkg --noconfirm

pacman -U --noconfirm ./yay-*.pkg.tar.zst

echo "Installing AUR packages..."
sudo -u "$USERNAME" yay -S --needed --noconfirm "\${AUR_PACKAGES[@]}"

echo "Removing temporary AUR sudo access..."
rm -f /etc/sudoers.d/99-aur-install

echo "AUR setup complete."
EOF

    chmod +x /mnt/root/aur-setup.sh
}

run_aur_script() {
    arch-chroot /mnt /root/aur-setup.sh
}

run_aur_setup() {
    create_aur_script
    run_aur_script
}