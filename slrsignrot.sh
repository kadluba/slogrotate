#!/bin/bash
# slrsignrot.sh: christian.kadluba@gmail.com, 2012

movesigandkey()
{
	local from="$1"
	local to="$2"

	if [ -f "$from$slrsigfileext" ]
	then
		echo Moving "$from$slrsigfileext" to "$to$slrsigfileext"
		mv -f "$from$slrsigfileext" "$to$slrsigfileext"
	fi
	if [ -f "$from$slrexppubkeyfileext" ]
	then
		echo Moving "$from$slrexppubkeyfileext" to "$to$slrexppubkeyfileext"
		mv -f "$from$slrexppubkeyfileext" "$to$slrexppubkeyfileext"
	fi
}


source slrvars.sh

if [ $UID != 0 ]
then
	echo You need to be root to run this
	exit 1
fi

if [ $# -lt 2 ] || [ $2 -lt 3 ]
then
	echo Usage: $0 logfile-path rotate-number
	echo           rotate-number must be 3 or higher
	exit 1
fi

echo '***************************************************'
date

rotnum=$2

# Rotate any remaining sig and pubkey files +1
echo Rotating signature files "$1.1$slrsigfileext" - "$1.$rotnum$slrsigfileext"	
tonum=$rotnum
let fromnum=tonum-1
while [ $fromnum -gt 0 ]
do
	movesigandkey "$1.$fromnum" "$1.$tonum"
	let tonum--
	let fromnum--
done

# Create new sig and pubkey files for first rotated log file (.1)
if [ -f "$1.1" ]
then
	echo Signing rotated log file "$1.1"
	"${slrbindir}slrsign.sh" "$1.1"
else
	echo Could not find rotated log file "$1.1"	
fi

# Copy last log file (rotate-number) to and corresponding sig and pubkey to backup dir
currdate=`date +%Y-%m-%dT%H:%M:%S`
if [ -f "$1.$rotnum" ]
then	
	echo Copying "$1.$rotnum" to "${slrbackupdir}syslog_$currdate"
	cp -f "$1.$rotnum" "${slrbackupdir}syslog_$currdate"

	if [ -f "$1.$rotnum$slrsigfileext" ] && [ -f "$1.$rotnum$slrexppubkeyfileext" ]
	then	
		echo Copying "$1.$rotnum$slrsigfileext" to "${slrbackupdir}syslog_$currdate$slrsigfileext"
		cp -f "$1.$rotnum$slrsigfileext" "${slrbackupdir}syslog_$currdate$slrsigfileext"
		echo Copying "$1.$rotnum$slrexppubkeyfileext" to "${slrbackupdir}syslog_$currdate$slrexppubkeyfileext"
		cp -f "$1.$rotnum$slrexppubkeyfileext" "${slrbackupdir}syslog_$currdate$slrexppubkeyfileext"
	fi
fi

exit 0

