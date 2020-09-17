#!/bin/bash

event="${1}"
device="${2}"
component="${3}"

subject="MDADM event: ${event} on ${device}"
if [ -n "${component}" ]; then
	subject+=" (${component})"
fi

message="$(cat /proc/mdstat)\n\n"

message+="$(mdadm --detail /dev/disk/by-uuid/{{storage_uuid}})\n\n"

message+="$(df -h | head -n 1)\n"
message+="$(df -h | grep /dev/md)"

curl -X POST \
	-H "Content-Type: application/json" \
	-H "Authorization: Basic $(echo -n "{{raid_notify_user}}:{{raid_notify_password}}" \
	-d '{ "subject": "'"${subject}"'", "body": "'"${message}"'" }' \
	"{{raid_notify_endpoint}}"
