#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-10-18

# Shows current branch for all projects in repo

if [ -z $ALL_CBR_SH ]; then

ALL_CBR_SH="cbr.sh"

function all_cbr() {
	export CROOT=$(pwd| sed -e 's/\//\\\//g')
	SED_CMD="sed -e 's/${CROOT}//'"
	repo forall -c "echo -n \$(pwd | $SED_CMD); echo -n ';'; rg.cbr.sh;" | \
		sed -e 's/^\///'
}

source s3.ebasename.sh
if [ "$ALL_CBR_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	all_cbr "$@"

	exit $?
fi

fi
