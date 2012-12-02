#!/bin/bash
# Author: Michael Ambrus (ambrmi09@gmail.com)
# 2011-03-21

# Fetches new indexes for all gits in repo. This sript us good to put in your
# nightly cron-tab as it does not change state of your current work.

if [ -z $ALL_FETCH_SH ]; then

ALL_FETCH_SH="fetch.sh"

function all_fetch() {
	repo forall -c '( \
		pwd; \
		echo 	"=========*=========*=========*=========*=========*" \
			"=========*=========*=========*=========*"; \
		git fetch)'
}

source s3.ebasename.sh
if [ "$ALL_FETCH_SH" == $( ebasename $0 ) ]; then
	#Not sourced, do something with this.

	all_fetch "$@"

	exit $?
fi

fi
