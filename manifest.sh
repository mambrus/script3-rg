#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-10-19

# This script prints the manifest where you stand or from a directory pointing
# anywhere in a repository file-system

if [ -z $MANIFEST_SH ]; then

MANIFEST_SH="manifest.sh"

function manifest() {
	if [ "X$FIND_SH" == "X" ]; then
		source futil.find.sh
	fi
	local REPO_ROOT=$(up_find '^\.repo$')
	if [ "X${REPO_ROOT}" == X ]; then
		return 1
	fi
	REPO_DIR=${REPO_ROOT}/.repo
	if [ ! -e ${REPO_DIR}/manifest.xml ]; then
		return 2
	fi
	cat ${REPO_DIR}/manifest.xml
}

source s3.ebasename.sh
if [ "$MANIFEST_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	MANIFEST_SH_INFO=${MANIFEST_SH}
	source .rg.ui..manifest.sh
	source futil.find.sh

	LAST_PATH=`pwd`
	cd ${START_DIR}

	manifest "$@"
	RC=$?

	cd ${LAST_PATH}
	if [ $RC -eq 1 ]; then
		echo "Error: This is not a repository" 1>&2
	fi
	if [ $RC -eq 2 ]; then
		echo "Error: No manifest found here" 1>&2
	fi

	exit ${RC}
fi

fi
