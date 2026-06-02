#!/usr/bin/env bash

get_root_uuid() {
    ROOT_UUID="$(blkid -s UUID -o value "$BTRFS_PARTITION")"

    if [[ -z "$ROOT_UUID" ]]; then
        echo "ERROR: Could not determine root partition UUID."
        exit 1
    fi

    export ROOT_UUID
}

verify_efi_mount() {
    if ! mountpoint -q /mnt/efi; then
        echo "ERROR: /mnt/efi is not mounted."
        exit 1
    fi
}

create_bootloader_script() {
    cat > /mnt/root/bootloader-setup.sh <<EOF
#!/usr/bin/env bash
set -euo pipefail

echo "Installing systemd-boot..."
bootctl --esp-path=/efi install

echo "Creating kernel command line..."
mkdir -p /etc/kernel

cat > /etc/kernel/cmdline <<CMDLINE
root=UUID=$ROOT_UUID rootflags=subvol=@ rw
CMDLINE

echo "Creating loader configuration..."
mkdir -p /efi/loader

cat > /efi/loader/loader.conf <<LOADER
timeout 3
console-mode max
editor no
LOADER

echo "Configuring mkinitcpio UKI preset..."
cat > /etc/mkinitcpio.d/linux.preset <<PRESET
ALL_config="/etc/mkinitcpio.conf"
ALL_kver="/boot/vmlinuz-linux"
ALL_microcode=(/boot/intel-ucode.img)

PRESETS=('default' 'fallback')

default_uki="/efi/EFI/Linux/arch-linux.efi"
default_options="-S autodetect"

fallback_uki="/efi/EFI/Linux/arch-linux-fallback.efi"
fallback_options=""
PRESET

echo "Generating UKIs..."
mkdir -p /efi/EFI/Linux
mkinitcpio -P

echo "Verifying UKI output..."
test -f /efi/EFI/Linux/arch-linux.efi
test -f /efi/EFI/Linux/arch-linux-fallback.efi

echo "Bootloader configuration complete."
EOF

    chmod +x /mnt/root/bootloader-setup.sh
}

run_bootloader_script() {
    arch-chroot /mnt /root/bootloader-setup.sh
}

run_bootloader_setup() {
    verify_efi_mount
    get_root_uuid
    create_bootloader_script
    run_bootloader_script
}