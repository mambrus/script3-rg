# UI part of rg.gitsplit.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing includead.

# Some defaults.
GITSPLIT_SH_INFO_ODIR="./new_gits"
GITSPLIT_SH_INFO_REMOTE="github"
GITSPLIT_SH_INFO_URL="git@github.com:${USER}"
GITSPLIT_SH_INFO_PRFX="script3-"

function print_gitsplit_help() {
			cat <<EOF
Usage: $GITSPLIT_SH_INFO [options] [<sub-directory>]

Take out a subdirectory from a git-repo and make an independent git of it
keeping the history belonging to the files in that sub-dir. The script works
only on local gits and the dir you point out must belong to an existing git.

Options:
  -d <dir>        Specify a directory where to put the output. Default
                  directory is: [${GITSPLIT_SH_INFO_ODIR}]
  -c              Also clone out the mirror into a work-directory.
  -r <remspec>    Where <remspec> is "<remotename>;<URL>;<name-prefix>".
                  Default: "${GITSPLIT_SH_INFO_REMOTE};${GITSPLIT_SH_INFO_URL};${GITSPLIT_SH_INFO_PRFX}"
                  Note that guthub does not support subdirectories under one
                  account. Convention is to use '-'
  -h              This help

Example:
  $GITSPLIT_SH_INFO -d ~/new_gits mydir


EOF
}
	while getopts hd:r:c OPTION; do
		case $OPTION in
		h)
			clear
			print_gitsplit_help $0
			exit 0
			;;
		d)
			O_DIR=$OPTARG
			;;
		r)
			REM_SPEC=$OPTARG
			;;
		c)
			CLONE_OUT="yes"
			;;
		?)
			echo "Syntax error:" 1>&2
			print_gitsplit_help $0 1>&2
			exit 2
			;;

		esac
	done
	shift $(($OPTIND - 1))

	O_DIR=${O_DIR-${GITSPLIT_SH_INFO_ODIR}}
	CLONE_OUT=${CLONE_OUT-"no"}
    REM_SPEC=${REM_SPEC-"${GITSPLIT_SH_INFO_REMOTE},${GITSPLIT_SH_INFO_URL},${GITSPLIT_SH_INFO_PRFX}"}
	REMOTE=$(echo "${REM_SPEC}" | awk -F, '{print $1}')
	URL=$(echo "${REM_SPEC}" | awk -F, '{print $2}')
	PRFX=$(echo "${REM_SPEC}" | awk -F, '{print $3}')
	
	if [ ! $# -eq 1 ]; then
		echo "Syntax error:" 1>&2
		print_gitsplit_help $0 1>&2
		exit 2
	fi

	CLONE_FROM_DIR="$1"
	CLONE_TO_DIR="${O_DIR}/${CLONE_FROM_DIR}"
	if [ ! -d "${O_DIR}" ]; then
		mkdir -p ${O_DIR}
	fi

	unset GITSPLIT_SH_INFO_ODIR
	unset GITSPLIT_SH_INFO_REMOTE
	unset GITSPLIT_SH_INFO_URL
	unset GITSPLIT_SH_INFO_PRFX
