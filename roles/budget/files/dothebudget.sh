#!/bin/bash

readonly DOC_DIR="${HOME}/docs/personal/finances/budget"

echo -n Checking for Libre Office Calc...
if hash localc >/dev/null; then
	echo Found $(command -v localc)
else
	echo Not found!
	exit 1
fi

echo -n Determining browser...
readonly MY_BROWSER=$(command -v firefox || command -v chromium || command -v chromium-browser || command -v opera || command -v konqueror)
if [ -x ${MY_BROWSER} ]; then
	echo Found ${MY_BROWSER}
else
	echo "No browser found"
	exit 1
fi

# Okay, get on with it!

echo -n "Opening browser..."
$MY_BROWSER "https://onlinebanking.usbank.com/Auth/Login" "https://secure07a.chase.com/web/auth/dashboard" "http://www.wellsfargo.com" > /dev/null &
echo "Done"

echo -n "Opening the most recent budget spreadsheet..."
ls -t ${DOC_DIR}/*.ods | head -n 1 | xargs -I{} localc "{}" > /dev/null &

echo "Done!"

