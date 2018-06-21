#!/bin/bash

set -e

if [[ -z ${USER} ]]; then
	echo "Couldn't determine your username. The USER variable is not set."
	exit 1
fi
if [[ "${USER}" == "root" ]]; then
	echo "Don't run minecraft as root."
	exit 1
fi

echo "Launching Minecraft as ${USER}"
sed -i "s/\"displayName\": \"thoughtcriminal\"/\"displayName\": \"${USER}\"/" .minecraft/launcher_profiles.json

# Disable super key if gsettings is present
if command -v gsettings >/dev/null; then
	gsettings set org.gnome.mutter overlay-key ""
fi

java -jar /opt/minecraft/minecraft.jar

# Re-enable super key
if command -v gsettings >/dev/null; then
	gsettings set org.gnome.mutter overlay-key "Super_L"
fi
