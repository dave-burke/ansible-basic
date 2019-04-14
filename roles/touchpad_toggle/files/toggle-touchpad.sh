#!/bin/bash

set -e

# View these logs via 'journalctl [-f] -t mouse-touchpad'
function log {
	echo "${@}" | systemd-cat -t mouse-touchpad
}

# When this dconf key is true, the touchpad is enabled
# This only works in Mate. Gnome has a different key.
KEY="org.mate.peripherals-touchpad touchpad-enabled"

NEW_VALUE=$1

if [[ "${NEW_VALUE}" == "true" || "${NEW_VALUE}" == "false" ]]; then
	log "Set touchpad to ${NEW_VALUE}" 
else
	CURRENT_VALUE="$(gsettings get ${KEY})" 
	if [[ "${CURRENT_VALUE}" == "true" ]]; then
		NEW_VALUE="false"
	else
		NEW_VALUE="true"
	fi
	log "Toggle touchpad from ${CURRENT_VALUE} to ${NEW_VALUE}"
fi

# The script runs as root, but gsettings needs to be run as the current X user
# The line below gets a unique list of each logged in user
CURRENT_USERS=$(who | cut -d" " -f1 | sort | uniq)

# The output is one user per line, so we use 'while read' to do something with
# each line.
while read -r CURRENT_USER; do
	su -c "gsettings set ${KEY} ${NEW_VALUE}" $CURRENT_USER
done <<< "$CURRENT_USERS"
# The triple < above is crucial for newlines in CURRENT_USERS to be interpreted
# correctly.

