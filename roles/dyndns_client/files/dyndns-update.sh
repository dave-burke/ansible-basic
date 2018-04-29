#!/bin/bash

set -e

# INIT 
file=/var/opt/dyndns-update_ip
config="dyndns-update.cfg"
global_config="/etc/opt/${config}"
user_config="${HOME}/.${config}"

# LOAD PROPERTIES
if [ -r "${global_config}" ]; then
	source "${global_config}"
fi
if [ -r "${user_config}" ]; then
	source "${user_config}"
fi

# CHECK PROPERTIES
if [ -z "${domain}" ]; then
	(>&2 echo "'domain' was not found in either ${global_config} or ${user_config}")
	exit 1
fi
if [ -z "${token}" ]; then
	(>&2 echo "'token' was not found in either ${global_config} or ${user_config}")
	exit 1
fi

# CHECK IP ADDRESS
[ -f "${file}" ] || touch "${file}"
old_ip="$(cat ${file})"
new_ip="$(dig +short myip.opendns.com "@resolver1.opendns.com")"

# UPDATE IP ADDRESS
if [ "${old_ip}" != "${new_ip}" ]; then
	echo "IP changed: ${old_ip} -> ${new_ip}. Saving to ${file}"
	echo "${new_ip}" > "${file}"
	echo "Updating duckdns"
	response=$(curl "https://www.duckdns.org/update?domains=${domain}&token=${token}&ip=${new_ip}")
	if [ "${response}" != "OK" ]; then
		(>&2> echo "UPDATE FAILED: Response was ${response}")
		exit 1
	fi
fi

