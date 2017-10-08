#!/bin/bash

recipient="{{email_recipient}}"

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

echo -e "${message}" | mutt -s "${subject}" "${recipient}"

