#!/bin/bash
# slrsign.sh: christian.kadluba@gmail.com, 2012

source slrvars.sh

if [ $UID != 0 ]
then
	echo You need to be root to run this
	exit 1
fi

if [ $# -lt 1 ]
then
	echo Usage: $0 message-file
	exit 1
fi

# Create hash file
openssl dgst -sha256 < "$1" > "$1.hash"

# Sign hash with private key, remove hash file again
openssl rsautl -sign -inkey "$slrcurprivkeypath" -keyform PEM -in "$1.hash" > "$1$slrsigfileext"
rm "$1.hash"

# Copy public key along with signature file for convenience
cp "$slrcurpubkeypath" "$1$slrexppubkeyfileext"

exit 0
