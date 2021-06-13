#!/bin/bash

require() {
	echo -n "Searching for $1..."
	if command -v $1 > /dev/null; then
		echo "Found!"
	else
		echo "Not found! Please install '$1'."
		exit 1
	fi
}

if command -v mhwd-kernel > /dev/null; then
	echo "This is Manjaro"
	DISTRO="MANJARO"
else
	echo "This is vanilla Arch"
	DISTRO="ARCH"
fi

require pikaur
require pacdiff
require pacman-key

if [[ "${DISTRO}" == "MANJARO" ]]; then
	require pacman-mirrors
	require mhwd-kernel
else
	require rankmirrors
fi

sudo pacman-key --refresh-keys
pikaur -Syu

if [[ "${DISTRO}" == "MANJARO" ]]; then
	sudo pacman-mirrors -g
else
	sudo cp --verbose /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
	curl -s 'https://archlinux.org/mirrorlist/?country=CA&country=US&protocol=https&use_mirror_status=on' | \
		sed 's/#Server/Server/' | \
		rankmirrors -n 10 - | \
		sed '/^#.*/d' | \
		sudo tee /etc/pacman.d/mirrorlist
fi

sudo pacdiff
sudo pikaur -Rns $(pikaur -Qtdq)

if [[ "${DISTRO}" == "MANJARO" ]]; then
	echo "Check for new kernels!"
	mhwd-kernel -li
	mhwd-kernel -l
fi

