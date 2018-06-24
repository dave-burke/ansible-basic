#!/bin/bash

set -e

disableMeta(){
	if command -v gsettings >/dev/null; then
		if gsettings writable org.gnome.mutter overlay-key >/dev/null; then
			echo "Disabling gnome overlay-key"
			gsettings set org.gnome.mutter overlay-key ""
		else
			echo "org.gnome.mutter overlay-key is not a writable setting. Meta key will not be disabled."
		fi
	else
		echo "Could not find gsettings. Meta key will not be disabled."
	fi
}

enableMeta(){
	if command -v gsettings >/dev/null; then
		if gsettings writable org.gnome.mutter overlay-key >/dev/null; then
			echo "Enabling gnome overlay-key"
			gsettings set org.gnome.mutter overlay-key "Super_L"
		else
			echo "org.gnome.mutter overlay-key is not a writable setting. Meta key will not be enabled."
		fi
	else
		echo "Could not find gsettings. Meta key will not be enabled."
	fi
}

if [[ -z ${USER} ]]; then
	echo "Couldn't determine your username. The USER variable is not set."
	exit 1
fi
if [[ "${USER}" == "root" ]]; then
	echo "Don't run minecraft as root."
	exit 1
fi

echo "Launching Minecraft as ${USER}"
sed -i "s/\"displayName\": \"thoughtcriminal\"/\"displayName\": \"${USER}\"/" ~/.minecraft/launcher_profiles.json

disableMeta
java -jar /opt/minecraft/minecraft.jar
enableMeta
