#!/usr/bin/env bash

generate_fstab() {
    echo "Generating fstab..."

    genfstab -U /mnt > /mnt/etc/fstab
}

show_fstab() {
    echo
    echo "=== Generated fstab ==="
    echo

    cat /mnt/etc/fstab
}

run_fstab_setup() {
    generate_fstab
    show_fstab
}