# UI part of rg.rdir.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_rdir_help() {
            cat <<EOF
Usage: $(basename $0) [options]

Print the remote branch defined by the manifest

Options:
  -d          Directory start-pointer. Note: may be anywhere in a repo
  -e          Print end-part only. Useful when pushing.
  -h          This help

Example:
  $(basename $0) -d ~/mydroid/xx/yy
  git push gitub HEAD:refs/heads/\$($(basename $0) -e)

EOF
}
	while getopts ehd: OPTION; do
		case $OPTION in
		h)
			print_rdir_help $0
			exit 0
			;;
		d)
			START_DIR=$OPTARG
			;;
		e)
			END_PART_ONLY="yes"
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
	END_PART_ONLY=${END_PART_ONLY-"no"}

