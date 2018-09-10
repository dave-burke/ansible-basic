#!/bin/bash

MOUNT_DIR=/run/media/dave
DEVICE_LABEL=USB-BUDGET
USB_DEVICE=/dev/disk/by-label/${DEVICE_LABEL}
USB_MOUNT_POINT=${MOUNT_DIR}/${DEVICE_LABEL}
LOCAL_CRYPT=/home/dave/docs/private.tc
LOCAL_CRYPT_MOUNT=${MOUNT_DIR}/truecrypt-private
BACKUP_CRYPT=${USB_MOUNT_POINT}/Documents/corrupt
BACKUP_CRYPT_MOUNT=${MOUNT_DIR}/truecrypt-corrupt

echo -n Checking USB drive... 
REAL_DEVICE_PATH="$(realpath ${USB_DEVICE})"
if [[ "${REAL_DEVICE_PATH}" != "${USB_DEVICE}" ]]; then
	echo "Device ${USB_DEVICE} is actually ${REAL_DEVICE_PATH}"
fi
if [[ ! -e ${REAL_DEVICE_PATH} ]]; then
	echo "${REAL_DEVICE_PATH} is not a file. Is the USB drive inserted?"
	exit 1
fi
if [[ ! -b "${REAL_DEVICE_PATH}" ]]; then
	echo "${REAL_DEVICE_PATH} is not a block device!"
	exit 1
fi
if mount | grep -q "${REAL_DEVICE_PATH}"; then
	echo "${REAL_DEVICE_PATH} is already mounted"
else
	if [[ ! -d "${USB_MOUNT_POINT}" ]]; then
		sudo mkdir -v "${USB_MOUNT_POINT}"
		if [[ $? -ne 0 ]]; then
			echo "Failed to create ${USB_MOUNT_POINT}!"
			exit 1
		else
			echo "Created ${USB_MOUNT_POINT}!"
		fi
	fi
	echo "Mounting device..."
	mount -v "${REAL_DEVICE_PATH}" "${USB_MOUNT_POINT}"
	if [[ $? -ne 0 ]]; then
		echo Failed to mount. Trying with root...
		CURRENT_UID=$(id -u)
		CURRENT_GID=$(id -g)
		sudo mount -v -o umask=0022,uid=${CURRENT_UID},gid=${CURRENT_GID} "${REAL_DEVICE_PATH}" "${USB_MOUNT_POINT}"
	fi
	if ! mount | grep "${REAL_DEVICE_PATH}" >/dev/null; then
		echo "Failed to mount ${REAL_DEVICE_PATH}"
		exit 1
	fi
fi

echo -n Looking for ${LOCAL_CRYPT}...
if [ -f ${LOCAL_CRYPT} ]; then
	echo Found!
else
	echo Not found!
	exit 1
fi

echo -n Looking for ${BACKUP_CRYPT}...
if [ -f ${BACKUP_CRYPT} ]; then
	echo Found!
else
	echo Not found!
	exit 1
fi

echo -n Checking for Libre Office Calc...
if hash localc >/dev/null; then
	echo Found $(command -v localc)
else
	echo Not found!
	exit 1
fi

echo -n Determining browser...
MY_BROWSER=$(command -v firefox || command -v chromium || command -v chromium-browser || command -v opera || command -v konqueror)
if [ -x ${MY_BROWSER} ]; then
	echo Found ${MY_BROWSER}
else
	echo "No browser found"
	exit 1
fi

echo -n Checking for True Crypt...
MY_TC=$(command -v truecrypt || command -v realcrypt) #stupid openSUSE
if [ -x ${MY_TC} ]; then
	echo Found ${MY_TC}
else
	echo "No TrueCrypt found"
	exit 1
fi

echo -n Checking for loop module...
if lsmod | grep loop >/dev/null; then
	echo "Found!"
else
	echo "Not found, but required by truecrypt"
	exit 1
fi

echo -n Checking for local crypt mount...
if [[ -d ${LOCAL_CRYPT_MOUNT} ]]; then
	echo "Found ${LOCAL_CRYPT_MOUNT}!"
else
	sudo mkdir -v "${LOCAL_CRYPT_MOUNT}"
	if [[ $? -ne 0 ]]; then
		echo "Failed to create ${LOCAL_CRYPT_MOUNT}!"
		exit 1
	else
		echo "Created ${LOCAL_CRYPT_MOUNT}!"
	fi
fi

echo -n Checking for backup crypt mount...
if [[ -d ${BACKUP_CRYPT_MOUNT} ]]; then
	echo "Found ${BACKUP_CRYPT_MOUNT}!"
else
	sudo mkdir "${BACKUP_CRYPT_MOUNT}"
	if [[ $? -ne 0 ]]; then
		echo "Failed to create ${BACKUP_CRYPT_MOUNT}!"
		exit 1
	else
		echo "Created ${BACKUP_CRYPT_MOUNT}!"
	fi
fi

# Okay, get on with it!

echo -n "Enter your Truecrypt password: "
stty -echo
read PASSWORD
stty echo
echo #make a new line

echo -n "Mounting encrypted volumes..."
${MY_TC} -t -k "" --protect-hidden=no -p ${PASSWORD} ${LOCAL_CRYPT} ${LOCAL_CRYPT_MOUNT}
if [[ $? -ne 0 ]]; then
	echo "Failed to mount ${LOCAL_CRYPT}!"
	exit 1
fi
${MY_TC} -t -k "" --protect-hidden=no -p ${PASSWORD} ${BACKUP_CRYPT} ${BACKUP_CRYPT_MOUNT}
if [[ $? -ne 0 ]]; then
	echo "Failed to mount ${BACKUP_CRYPT}!"
	echo "Dismounting ${LOCAL_CRYPT}"
	${MY_TC} -t -d
	exit 1
fi
echo Done

echo -n "Opening browser..."
$MY_BROWSER "https://onlinebanking.usbank.com/Auth/Login" "https://secure07a.chase.com/web/auth/dashboard" "http://www.wellsfargo.com" > /dev/null &
echo "Done"

echo -n "Opening the most recent budget spreadsheet..."
ls -t ${LOCAL_CRYPT_MOUNT}/Finances/*.ods | head -n 1 | xargs -I{} localc "{}" > /dev/null &

echo "Done!"

