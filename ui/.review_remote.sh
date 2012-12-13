# UI part of rg.review_remote.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_review_remote_help() {
			cat <<EOF
Usage: $REVIEW_REMOTE_SH_INFO [options]

sets up a remote called "review" in the current git which points
to the correct server git path on server.

After you have created a remote (usually for upload to gerrit/git), then you can
perform the following operations:

git push review <refspec>

Where refspec is usually one of the following:

HEAD:refs/for/<branch>   Push current branch from HEAD to Gerrit
HEAD:refs/changes/<ID>	 Push new patchset from current branch from HEAD to
			 Gerrit. This requires that the patchset already exists
			 and that the commit message contains a pre-existing
			 Change-Id (Change-Id: I<hex-digit>)
HEAD:refs/heads/<branch> Push current branch from HEAD to Git

Options:
  -F		Force create, If current remote exists with the same name as the one we
  		want to create, remove the first one and create the this one
		instead.
  -r <name>	Use this name as remote instead of review
  -P <port>	Use this port number instead of 29418
  -p <prot>	Protocol to use. Default is ssh
  -h		This help

Example:
  $REVIEW_REMOTE_SH_INFO -F


EOF
}
	while getopts Fr:p:P:h OPTION; do
		case $OPTION in
		h)
			clear
			print_review_remote_help $0
			exit 0
			;;
		r)
			REMOTE_NAME=$OPTARG
			;;
		p)
			PROTOCOL=$OPTARG
			;;
		P)
			PORTNUM=$OPTARG
			;;
		F)
			DO_FORCE="yes"
			;;
		?)
			echo "Syntax error:" 1>&2
			print_review_remote_help $0 1>&2
			exit 2
			;;

		esac
	done
	shift $(($OPTIND - 1))

	REMOTE_NAME=${REMOTE_NAME-"review"}
	DO_FORCE=${DO_FORCE-"no"}
	PROTOCOL=${PROTOCOL-"ssh"}
	PORTNUM=${PORTNUM-"29418"}

	IS_ATTY="yes"
	tty -s ||  IS_ATTY="no"

	if [ $# -gt 1 ]; then
		echo "Syntax error:" 1>&2
		print_review_remote_help $0 1>&2
		exit 2
	fi

