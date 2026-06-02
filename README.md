# Arch Installer V2

A minimal, opinionated Arch Linux installer focused on simplicity, reproducibility, and modern defaults.

## Features

* GPT partitioning
* Btrfs root filesystem
* Pre-configured Btrfs subvolumes
* systemd-boot bootloader
* Unified Kernel Images (UKI)
* PipeWire audio stack
* NetworkManager networking
* Optional Sway or Hyprland installation
* Optional AUR integration
* UK timezone defaults (Europe/London)

## Installation

Boot into the official Arch Linux ISO and ensure you have a working internet connection.

Clone the repository:

```bash
git clone https://github.com/Xeals-Senpai/arch-installer-v2.git
cd arch-installer-v2
```

Make the scripts executable:

```bash
chmod +x install.sh lib/*.sh
```

Run the installer:

```bash
./install.sh
```

Follow the prompts to select the target disk and configure the installation.

## Project Structure

```text
arch-installer-v2/
├── docs/
├── lib/
└── install.sh
```

### Key Components

| File          | Purpose                                |
| ------------- | -------------------------------------- |
| install.sh    | Main installer workflow                |
| checks.sh     | Pre-installation checks                |
| disk.sh       | Disk selection                         |
| partition.sh  | Partition layout configuration         |
| format.sh     | Disk partitioning and formatting       |
| btrfs.sh      | Btrfs subvolume creation and mounting  |
| pacstrap.sh   | Base package installation              |
| fstab.sh      | Fstab generation                       |
| chroot.sh     | Post-installation system configuration |
| bootloader.sh | systemd-boot and UKI configuration     |
| aur.sh        | Optional AUR package installation      |

## Status

⚠️ Experimental

This project is currently under active development and should be considered a testing build until it has completed multiple successful installation runs.

## License

Released under the MIT License.
