#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

# This script tells you the current tracking branch of the git in the structure
# where you stand. This is kept simple, another way might be to get this from
# the manifest. This will be added using flags. /* TBD */

if [ -z $TBR_SH ]; then

TBR_SH="tbr.sh"

function tbr_git() {
	DB=$(git branch -r | grep ">" | cut -f2 -d">" | awk '{print $1}')
	if [ -z $DB ]; then
		git br -r | head -n1 | sed -e 's/^[[:space:]]\+//'
	else
		echo ${DB}
	fi
}

#Detect which branch to track via the manifest
# *** TBD ***
function tbr_manifest() {
	echo "TBD" 1>&2
	exit 1
}


source s3.ebasename.sh
if [ "$TBR_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	tbr_git "$@"

	exit $?
fi

fi
