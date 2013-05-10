#!/bin/bash
# install.sh: christian.kadluba@gmail.com, 2012

source slrvars.sh

if [ $UID != 0 ]
then
	echo You need to be root to run this
	exit 1
fi

mkdir -p "$slrconfdir"
cp -f logrotate-slrsample.conf "$slrconfdir"

mkdir -p "$slrbindir"
cp -f slrsignrot.sh "$slrbindir"
cp -f slrgenkeys.sh "$slrbindir"
cp -f slrsign.sh "$slrbindir"
cp -f slrvars.sh "$slrbindir"
cp -f slrverify.sh "$slrbindir"

mkdir -p "$slrpubkeydir"
mkdir -p "$slrprivkeydir"

mkdir -p "$slrbackupdir"
chmod 777 "$slrbackupdir"

slrgenkeys.sh

echo Secure Logrotate was installed.
echo For an initial installation consider the following next steps:
echo 1. Add a cron job which calls "${slrbindir}slrgenkeys.sh" on a regular basis
echo 2. Activate slr in your /etc/logrotate.conf. A sample can be found in "${slrconfdir}logrotate-slrsample.conf".

exit 0
