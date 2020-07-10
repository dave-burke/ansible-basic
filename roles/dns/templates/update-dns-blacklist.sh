#!/bin/bash

set -e

cd "{{dns_hosts_repo_dir}}"
python3 ./updateHostsFile.py --auto --nogendata --skipstatichosts

echo -n "Restarting dns..."
docker restart dns > /dev/null
echo "Done!"

