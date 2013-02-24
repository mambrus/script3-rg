#!/bin/bash
# Author: Michael Ambrus (michael.ambrus@sonymobile.com)
# 2013-02-17

# Creates a tag in a specific branch. Read more in
# ./ui/.dotag.sh

if [ -z $DOTAG_SH ]; then

DOTAG_SH="dotag.sh"

function dotag() {
	local THE_TAG="${PREFIX}-${TIMEST}.${NUMBER}_${SUFFIX}"
	echo "$(basename $0): tagging ${THE_TAG} @ ${BRANCH}"

	if [ $YES_TO_ALL == "no" ]; then
		ask_user_continue || exit $?
	fi
		
	local HAS_BR=$(git branch | egrep "[[:space:]]${BRANCH}$")
	if [ "X${HAS_BR}" == "X" ]; then
		echo "Warning: Branch does not exist."
		echo "Creating a new one tracking ${TRACKING_REMOTE}?"
		if [ $YES_TO_ALL == "no" ]; then
			ask_user_continue || exit $?
		fi
		git branch ${BRANCH} ${TRACKING_REMOTE}
	fi
	if [ "X${AMMEND}" == "Xyes" ]; then
		git tag ${FORCED} -a "${THE_TAG}" -m "${A_MESSAGE}" ${BRANCH}
	else
		git tag ${FORCED} ${THE_TAG} ${BRANCH}
	fi
}

source s3.ebasename.sh
if [ "$DOTAG_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.
	source .rg.ui..dotag.sh
	source s3.user_response.sh

	#Stop on error. Hopefully git and repo returns codes correctly
	set -e
	
	dotag

	exit $?
fi

fi
