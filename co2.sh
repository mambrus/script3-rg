#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2013-03-13

if [ -z $CO2_SH ]; then

CO2_SH="co2.sh"

function co2() {
	(
		cd $(dirname ${FULL_FILE_NAME})
		OLD_SHA1=$(git log --oneline -n1 ${FILE_NAME} | cut -f1 -d" ")
		if [ "X${OLD_SHA1}" == "X" ]; then
			echo "Can't determine SHA1 of [${FILE_NAME}]" 1>&2
			return 1
		fi
		git checkout "${FULL_BRANCH_NAME}" -- "${FILE_NAME}"
		mv "${FILE_NAME}" "${OUT_DIR}/${FILE_NAME}"
		git checkout "${OLD_SHA1}" -- "${FILE_NAME}"
		echo "[${FILE_NAME}] checked out as [${OUT_DIR}/${FILE_NAME}]"
	)
}

source s3.ebasename.sh
if [ "$CO2_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	CO2_SH_INFO=${RDIR_SH}
	source .rg.ui..co2.sh
	set -e
	set -u

	co2 "$@"
	RC=$?

	exit $RC
fi

fi
