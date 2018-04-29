# DynDNS update script

Simple DDNS update script. The script uses `dig` and `myip.opendns.com` to aquire the host's public IP and stores it in `/var/opt/dyndns-update_ip`. If the IP is different from the previous contents of that file, the script uses the `domain` and `token` values defined in `/etc/opt/dyndns-update.cfg` and `~/.dyndns-update.cfg` to update duckdns with `curl`.

