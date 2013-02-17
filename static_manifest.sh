#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-10-04

# Creates a static manifest of current repo which can later be used to
# recreate source-tree exactly as it was. In the same previously initialized
# repo (i.e. 'repo init ...' and all the local SHA1 must be present). To
# restore the source tree then you just:
#
# repo init -m host_date.xml

if [ -z $STATIC_MANIFEST_SH ]; then

STATIC_MANIFEST_SH="static_manifest.sh"

function static_manifest() {
	local FNAME="$1"
	repo manifest -r -o "${FNAME}" 1>/dev/null 2>/dev/null
}

source s3.ebasename.sh
if [ "$STATIC_MANIFEST_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	STATIC_MANIFEST_SH_INFO=${STATIC_MANIFEST_SH}
	source .rg.ui..static_manifest.sh

	set -e
	set -u

	if [ $# -gt 0 ]; then
		FNAME="$1"
	else
		FNAME="$(hostname)_$(date '+%y%m%d_%H%M%S').xml"
	fi

	static_manifest "${FNAME}" && echo "Static manifest created: ${FNAME}"

	exit $?
fi

fi
