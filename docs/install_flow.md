# Arch Installer V2 Flow

1. Run environment checks
   - Root
   - Arch Linux
   - UEFI
   - Internet

2. Select target disk
   - Show available disks
   - Validate selection
   - Confirm selection

3. Partition disk
   - GPT
   - EFI (1 GiB)
   - Btrfs (remaining space)

4. Format partitions
   - FAT32 EFI
   - Btrfs root

5. Create Btrfs subvolumes
   - @
   - @home
   - @snapshots
   - @cache
   - @log

6. Mount filesystems

7. Pacstrap base system

8. Generate fstab

9. Chroot configuration
   - Locale
   - Timezone
   - Hostname
   - User
   - Sudo
   - NetworkManager

10. Bootloader
    - systemd-boot
    - UKI

11. Desktop
    - Sway or Hyprland
    - Waybar
    - Foot

12. Snapper

13. GNOME Keyring

14. Final verification

15. Reboot