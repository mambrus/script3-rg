# UI part of rg.cbr.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_cbr_help() {
			cat <<EOF
Usage: $CBR_SH_INFO [options]

Prints current branch. If no branch is checked out, it's assumed the branch is
the remote branch the manifest say it is.

Options:
  -h		This help

Example:
  $CBR_SH_INFO cbr.xml

EOF
}
	while getopts h OPTION; do
		case $OPTION in
		h)
			print_cbr_help $0
			exit 0
			;;
		?)
			echo "Syntax error:" 1>&2
			print_cbr_help $0 1>&2
			exit 2
			;;

		esac
	done
	shift $(($OPTIND - 1))

	if [ $# -eq 0 ]; then
		OFILENAME=$1
	elif [ $# -eq 1 ]; then
		OFILENAME=""
	else
		echo "Syntax error:" 1>&2
		print_cbr_help $0 1>&2
		exit 2
	fi

