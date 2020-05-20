#!/bin/bash

set -e

cd "{{hosts_repo_dir}}"
python3 ./updateHostsFile.py --auto --nogendata --skipstatichosts

echo -n "Restarting dns..."
docker restart dns > /dev/null
echo "Done!"

