#!/bin/bash
# slrverify.sh: christian.kadluba@gmail.com, 2012

source slrvars.sh

if [ $# -lt 1 ]
then
	echo Usage: $0 log-file [signature-file [public-key-file]]
	echo        signature-file defaults to log-file$slrsigfileext
	echo        public-key-file defaults to message-file$slrexppubkeyfileext
	echo        public-key-file = \'current\' uses "$slrcurprivkeypath"
	exit 1
fi

# Default parameter handling
sigfile=$2
if [ "$sigfile" = "" ]; then sigfile="$1$slrsigfileext"; fi

keyfile=$3
if [ "$keyfile" = "current" ]
then 
	keyfile="$slrcurpubkeypath"
elif [ "$keyfile" = "" ]
then
	keyfile="$1$slrexppubkeyfileext"
fi


echo Logfile: $1
echo Signature: $sigfile
echo Public key: $keyfile


# Decrypt signed hash with public key
openssl rsautl -verify -inkey "$keyfile" -keyform PEM -pubin -in "$sigfile" > "$sigfile.hash"

# Create hash of log-file in question
openssl dgst -sha256 < "$1" > "$1.hash"

# Compare hashes
if diff -s "$sigfile.hash" "$1.hash"
then
	echo Signature successfully verified
	status=0
else
	echo Could not verify signature
	status=1
fi

# Cleanup: remove hash files
rm "$sigfile.hash" "$1.hash"

exit $status

