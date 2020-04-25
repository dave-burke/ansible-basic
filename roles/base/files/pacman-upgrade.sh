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

require pikaur
require pacman-mirrors
require pacdiff
require mhwd-kernel

#sudo pacman-key --refresh-keys
pikaur -Syu
sudo pacman-mirrors -g
sudo pacdiff
sudo pikaur -Rns $(pikaur -Qtdq)

echo "Check for new kernels!"

mhwd-kernel -li
mhwd-kernel -l

