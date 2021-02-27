# RAID Storage

This is a role for setting up and actively monitoring a RAID storage pool.

It's specific to my setup, and made more for my own reference than to be
re-usable.

## Testing notifications

### MDADM

`mdadm --monitor --scan --oneshot --test`

### SMART

`smartd.conf` specifies `-M test` for the first drive in the array, so a test
email is sent whenever smartctl is started (whenever the system reboots).

## Sample RAID creation

(as root)
```
# Create a RAID6 array with 4 disks
mdadm --crate /dev/md/storage /dev/sda /dev/sdb /dev/sdc /dev/sdd --level=6 --raid-devices=4

# Create an ext4 filesystem on the array
mkfs.ext4 -F /dev/md/storage

# Mount the array
mkdir -p /mnt/storage
mount /dev/md/storage /mnt/storage

# Verify the array is mounted and available
df -h -x devtmpfs -x tmpfs

# Save the array layout so it gets reassembled on boot
mdadm --detail --scan | tee -a /etc/mdadm/mdadm.conf

# Ubuntu specific step to update initial RAM file system so the array will be available during the early boot process
update-initramfs -u

# Save the mount configuration to fstab so it gets mounted at boot
echo "/dev/md/storage /mnt/storage ext4 defaults 0 0" | tee -a /etc/fstab

# Watch the raid creation status if desired
watch -n 60 cat /proc/mdstat
```

## How to "activate" the array if it fails to start

```
mdadm --stop /dev/md[X]
mdadm --assemble --scan
```

## How to remove a bad drive

```
# Determine which drive failed
cat /proc/mdadm
# or:
mdadm --query --detail /dev/md[X]

# Determine the serial number of the failing drive (e.g. /dev/sdb)
lshw --class disk
# or:
smartctl --all /dev/sdb | grep -i Serial

# Remove the disk from the array
mdadm --manage /dev/md[X] --remove /dev/sdb
```

You can now remove the disk with the matching serial number.

## How to add a new drive

First, take a picture of the drive's sticker and use marker to write the number on it (the same number as the drive you replaced). This is a minor convenience for reference in case you do something silly like remove the drive and shut down the computer without checking the serial number.

Next, install the drive and boot the server.

```
# Determine the device file of the new drive
lshw --class disk

# Add the drive (e.g. /dev/sdb) to the array
mdadm --manage /dev/md[x] --add /dev/sdb

# Monitor recovery process
watch -n 1 cat /proc/mdstat
```

