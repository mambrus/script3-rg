# UI part of rg.manifest.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_manifest_help() {
			cat <<EOF
Usage: $MANIFEST_SH_INFO [options]

Find the manifest in repo where you stand or from anywhere in directory you give
and print it on stdout.

Options:
  -d		Repo directory. Note can be anywhere in this structure
  -h		This help

Example:
  $MANIFEST_SH_INFO -d /myrepos/anroidsrc_1/bionic

EOF
}
	while getopts hd: OPTION; do
		case $OPTION in
		h)
			print_manifest_help $0
			exit 0
			;;
		d)
			START_DIR=$OPTARG
			;;
		?)
			echo "Syntax error:" 1>&2
			print_manifest_help $0 1>&2
			exit 2
			;;

		esac
	done
	shift $(($OPTIND - 1))

	START_DIR=${START_DIR-$(pwd)}

