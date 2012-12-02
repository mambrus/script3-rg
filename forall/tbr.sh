#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

# Shows tracking branch for all projects in repo

if [ -z $ALL_TBR_SH ]; then

ALL_TBR_SH="tbr.sh"

function all_tbr() {
	export CROOT=$(pwd| sed -e 's/\//\\\//g')
	SED_CMD="sed -e 's/${CROOT}//'"
	repo forall -c "echo -n \$(pwd | $SED_CMD); echo -n ';'; rg.tbr.sh;" | \
		sed -e 's/^\///'
}

source s3.ebasename.sh
if [ "$ALL_TBR_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	all_tbr "$@"

	exit $?
fi

fi
