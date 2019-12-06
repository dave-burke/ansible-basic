#!/bin/bash

set -e

trap times EXIT

export BORG_PASSPHRASE="{{borg_passphrase_photos}}"

REPO_HOST=servy
REPO_DIR=/mnt/storage/backup/borg/photos
REPO_PATH=${USER}@${REPO_HOST}:${REPO_DIR}

ROOT_SOURCE=$(realpath ${HOME}/photos)

# year 3000 problem, lol
for dir in $(find "${ROOT_SOURCE}" -maxdepth 1 -type d -name "20*" | sort); do
	year="$(basename ${dir})"
	echo "$(date -Iminutes) Backing up ${year}..."
	for month in 01 02 03 04 05 06 07 08 09 10 11 12; do
		echo "$(date -Iminutes)     ${month}"
		src="${ROOT_SOURCE}/${year}/${month}"
		if [[ -d ${src} ]]; then
			prefix="${year}-${month}"
			borg create "${REPO_PATH}::${prefix}_{now}" "${src}"
			borg prune --prefix="${prefix}" --keep-daily=7 --keep-weekly=4 --keep-monthly=12 "${REPO_PATH}"
		fi
	done
done
ssh servy aws sync --profile wasabi --endpoint-url https://s3.us-east-2.wasabisys.com /mnt/storage/backup/borg/photos s3://one.brk.backup.borg.photos
borg info "${REPO_PATH}"

