#!/bin/bash

# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-10-26

# This script prints the manifest-line beloning to the project you stand in
# (or point at) at the moment.

if [ -z $MLINE_SH ]; then

MLINE_SH="mline.sh"

# Returns either the searched manifest or the one given by env-var
# Strip single line & multi-line XML remarks
function mline_manifest() {
	if [ -z "${MANIFEST_SH}" ]; then
		source rg.manifest.sh
	fi

	(
		if [ "X${MANIFEST_FILE}" == "X" ]; then
			manifest
		else
			cat ${MANIFEST_FILE}
		fi
	) | \
		sed -e '/^[[:space:]]*<!--.*-->[[:space:]]*$/d'  | \
		futil.dline.sh '/<!--/' '/-->/'
}

function mline() {
	if [ -z "${FIND_SH}" ]; then
		source futil.find.sh
	fi
	if [ -z "${NCHEW_SH}" ]; then
		source rg.nchew.sh
	fi

	if [ $# -eq 0 ]; then
		local LOCAL_ABS_ROOT_PATH=$(up_find '^\.repo$')
		if [ -z "${LOCAL_ABS_ROOT_PATH}" ]; then return 1; fi

		local LOCAL_ABS_LOCAL_REL_PROJ_PATH=$(up_find '^\.git$')
		if [ -z "${LOCAL_ABS_LOCAL_REL_PROJ_PATH}" ]; then return 2; fi
		if [ "X${LOCAL_ABS_LOCAL_REL_PROJ_PATH}" == "X${LOCAL_ABS_ROOT_PATH}" ]; then return 2; fi

		local LOCAL_REL_PROJ_PATH="$(nchew_from_left "${LOCAL_ABS_ROOT_PATH}/" ${LOCAL_ABS_LOCAL_REL_PROJ_PATH})"
		if [ -z "${LOCAL_REL_PROJ_PATH}" ]; then return 3; fi

		local SEARCH_VAL="[[:space:]]\+${SEARCH_PARAM}=\"${LOCAL_REL_PROJ_PATH}\""
		if [ -z "${SEARCH_VAL}" ]; then return 4; fi
	elif [ $# -eq 1 ]; then
		local SEARCH_VAL="[[:space:]]\+${SEARCH_PARAM}=\"${1}\""
	else
		return 4
	fi


	#Origins (note, can be more than one line)
	#Strighten out line if line-bloken
	#local REMOTES=$(
	#	(mline_manifest | futil.pline.sh '/<remote/' '/\/>/' ) | \
	#	awk '{printf("%s",$0)}END{printf("\n\n")}' | \
	#	sed -e 's/[[:space:]]\+/ /g')

	#echo $REMOTES
	#exit 0

	#Strighten out line if line-broken
	DEFAULT=$( mline_manifest | egrep '<default.*/>' )
	if [ $? -eq 1 ]; then
		DEFAULT=$(
			(mline_manifest | futil.pline.sh '/<default/' '/\/>/' ) | \
			awk '{printf("%s",$0)}END{printf("\n\n")}' | \
			sed -e 's/[[:space:]]\+/ /g')
	fi

	#echo $DEFAULT
	#exit 0

	#echo "$LOCAL_ABS_ROOT_PATH <-> $LOCAL_ABS_LOCAL_REL_PROJ_PATH <-> $SEARCH_VAL"
	#grep raw manifest-line
	local MLINE=$(
		mline_manifest | \
		grep "${SEARCH_VAL}" | \
		sed -e 's/^[[:space:]]\+//'
	)
	if [ -z "${MLINE}" ]; then 
		#try one more time but this time use name instead of path as
		#this is a legal optimization (i.e. "path" is missing on line
		#in which case path=name
		SEARCH_VAL=$(echo "${SEARCH_VAL}" | sed -e s'/+path=/+name=/')
		MLINE=$(
			mline_manifest | \
			grep "${SEARCH_VAL}" | \
			sed -e 's/^[[:space:]]\+//'
		)
	fi
	if [ -z "${MLINE}" ]; then 
		echo "${SEARCH_VAL}"
		return 5; 
	fi

	# If no PARAM_VAL, then we are done, print the raw MLINE, else continue with
	# parsing the output formatter.
	if [ "X${PARAM_VAL}" == "X" ]; then
		echo "${MLINE}"
	else
		#If only one parameter requested, pass to util.param.sh as is
		if [ "X$(echo ${PARAM_VAL} | grep ',')" == "X" ]; then
			OLINE=$(echo "${MLINE}" | util.param.sh $PARAM_VAL | sed -e 's/"//g')
			if [ "X${OLINE}" == "X" ]; then
				#Not found, try also in DEFAULT line
				#echo "(echo \"${DEFAULT}\" | util.param.sh $P"
				OLINE=$(
					echo "${DEFAULT}" | \
					util.param.sh $PARAM_VAL | \
					sed -e 's/"//g'
				)
			fi
			echo "${OLINE}"
		else
			PS=$(echo ${PARAM_VAL} | sed -e 's/,/\n/g')
			for P in $PS; do
				local OLINE=$(
					echo "${MLINE}" | \
					util.param.sh $P | \
					sed -e 's/"//g')
				if [ "X${OLINE}" == "X" ]; then
					#Not found, try also in DEFAULT line
					#echo "(echo \"${DEFAULT}\" | util.param.sh $P"
					OLINE=$(
						echo "${DEFAULT}" | \
						util.param.sh $P | \
						sed -e 's/"//g'
					)
				fi
				echo -n "${OLINE};"
			done
			echo
		fi
	fi
}

source s3.ebasename.sh
if [ "$MLINE_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	MLINE_SH_INFO=${MLINE_SH}
	source .rg.ui..mline.sh
	source futil.find.sh
	source futil.nchew.sh
	source rg.manifest.sh

	OLD_PATH=`pwd`

	cd ${START_DIR}
	LNO=0

	if [ "X${IS_ATTY}" == "Xno" ] || [ "X${PARAMS_FILE}" == "X-" ]; then
		cat ${PARAMS_FILE} | \
		while read LINE; do
			(( LNO = LNO + 1))
			mline "$LINE"
			RC=$?
			if ! [ $RC -eq 0 ]; then
				echo "Error in input line: $LNO" 1>&2
			fi
		done
	else
		mline "$@"
		RC=$?
	fi

	if [[ $RC = 1 ]]; then
		echo "Error $RC: This is not a Repo" 1>&2
	elif [[ $RC = 2 ]]; then
		echo "Error $RC: No git project found or you're not deep enough into Repo" 1>&2
	elif [[ $RC = 3 ]]; then
		echo "Error $RC: Internal error \"No project\"" 1>&2
	elif [[ $RC = 4 ]]; then
		echo "Error $RC: Internal error \"No project-string\"" 1>&2
	elif [[ $RC = 5 ]]; then
		echo "Error $RC: Project not found in manifest" 1>&2
	fi

	cd ${OLD_PATH}

	exit $RC
fi

fi
