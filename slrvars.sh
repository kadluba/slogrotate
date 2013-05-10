#!/bin/bash
# slrvars.sh: christian.kadluba@gmail.com, 2012

if [ "$slrvarsloaded" = "" ]
then
	slrconfdir=/etc/slr/
	slrbindir=/usr/bin/
	slrpubkeydir=$slrconfdir
	slrprivkeydir=/root/slr/
	slrbackupdir=/var/backup/slr/
	
	slrpubkeyfilebname=pubkey
	slrpubkeyfileext=.pem
	slrcurpubkeypath=$slrpubkeydir$slrpubkeyfilebname$slrpubkeyfileext
	slrexppubkeyfileext=.pubkey
	slrprivkeyfilebname=privkey
	slrprivkeyfileext=$slrpubkeyfileext
	slrcurprivkeypath=$slrprivkeydir$slrprivkeyfilebname$slrprivkeyfileext
	slrsigfileext=.sig
	
	slrbackupdir=/var/backup/slr/
	
	echo Secure Logrotate 1.0
	slrvarsloaded=1
fi

