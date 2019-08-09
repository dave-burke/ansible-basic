#!/bin/bash

#sudo pacman-key --refresh-keys
pikaur -Syu
sudo pacman-mirrors -g
sudo pacdiff
sudo pikaur -Rns $(pikaur -Qtdq)

echo "Check for new kernels!"

mhwd-kernel -li
mhwd-kernel -l

