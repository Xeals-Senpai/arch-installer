#!/usr/bin/env bash
EFI_MOUNT_POINT="/mnt/efi"

create_btrfs_subvolumes() {
    echo "Creating Btrfs subvolumes..."
    mount "$BTRFS_PARTITION" /mnt
    btrfs subvolume create /mnt/@
    btrfs subvolume create /mnt/@home
    btrfs subvolume create /mnt/@snapshots
    btrfs subvolume create /mnt/@cache
    btrfs subvolume create /mnt/@log
    umount /mnt
}

BTRFS_MOUNT_OPTIONS="compress=zstd,noatime"
mount_btrfs_subvolumes() {
    echo "Mounting BTRFS subvolumes..."
    mount \
        -o "${BTRFS_MOUNT_OPTIONS},subvol=@" \
        "$BTRFS_PARTITION" \
        /mnt

    mkdir -p /mnt/home
    mkdir -p /mnt/.snapshots
    mkdir -p /mnt/var/cache
    mkdir -p /mnt/var/log
    mkdir -p "$EFI_MOUNT_POINT"
    
    mount \
        -o "${BTRFS_MOUNT_OPTIONS},subvol=@home" \
        "$BTRFS_PARTITION" \
        /mnt/home
    mount \
        -o "${BTRFS_MOUNT_OPTIONS},subvol=@snapshots" \
        "$BTRFS_PARTITION" \
        /mnt/.snapshots
    mount \
        -o "${BTRFS_MOUNT_OPTIONS},subvol=@cache" \
        "$BTRFS_PARTITION" \
        /mnt/var/cache
    mount \
        -o "${BTRFS_MOUNT_OPTIONS},subvol=@log" \
        "$BTRFS_PARTITION" \
        /mnt/var/log
    mount "$EFI_PARTITION" "$EFI_MOUNT_POINT"
}

run_btrfs_setup() {
    create_btrfs_subvolumes
    mount_btrfs_subvolumes
}