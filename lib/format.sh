#!/usr/bin/env bash

get_partition_suffix() {
    if [[ "$DISK" =~ (nvme|mmcblk) ]]; then
        echo "p"
    else
        echo ""
    fi
}

set_partition_variables() {
    local suffix

    suffix="$(get_partition_suffix)"

    EFI_PARTITION="${DISK}${suffix}1"
    BTRFS_PARTITION="${DISK}${suffix}2"

    export EFI_PARTITION
    export BTRFS_PARTITION
}

confirm_formatting() {
    echo
    echo "=== FINAL WARNING ==="
    echo
    echo "This will destroy all data on:"
    echo "  $DISK"
    echo
    echo "Partitions to be created:"
    echo "  $EFI_PARTITION    EFI System    $EFI_SIZE"
    echo "  $BTRFS_PARTITION  Btrfs         Remaining space"
    echo
    read -rp "Type DESTROY to continue: " CONFIRM

    [[ "$CONFIRM" == "DESTROY" ]] || {
        echo "Aborted."
        exit 1
    }
}

partition_disk() {
    echo "Partitioning $DISK..."

    parted --script "$DISK" mklabel "$PARTITION_TABLE"
    parted --script "$DISK" mkpart ESP fat32 1MiB "$EFI_SIZE"
    parted --script "$DISK" set 1 esp on
    parted --script "$DISK" mkpart primary btrfs "$BTRFS_START" "$BTRFS_END"

    partprobe "$DISK"
    udevadm settle
}

format_partitions() {
    echo "Formatting EFI partition..."
    mkfs.fat -F32 "$EFI_PARTITION"

    echo "Formatting Btrfs partition..."
    mkfs.btrfs -f "$BTRFS_PARTITION"
}

run_format_setup() {
    set_partition_variables
    confirm_formatting
    partition_disk
    format_partitions
}