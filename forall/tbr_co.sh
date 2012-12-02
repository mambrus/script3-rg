#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-10-18

# This script checks out all repo to current tracking branches

if [ -z $TBR_ALL_CO_SH ]; then

TBR_ALL_CO_SH="tbr_co.sh"


function tbr_all_co() {
	local CROOT=$(pwd| sed -e 's/\//\\\//g')
	local SED_CMD="sed -e 's/${CROOT}//'"
	repo forall -c "echo -n \$(pwd | $SED_CMD);\
		echo -n ' >>> ';\
		git checkout \$(rg.tbr.sh)"
}


source s3.ebasename.sh
if [ "$TBR_ALL_CO_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.
	set -e
	set -u

	tbr_all_co "$@"

	exit $?
fi

fi
