# UI part of rg.mline.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

function print_mline_help() {
			cat <<EOF
Usage: $MLINE_SH_INFO [options] [<relative-directory> | <search-arg-val>]

If used while in source-tree: Searches for the correspinding repo manifest
and then the corresponding-line in that manifest to the project you're in,
or project you point out, to stdout.

If input from stdin: Unless -s is given, input is the manifest line search
pattern and is expected to be a directory relative to a project root. If
directory to an existing project is needed (i.e. absolute path), use -d option
instead. Note that having search patterns comming both from command-line and
from stdin is considered to be an error.

Options:
  -d <dir>     Specific projec directory. May be anywhere in git-project.
  -m <file>    Use this manifest as if it would belong to this project.
  -p <par>     Instead of printing the whole manifest line, print a parameter in
               it. This can pe any parameter normally existing in that line or in
               the default line. Like for example "revision" would be taken from
               the default line if no "revision=" is found for the project you
               seek. Several parameters kan be listed if separated by ','. Order
               given will determine output order.
               Typical parameters: path,name,revision,remote.
               Hints: "name" is path on server for the git and "path" is local-
               tree path.
  -s <par>     Search argument. Typical search arguents are "path" or "name" as
               they are both unique in a manifest. If combined with stdin input or
               search-arg-val, position in current source-tree is completely
               ignored. Having no stdin or search-arg-val makes little sense
               unless -m is given. If -m points to another manifest, the position
               of "this" project can be used to for example look up the git
               position in another manifest. Default type is "path".
  -F <file>    Search arguments in this file. Set to -f- to force input from
               stdin when pipe-detecton fails or when you need input from user.
  -N           No stdin input. There are cases in scripts where pipe-detection
               fails and script thinks input is piped. This option ignores pipe.
               stdin when pipe-detecton fails or when you need input from user.
  -h           This help

Example:
  $MLINE_SH_INFO -d ~/mydroid/hardware/ti/wlan
  $MLINE_SH_INFO -m mymanifest.xml -p name,path,revision,remote
  $MLINE_SH_INFO -s name -p name,path android/platform/hardware/ti/wlan
  cat projects.txt | $MLINE_SH_INFO -s name
  $MLINE_SH_INFO -s name -f- < projects.txt


EOF
}
	while getopts hd:m:p:s:F:N OPTION; do
		case $OPTION in
		h)
			clear
			print_mline_help $0
			exit 0
			;;
		d)
			START_DIR=$OPTARG
			;;
		m)
			MANIFEST_FILE=$OPTARG
			;;
		p)
			PARAM_VAL=$OPTARG
			;;
		s)
			SEARCH_PARAM=$OPTARG
			;;
		N)
			NO_STDIN="yes"
			;;
		F)
			PARAMS_FILE=$OPTARG
			;;
		?)
			echo "Syntax error:" 1>&2
			print_mline_help $0 1>&2
			exit 2
			;;

		esac
	done
	shift $(($OPTIND - 1))

	START_DIR=${START_DIR-$(pwd)}
	MANIFEST_FILE=${MANIFEST_FILE-""}
	PARAM_VAL=${PARAM_VAL-""}
	SEARCH_PARAM=${SEARCH_PARAM-"path"}
	PARAMS_FILE=${PARAMS_FILE-"/dev/null"}
	NO_STDIN=${NO_STDIN-"no"}

	if [ "X${NO_STDIN}" == "Xno" ]; then
		#Allow test. Otherwise this is a forced non-interactive/-piped
		IS_ATTY="yes"
		tty -s ||  IS_ATTY="no"
		if [ "X${IS_ATTY}" == "Xno" ]; then
			PARAMS_FILE="-"
		fi
	else
		IS_ATTY="yes"
	fi

	if [ $# -gt 1 ]; then
		echo "Syntax error:" 1>&2
		print_mline_help $0 1>&2
		exit 2
	fi

