#!/bin/bash

event="${1}"
device="${2}"
component="${3}"

subject="MDADM event: ${event} on ${device}"
if [ -n "${component}" ]; then
	subject+=" (${component})"
fi

message="$(cat /proc/mdstat)\n\n"

message+="$(mdadm --detail {{storage_device}})\n\n"

message+="$(df -h | head -n 1)\n"
message+="$(df -h | grep /dev/md)"

# Escape values for JSON
jsonSubject=$(jq -aRs . <<< "${subject}")
jsonMessage=$(jq -aRs . <<< "${message}")

curl -X POST \
	-H "Content-Type: application/json" \
	-H "Authorization: Basic $(echo -n "{{raid_notify_user}}:{{raid_notify_password}}" | base64)" \
	-d '{ "subject": '"${jsonSubject}"', "body": '"${jsonMessage}"' }' \
	"{{raid_notify_endpoint}}"
