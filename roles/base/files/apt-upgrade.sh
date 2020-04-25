#!/bin/bash

set -e

require() {
	echo -n "Searching for $1..."
	if command -v $1 > /dev/null; then
		echo "Found!"
	else
		echo "Not found! Please install '$1'."
		exit 1
	fi
}

require apt

echo "***APT UPDATE***"
sudo apt update
echo "***APT UPGRADE***"
sudo apt full-upgrade
echo "***APT AUTOREMOVE***"
sudo apt autoremove

echo -e "\n\nDone!"

