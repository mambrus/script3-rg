#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-10-18

# This script tells you the current branch of the git in the structure
# where you stand.

if [ -z $CBR_SH ]; then

CBR_SH="cbr.sh"

function cbr() {
	git branch | egrep '^\*'
}

source s3.ebasename.sh
if [ "$CBR_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	cbr "$@"

	exit $?
fi

fi
