#!/bin/bash
# slrgenkeys.sh: christian.kadluba@gmail.com, 2012

source slrvars.sh

if [ $UID != 0 ]
then
	echo You need to be root to run this
	exit 1
fi

currdate=`date +%Y-%m-%dT%H:%M:%S`
newprivkey="$slrprivkeydir${slrprivkeyfilebname}_$currdate$slrprivkeyfileext"
newpubkey="$slrpubkeydir${slrpubkeyfilebname}_$currdate$slrpubkeyfileext"

# Generate private and public key file with datetime in filename
openssl genrsa -out "$newprivkey" 1024
openssl rsa -in "$newprivkey" -out "$newpubkey" -outform PEM -pubout

# Create fixed-filename links to generated key files
rm -f "$slrcurprivkeypath"
ln "$newprivkey" "$slrcurprivkeypath"
rm -f "$slrcurpubkeypath"
ln "$newpubkey" "$slrcurpubkeypath"

exit 0

