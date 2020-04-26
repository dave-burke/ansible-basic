#!/bin/bash

set -e

if [[ $# == 0 ]]; then
	doctl compute size list
	exit 0
fi

DROPLET_NAME="${1}"
DROPLET_ID=$(doctl compute droplet list "${DROPLET_NAME}" --no-header | cut -d ' ' -f1)
if [[ $# == 1 ]]; then
	doctl compute droplet get ${DROPLET_ID}
	exit 0
fi

NEW_SIZE="${2}"

echo "Resizing ${DROPLET_NAME} (${DROPLET_ID}) to ${NEW_SIZE}"
RESIZE_ACTION_ID=$(doctl compute droplet-action resize --size "${NEW_SIZE}" --format "ID" --no-header ${DROPLET_ID})
echo "Started resize action with ID ${RESIZE_ACTION_ID}"
doctl compute action wait ${RESIZE_ACTION_ID}

echo "Powering on droplet"
POWERON_ACTION_ID=$(doctl compute droplet-action power-on --format "ID" --no-header ${DROPLET_ID})
doctl compute action wait ${POWERON_ACTION_ID}
echo "Done!"

