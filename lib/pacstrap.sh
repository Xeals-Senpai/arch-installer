#!/usr/bin/env bash

BASE_PACKAGES=(
    base
    base-devel
    linux
    linux-firmware
    btrfs-progs
    sudo
    git
    zsh
    neovim
)

BOOT_PACKAGES=(
    systemd-ukify
    intel-ucode
    efibootmgr
)

NETWORK_PACKAGES=(
    networkmanager
    network-manager-applet
)

AUDIO_PACKAGES=(
    pipewire
    pipewire-pulse
    wireplumber
    pavucontrol
)

UTILITY_PACKAGES=(
    nemo
    file-roller
    unzip
    wget
    curl
    btop
    tmux
    kitty
    fastfetch
    gvfs
    udisks2
)

SWAY_PACKAGES=(
    sway
    swaylock
    swayidle
    waybar
    wofi
    grim
    slurp
    mako
)

HYPRLAND_PACKAGES=(
    hyprland
    waybar
    wofi
    grim
    slurp
    mako
)

SECURITY_PACKAGES=(
    gnome-keyring
    seahorse
    polkit-gnome
)

SNAPSHOT_PACKAGES=(
    snapper
    snap-pac
)

APPLICATION_PACKAGES=(
    firefox
    vlc
)

PORTAL_PACKAGES=(
    xdg-desktop-portal
    xdg-desktop-portal-gtk
)

build_package_list() {
    PACKAGES=(
        "${BASE_PACKAGES[@]}"
        "${BOOT_PACKAGES[@]}"
        "${NETWORK_PACKAGES[@]}"
        "${AUDIO_PACKAGES[@]}"
        "${UTILITY_PACKAGES[@]}"
        "${SECURITY_PACKAGES[@]}"
        "${SNAPSHOT_PACKAGES[@]}"
        "${APPLICATION_PACKAGES[@]}"
        "${PORTAL_PACKAGES[@]}"
    )

    case "$COMPOSITOR" in
        Sway)
            PACKAGES+=("${SWAY_PACKAGES[@]}")
            ;;
        Hyprland)
            PACKAGES+=("${HYPRLAND_PACKAGES[@]}")
            ;;
        *)
            echo "ERROR: Unknown compositor: $COMPOSITOR"
            exit 1
            ;;
    esac
}

run_pacstrap() {
    build_package_list

    echo "Installing base system..."
    pacstrap -K /mnt "${PACKAGES[@]}"
}

run_pacstrap_setup() {
    run_pacstrap
}