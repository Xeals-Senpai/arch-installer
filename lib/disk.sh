#!/usr/bin/env bash

show_disks() {
    lsblk -d -o PATH,SIZE,MODEL
}

select_disk() {
    read -rp "Target disk (e.g. nvme0n1): " DISK
    DISK="/dev/$DISK"

    [[ -b "$DISK" ]] || {
        echo "ERROR: Invalid disk."
        exit 1
    }
}

confirm_disk() {
    echo
    echo "Selected disk: $DISK"
    echo
    
    read -rp "Type YES to destroy all data on this disk: " CONFIRM

    [[ "$CONFIRM" == "YES" ]] || {
        echo "Aborted."
        exit 1
    }
}

run_disk_selection() {
    show_disks
    select_disk
    confirm_disk
}