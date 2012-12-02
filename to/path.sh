#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2012-10-19

# This script tells you the relative path for the project you give
# Relative in this context can mean from project root, orf from where you
# stand, depending on option.

if [ -z $TO_PATH_SH ]; then

TO_PATH_SH="path.sh"

function to_path() {
	rg.manifest.sh | futil.pline.sh '/manifest/' '/manifest/' | \
		grep "project name=\"$1\"" | \
		sed -e 's/^.*path=\"//' | \
		sed -e 's/\".*$//'
}

source s3.ebasename.sh
if [ "$TO_PATH_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	to_path "$@"

	exit $?
fi

fi
