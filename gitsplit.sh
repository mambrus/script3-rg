#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2013-02-05

# Splits out one directory from an existing git

if [ -z $DIR2GIT_SH ]; then

DIR2GIT_SH="gitsplit.sh"


function gitsplit() {
	local LEAF_DIR=$(basename "${CLONE_FROM_DIR}")
	local ORIG_DIR=$(pwd)
	(
		cd "${CLONE_FROM_DIR}"
		REPO_ROOT_DIR=$(rg.topdir.sh -G)
		RELATIVE_GDIR=$(futil.nchew.sh "${REPO_ROOT_DIR}" "$(pwd)" | \
			sed -e 's/^\///')
		cd "${ORIG_DIR}"
		cd "${O_DIR}"
		git clone --no-hardlinks --mirror "${REPO_ROOT_DIR}" "${LEAF_DIR}.git"
		cd "${LEAF_DIR}.git"
		git filter-branch --subdirectory-filter "${RELATIVE_GDIR}"
		git gc
		if [ "X${CLONE_OUT}" == "Xyes" ]; then
			cd ..
			git clone "${LEAF_DIR}.git"
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
