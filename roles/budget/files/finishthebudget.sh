#!/bin/bash

MOUNT_DIR=/run/media/dave
DEVICE_LABEL=USB-BUDGET
USB_MOUNT_POINT=${MOUNT_DIR}/${DEVICE_LABEL}
LOCAL_CRYPT_MOUNT=${MOUNT_DIR}/truecrypt-private
BACKUP_CRYPT_MOUNT=${MOUNT_DIR}/truecrypt-corrupt

echo -n Checking USB drive... 
if mount | grep ${USB_MOUNT_POINT} >/dev/null; then
	echo Found ${USB_MOUNT_POINT}
else
	echo Not found!
	exit 1
fi

echo -n Looking for ${LOCAL_CRYPT_MOUNT}...
if [ -d ${LOCAL_CRYPT_MOUNT} ]; then
	echo Found!
else
	echo Not found!
	exit 1
fi

echo -n Looking for ${BACKUP_CRYPT_MOUNT}...
if [ -d ${BACKUP_CRYPT_MOUNT} ]; then
	echo Found!
else
	echo Not found!
	exit 1
fi

echo -n Checking for True Crypt...
MY_TC=$(command -v truecrypt || command -v realcrypt)
if [ -x ${MY_TC} ]; then
	echo Found ${MY_TC}
else
	echo "No TrueCrypt found"
	exit 1
fi

echo -n Confirming that Libre Office is closed...
if ps | grep localc > /dev/null; then
	echo "Close Libre Office first"
	exit 1
else
	echo "Done!"
fi

echo "Copying..."
rsync --delete -rutv ${LOCAL_CRYPT_MOUNT}/Finances/ ${BACKUP_CRYPT_MOUNT}/Finances/

${MY_TC} -t -d

echo "Removing crypt mount points"
if [[ -d "${LOCAL_CRYPT_MOUNT}" ]]; then
	sudo rm -dv "${LOCAL_CRYPT_MOUNT}"
fi
if [[ -d ${BACKUP_CRYPT_MOUNT} ]]; then
	sudo rm -dv "${BACKUP_CRYPT_MOUNT}"
fi

echo Syncing to USB
sync ; sleep 2

echo Unmounting USB
sudo umount ${USB_MOUNT_POINT}

if [[ -d "${USB_MOUNT_POINT}" ]]; then
	sudo rm -dv "${USB_MOUNT_POINT}"
fi

echo Done!

