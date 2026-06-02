#!/usr/bin/env bash

check_root(){
  if [[ "$EUID" -ne 0 ]]; then
    echo "ERROR: Run this script as root."
    exit 1
  fi
}

check_arch_iso(){
    [[ -f /etc/arch-release ]] || {
        echo "ERROR: This script is only for Arch Linux ISO."
        exit 1
    }
}

check_uefi(){
    [[ -d /sys/firmware/efi/efivars ]] || {
        echo "ERROR: This script requires UEFI boot mode."
        exit 1
    }
}

check_internet(){
    ping -c 1 archlinux.org > /dev/null 2>&1 || {
        echo "ERROR: No internet connection."
        exit 1
    }
}

run_checks(){
    check_root
    check_arch_iso
    check_uefi
    check_internet
}