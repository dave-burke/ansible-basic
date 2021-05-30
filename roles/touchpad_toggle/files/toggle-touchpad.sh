#!/bin/bash

set -e

# View these logs via 'journalctl [-f] -t mouse-touchpad'
function log {
	echo "${@}" | systemd-cat -t mouse-touchpad
}

function isMousePluggedIn {
	# Just check if the xinput device list includes anything with 'usb mouse'
	# in the name. This is a bit crude, and may not work for all mice, but it
	# works for ours.
	xinput list | grep -i "usb mouse" > /dev/null
}

# When this dconf key is true, the touchpad is enabled
# This only works in Mate. Gnome has a different key.
KEY="org.mate.peripherals-touchpad touchpad-enabled"

NEW_VALUE=$1

if [[ "${NEW_VALUE}" == "true" || "${NEW_VALUE}" == "false" ]]; then
	log "Set touchpad explicitly to ${NEW_VALUE}" 
else
	if isMousePluggedIn; then
		log "Mouse is plugged in. Ensuring touchpad is DISABLED."
		NEW_VALUE="false"
	else
		log "Mouse is not plugged in. Ensuring touchpad is ENABLED"
		NEW_VALUE="true"
	fi
fi

# The script runs as root, but gsettings needs to be run as the current X user
# The line below gets a unique list of each logged in user
CURRENT_USERS=$(who | cut -d" " -f1 | sort | uniq)

# The output is one user per line, so we use 'while read' to do something with
# each line.
while read -r CURRENT_USER; do
	su --command "gsettings set ${KEY} ${NEW_VALUE}" $CURRENT_USER
done <<< "$CURRENT_USERS"
# The triple < above is crucial for newlines in CURRENT_USERS to be interpreted
# correctly.

