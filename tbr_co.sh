#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

# Git checkout into the current tracking branch

if [ -z $TBR_CO_SH ]; then

TBR_CO_SH="tbr_co.sh"

function tbr_co() {
	git checkout $(rg.tbr.sh); git branch | egrep '^\*'
}

source s3.ebasename.sh
if [ "$TBR_CO_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	tbr_co "$@"

	exit $?
fi

fi
