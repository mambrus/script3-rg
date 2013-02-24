# UI part of rg.rdir.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_rdir_help() {
            cat <<EOF
Usage: $(basename $0) [options]

git checkout branch defined by manifest.

This is a really simple operation, but as it's so common it motivates a script
of it's own.

Options:
  -d          Directory start-pointer. Note: may be anywhere in a repo
  -y          Non interactive. Answer yes to everything.
  -h          This help

Example:
  $(basename $0) -d ~/mydroid/xx/yy
  git push gitub HEAD:refs/heads/\$($(basename $0) -e)

EOF
}
	while getopts yhd: OPTION; do
		case $OPTION in
		h)
			print_rdir_help $0
			exit 0
			;;
		d)
			START_DIR=$OPTARG
			;;
		y)
			YES_TO_ALL="yes"
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
	YES_TO_ALL=${YES_TO_ALL-"no"}

