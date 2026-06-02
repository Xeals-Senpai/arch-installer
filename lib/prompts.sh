#!/usr/bin/env bash

TIMEZONE="Europe/London"

prompt_hostname() {
    read -rp "Hostname: " HOSTNAME
}

prompt_username() {
    read -rp "Username: " USERNAME
}

prompt_password() {
    read -rsp "Password: " USER_PASSWORD
    echo

    read -rsp "Confirm Password: " USER_PASSWORD_CONFIRM
    echo

    [[ "$USER_PASSWORD" == "$USER_PASSWORD_CONFIRM" ]] || {
        echo "ERROR: Passwords do not match."
        exit 1
    }
}

prompt_root_password() {
    read -rsp "Root password: " ROOT_PASSWORD
    echo

    read -rsp "Confirm root password: " ROOT_PASSWORD_CONFIRM
    echo

    [[ "$ROOT_PASSWORD" == "$ROOT_PASSWORD_CONFIRM" ]] || {
        echo "ERROR: Root passwords do not match."
        exit 1
    }
}

prompt_sudo() {
    read -rp "Allow this user to use sudo? (y/n): " ENABLE_SUDO
}

prompt_nopasswd() {
    read -rp "Enable passwordless sudo? (y/n): " ENABLE_NOPASSWD
}

validate_sudo_configuration() {
    if [[ "$ENABLE_SUDO" != "y" ]]; then
        ENABLE_NOPASSWD="n"
    fi
}

prompt_snapper() {
    read -rp "Enable Snapper automatic snapshots? (y/n): " ENABLE_SNAPPER
}

prompt_compositor() {
    echo
    echo "Select compositor:"
    echo "  1) Sway"
    echo "  2) Hyprland"
    echo

    read -rp "Choice [1]: " COMPOSITOR_CHOICE
    COMPOSITOR_CHOICE="${COMPOSITOR_CHOICE:-1}"

    case "$COMPOSITOR_CHOICE" in
        1)
            COMPOSITOR="Sway"
            ;;
        2)
            COMPOSITOR="Hyprland"
            ;;
        *)
            echo "ERROR: Invalid compositor choice."
            exit 1
            ;;
    esac
}

show_configuration_summary() {
    echo
    echo "=== Configuration Summary ==="
    echo

    echo "Hostname:         $HOSTNAME"
    echo "Username:         $USERNAME"
    echo "Timezone:         $TIMEZONE"
    echo "Sudo Enabled:     $ENABLE_SUDO"
    echo "NOPASSWD Enabled: $ENABLE_NOPASSWD"
    echo "Snapper Enabled:  $ENABLE_SNAPPER"
    echo "Compositor:       $COMPOSITOR"
    echo
}

confirm_configuration() {
    read -rp "Continue with these settings? (YES): " CONFIRM

    [[ "$CONFIRM" == "YES" ]] || {
        echo "Aborted."
        exit 1
    }
}

run_prompts() {
    prompt_hostname
    prompt_username
    prompt_password
    prompt_root_password
    prompt_sudo
    prompt_nopasswd
    validate_sudo_configuration
    prompt_snapper
    prompt_compositor
    show_configuration_summary
    confirm_configuration

    export HOSTNAME USERNAME USER_PASSWORD ROOT_PASSWORD ENABLE_SUDO ENABLE_NOPASSWD ENABLE_SNAPPER COMPOSITOR TIMEZONE
}