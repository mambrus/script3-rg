#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-11-23

# This script prints the manifest-line beloning to the project you stand in
# (or point at) at the moment.

if [ -z $REVIEW_REMOTE_SH ]; then

REVIEW_REMOTE_SH="review_remote.sh"

function review_remote() {
	local SERVER_AND_PATH=$(
		git config -l | \
		grep remote.origin.url | \
		cut -f2 -d"=" | \
		sed -e 's/^.*\/\///')

	if [ "X${SERVER_AND_PATH}" == "X" ]; then
		echo "Fatal error: Can't determine server name" 1>&2
		return 1
	fi

	UNAME=$(
		git config -l | \
		grep user.email | \
		cut -f2 -d"=" | \
		cut -f1 -d"@")

	if [ "X${UNAME}" == "X" ]; then
		echo "Fatal error: Can't determine uname" 1>&2
		return 1
	fi

	local FULL_SERVER_AND_PATH=$(echo $SERVER_AND_PATH | sed -e "s/\//:${PORTNUM}\//")

	if [ "X$(git remote | grep ${REMOTE_NAME})" == "X" ]; then
		local IS_VIRGIN='yes'
	else
		local IS_VIRGIN='no'
	fi

	if [ "X${DO_FORCE}" == "Xyes" ] || [ "X${IS_VIRGIN}" == "Xyes" ]; then
		if [ "X${IS_VIRGIN}" == "Xno" ]; then
			git remote rm "${REMOTE_NAME}"
		fi
		git remote add "${REMOTE_NAME}" "${PROTOCOL}://${UNAME}@${FULL_SERVER_AND_PATH}"
	else
		echo "Error: Remote with same name exists [${REMOTE_NAME}]" 1>&2
		return 1
	fi
}

source s3.ebasename.sh
if [ "$REVIEW_REMOTE_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	REVIEW_REMOTE_SH_INFO=${REVIEW_REMOTE_SH}
	source .rg.ui..review_remote.sh


	review_remote "$@"
	RC=$?

	exit $RC
fi

fi
