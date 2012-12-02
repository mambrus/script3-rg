#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-02-23

if [ -z $COMPACT_LOG ]; then

COMPACT_LOG="compact_log.sh"

# This script works as the basename command, except that it also
# ripps away everything in the name before the next but last '.'
# I.e. usage like:
# $ compact_log /some/path/pre.fix.myshell.sh
#   myshell.sh
#
# The script is a core part of the 'script3' script library

function compact_log() {
    git log | \
    	egrep '^commit|^Author|^Date|^[[:space:]]+Change-Id|[[:space:]]+Merge' | \
	sed -e 's/\(commit[[:space:]]*\)\(.*\)$/\2;/'  | \
	sed -e 's/\(Author:[[:space:]]*\)\(.*\)$/\2;/' | \
	sed -e 's/\(Date:[[:space:]]*\)\(.*\)$/\2/'    | \
	sed -e 's/\(^.*\)\(Change-Id.*\)$/;\2/'        | \
	sed -e 's/\(^.*\)\(Merge.*\)$/;\2/'            | \
	awk '{
		if (match($0,"^[[:xdigit:]]+;")){
			printf("\n%s",$0);
		}else{
		    printf("%s",$0)
		}
	}'
}

set -e
source s3.ebasename.sh
if [ "$COMPACT_LOG" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.
	compact_log $@
	exit $?
fi

fi
