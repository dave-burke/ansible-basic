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

