#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2013-02-05

# Splits out one directory from an existing git

if [ -z $DIR2GIT_SH ]; then

DIR2GIT_SH="gitsplit.sh"


function gitsplit() {
	local R_DIR=$(basename "${CLONE_FROM_DIR}")
	local ORIG_DIR=$(pwd)
	(
		cd $(dirname "${CLONE_FROM_DIR}")
		REPO_ROOT_DIR=$(rg.topdir.sh -G)
		cd "${ORIG_DIR}"
		#mkdir -p "${O_DIR}/${R_DIR}"
		#cd "${O_DIR}/${R_DIR}"
		cd "${O_DIR}"
		git clone --no-hardlinks --mirror "${REPO_ROOT_DIR}" "${R_DIR}.git"
		cd "${R_DIR}.git"
		git filter-branch --subdirectory-filter "${R_DIR}"
		git gc
		if [ "X${CLONE_OUT}" == "Xyes" ]; then
			cd ..
			git clone "${R_DIR}.git"
		fi
	)
}

source s3.ebasename.sh
if [ "$DIR2GIT_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	DIR2GIT_SH_INFO=${DIR2GIT_SH}
	source .rg.ui..gitsplit.sh

	set -e

	gitsplit "$@"
	RC=$?

	exit $RC
fi

fi
