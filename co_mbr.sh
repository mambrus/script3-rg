#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2013-02-24

# This script prints the root path of the repo project your in, or pointing at.

if [ -z $CO_MBR_SH ]; then

CO_MBR_SH="co_mbr.sh"

function co_mbr() {
	source s3.user_response.sh

	local MBRANCH="--no-branch--"
	local CBRANCH=$(rg.cbr.sh)
	(
		cd ${START_DIR}
		MBRANCH=$(rg.mbr.sh)
		local RC=$?

		if [ ! $RC -eq 0 ]; then
			echo "Internal error [${CO_MBR_SH}]:"\
			     "Can't use branch ${MBRANCH}" 1>&2
			echo "Bailing out..." 1>&2
			return $RC
		else
			if [ $YES_TO_ALL == "no" ]; then
				ask_user_continue "Check out branch [${MBRANCH}] instead of [${CBRANCH}] (Y/n)" || exit $?
			fi
			git checkout ${MBRANCH}
		fi
	)
}

source s3.ebasename.sh
if [ "$CO_MBR_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	CO_MBR_SH_INFO=${CO_MBR_SH}
	source .rg.ui..co_mbr.sh
	source futil.find.sh

	co_mbr "$@"
	RC=$?

	exit $RC
fi

fi
