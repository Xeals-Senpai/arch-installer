#!/usr/bin/env bash
set -euo pipefail
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/checks.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/disk.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/partition.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/prompts.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/format.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/btrfs.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/pacstrap.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/fstab.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/chroot.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/bootloader.sh"
# shellcheck disable=SC1091
source "$SCRIPT_DIR/lib/aur.sh"

run_checks
echo "All checks passed. Proceeding with installation..."

run_disk_selection
run_partition_plan
run_prompts
echo "Pre-installation steps completed. Ready to install Arch Linux"
run_format_setup
run_btrfs_setup
run_pacstrap_setup
run_fstab_setup
run_chroot_setup
run_bootloader_setup
#run_aur_setup
echo "Installation complete! You can now reboot into your new Arch Linux system."
