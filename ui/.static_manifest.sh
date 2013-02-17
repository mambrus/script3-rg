# UI part of rg.static_manifest.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_static_manifest_help() {
			cat <<EOF
Usage: $STATIC_MANIFEST_SH_INFO [options] [<output_file>]

Creates a static manifest from what is currently checked out


Options:
  -h		This help

Example:
  $STATIC_MANIFEST_SH_INFO static_manifest.xml

EOF
}
	while getopts h OPTION; do
		case $OPTION in
		h)
			print_static_manifest_help $0
			exit 0
			;;
		?)
			echo "Syntax error:" 1>&2
			print_static_manifest_help $0 1>&2
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
		print_static_manifest_help $0 1>&2
		exit 2
	fi

