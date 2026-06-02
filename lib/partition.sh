#!/usr/bin/env bash

PARTITION_TABLE="gpt"

EFI_SIZE="1GiB"

BTRFS_START="1GiB"
BTRFS_END="100%"

show_partition_plan() {
    echo
    echo "=== Partition Plan ==="
    echo

    echo "Disk:"
    echo "  $DISK"
    echo

    echo "Partition Table: $PARTITION_TABLE"
    echo

    echo "Partition 1:"
    echo "  Type: EFI System"
    echo "  Size: $EFI_SIZE"
    echo

    echo "Partition 2:"
    echo "  Type: BTRFS"
    echo "  Start: $BTRFS_START"
    echo "  End: $BTRFS_END"
    echo
}

run_partition_plan() {
    show_partition_plan
}