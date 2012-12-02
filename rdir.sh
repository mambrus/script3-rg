#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-10-20

# This script prints the root path of the repo prject your in, or pointing at.

if [ -z $RDIR_SH ]; then

RDIR_SH="rdir.sh"

function rdir() {
	if [ -z up_find ]; then
		source futil.find.sh
	fi

	up_find '^\.repo$'
}

source s3.ebasename.sh
if [ "$RDIR_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	RDIR_SH_INFO=${RDIR_SH}
	source .rg.ui..rdir.sh
	source futil.find.sh
	OLD_PATH=`pwd`

	cd ${START_DIR}
	rdir "$@"
	RC=$?

	cd ${OLD_PATH}

	exit $RC
fi

fi
