# UI part of rg.rdir.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_rdir_help() {
			cat <<EOF
Usage: $TOPDIR_SH_INFO [options]

Print the root-path of a repo

Options:
  -d		Directory. Note: may be anywhere in a repo
  -h        This help

Example:
  $TOPDIR_SH_INFO -d ~/mydroid/xx/yy

EOF
}
	while getopts hd: OPTION; do
		case $OPTION in
		h)
			print_rdir_help $0
			exit 0
			;;
		d)
			START_DIR=$OPTARG
			;;
		?)
			echo "Syntax error:" 1>&2
			print_rdir_help $0 1>&2
			exit 2
			;;

		esac
	done
	shift $(($OPTIND - 1))

	START_DIR=${START_DIR-$(pwd)}

