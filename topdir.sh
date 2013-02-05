#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-10-20

# This script prints the root path of the repo prject your in, or pointing at.

if [ -z $TOPDIR_SH ]; then

TOPDIR_SH="topdir.sh"

function topdir() {
	if [ -z up_find ]; then
		source futil.find.sh
	fi

	up_find '^\.repo$'
}

source s3.ebasename.sh
if [ "$TOPDIR_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	TOPDIR_SH_INFO=${RDIR_SH}
	source .rg.ui..topdir.sh
	source futil.find.sh
	OLD_PATH=`pwd`

	cd ${START_DIR}
	topdir "$@"
	RC=$?

	cd ${OLD_PATH}

	exit $RC
fi

fi
