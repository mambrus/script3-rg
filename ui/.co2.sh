# UI part of rg.co2.sh
# This is not even a script. It is purely meant for being included.

function print_co2_help() {
            cat <<EOF
Usage: $(basename $0) [options] <branch_or_tag> <filename>

git checkout a specific file into a directory. The check-out file will retain
its name, but be placed in a subdirectory according to the given branch.
That way several specific files can easily be diffed per version.

Command must have branch-name either via -b flag or as first argument, there
is no default.

Note: Original file will be restored in it's original form. Please check
just in case script fails.

Options:
  -d          Output directory (default is /tmp/<dirname_of_file>)
  -b          branch name
  -h          This help

Example:
  $(basename $0) -d /tmp/mycompares -b refs/tags/a_tag_name

EOF
}
	while getopts hd:b: OPTION; do
		case $OPTION in
		h)
			print_co2_help $0
			exit 0
			;;
		d)
			ROOT_OUT_DIR=$OPTARG
			;;
		b)
			FULL_BRANCH_NAME=$OPTARG
			;;
		?)
			echo "Syntax error:" 1>&2
			print_co2_help $0 1>&2
			exit 2
			;;

		esac
	done
	shift $(($OPTIND - 1))

	if [ $# -gt 2 ] || [ $# -eq 0 ]; then
		print_co2_help 1>&2
		exit 1
	fi

	if [ "X${FULL_BRANCH_NAME}" == "X" ] && [ $# -eq 1 ]; then
		print_co2_help 1>&2
		exit 1
	fi


	if [ $# -eq 1 ]; then
		FULL_FILE_NAME=$1
	else
		FULL_BRANCH_NAME=$1
		FULL_FILE_NAME=$2
	fi

	BRANCH_NAME=$(basename ${FULL_BRANCH_NAME})
	FILE_NAME=$(basename ${FULL_FILE_NAME})

	if [ "X$(dirname ${FULL_FILE_NAME})" == "X." ]; then
		ROOT_OUT_DIR=${ROOT_OUT_DIR-"/tmp"}
		OUT_DIR=${OUT_DIR-"${ROOT_OUT_DIR}/${BRANCH_NAME}"}
	else
		ROOT_OUT_DIR=${ROOT_OUT_DIR-"/tmp/$(dirname ${FULL_FILE_NAME})"}
		OUT_DIR=${OUT_DIR-"${ROOT_OUT_DIR}/${BRANCH_NAME}/$(dirname ${FULL_FILE_NAME})"}
	fi

#Sanity checks
	if [ "X${BRANCH_NAME}" == "X" ] || [ "X${OUT_DIR}" == "X" ]; then
		echo "Sanity check failed. Check file ui/.$(basename $0)" 1>&2
	fi

	if ! [ -f "${FULL_FILE_NAME}" ]; then
		echo "File [${FULL_FILE_NAME}] must exist prior running this command." 1>&2
		echo "Try 'git checkout' on it first" 1>&2
		exit 1
	fi

	#echo "BRANCH_NAME: ${BRANCH_NAME}"
	#echo "OUT_DIR: ${OUT_DIR}"
	#echo "FILE_NAME: ${FILE_NAME}"
	#exit 1

	if ! [ -d "${OUT_DIR}" ]; then
		mkdir -p "${OUT_DIR}"
	fi
