#!/bin/bash

#sudo pacman-key --refresh-keys
trizen -Syu
sudo pacman-mirrors -g
sudo pacdiff
sudo trizen -Rns $(trizen -Qtdq)

echo "Check for new kernels!"

mhwd-kernel -li
mhwd-kernel -l

