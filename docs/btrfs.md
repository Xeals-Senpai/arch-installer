# Btrfs Layout
This installer uses Btrfs as the primary filesystem to provide:

- Transparent compression (zstd)
- Snapper snapshots
- Efficient storage usage
- Simple rollback capability

## Disk Layout

| Partition | Filesystem | Size | Mount Point |
| --- |--- | ---: | --- |
| EFI System Partition | FAT32 | 1 GiB | /efi |
| Linux root partition | Btrfs | Remaining space | / |

## EFI

Mounted at:
```text
/efi
```

## Btrfs Subvolumes

| Subvolume | Mount Point | Purpose |
| ---| --- | --- |
| @ | / | Root filesystem |
| @home | /home | User files |
| @snapshots | /.snapshots | Snapper snapshots |
| @cache | /var/cache | Package/cache data |
| @log | /var/log | System logs |

## Mount Options

```text
compress=zstd,noatime
```

- compress=zstd: Transparent filesystem compression
- noatime: Prevents updating file access timestamps

## Snapshots

Snapper snapshots are stored in:

```text
/.snapshots
```
