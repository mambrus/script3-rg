#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2013-02-17

# This script prints the root path of the repo project your in, or pointing at.

if [ -z $MBR_SH ]; then

MBR_SH="mbr.sh"

function mbr() {
	(
		cd ${START_DIR}
		if [ "X${END_PART_ONLY}" == "Xyes" ]; then
			RC=$(rg.mline.sh -prevision -N)
		else
			RC=$(git br -a | \
				grep "\/$(rg.mline.sh -premote -N)\/" | \
				grep "\/$(rg.mline.sh -prevision -N)$" | \
				sed -e 's/^[[:space:]]\+//')
		fi
		if [ "X${RC}" == "X" ]; then
			echo "$MBR_SH: Internal error - no result" 1>&2
			exit 1
		fi
		if [ $(echo ${RC} | wc -l) -ne 1 ]; then
			echo "$MBR_SH: Internal error - more than one branches:" 1>&2
			echo "${RC}" 1>&2
			exit 1
		fi
		echo "${RC}"
	)
}

source s3.ebasename.sh
if [ "$MBR_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	MBR_SH_INFO=${RDIR_SH}
	source .rg.ui..mbr.sh
	source futil.find.sh

	mbr "$@"
	RC=$?

	exit $RC
fi

fi
