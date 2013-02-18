# UI part of rg.dotag.sh
# This is not even a script, stupid and can't exist alone. It is purely
# ment for beeing included.

DFLT_DOTAG_TRACKING_REMOTE=$(git config -l | grep =refs/heads | cut -f2 -d"=")
DFLT_DOTAG_SUFFIX=$(rg.mline.sh -prevision -N)

if [ "X${DFLT_DOTAG_SUFFIX}" == "X" ]; then
	DFLT_DOTAG_SUFFIX=${DFLT_DOTAG_TRACKING_REMOTE##*/}
fi

function print_dotag_help() {
	cat <<EOF
Usage: $(basename $0) [options]

Create a tag on current branch (or given -b <branch>) with timestamp.
If branch doesn't exist yet, it's created. Script is made to be ececuted
standing in the directory contining the git in question. Current branch in the
git you stand in is: [$(rg.cbr.sh)]

Blank lines and remarked lines (i.e. lines starting with #) are
permitted

Options:
  -p <prefix>     Prefix string. Default is "daily"
  -n <number>     Applies specific order-number to the tag. Default is "0"
  -b <branch>     Create tag top of this branch. Default is on-top of the current.
                  If branch does not exist, create one and assume to track the
                  default remote: [${DFLT_DOTAG_TRACKING_REMOTE}]
  -r <remote>     In case branch does not exist, branch it of the following
                  remote (this could be any branch, but shoult really be your
                  "branch.integration.merge=refs/heads/<branch>" or
                  "remotes/<remote-name>/<branch>"
  -s <suffix>     Suffix to append. Default is: [${DFLT_DOTAG_SUFFIX}]
  -a <string>     Create annotated tag. <string> is the message to put in the tag
                  Default is using lightweight tags.
  -f              Force creating the tag if it exists
  -t <timestamp>  Timestamp if not today is used. Should be in the format:
                  YYYY-MM-DD.
  -y              Non interactive. Answer yes to everything.
  -h              This help

Example:
  cd mydroid/mygit
  $(basename $0) -n2 -a "This tag is annotated" -b "integration2"

EOF
}
	while getopts yr:p:n:b:s:a:t:fh OPTION; do
		case $OPTION in
		h)
			print_dotag_help $0
			exit 0
			;;
		p)
			PREFIX=$OPTARG
			;;
		n)
			NUMBER=$OPTARG
			;;
		b)
			BRANCH=$OPTARG
			;;
		s)
			SUFFIX=$OPTARG
			;;
		t)
			TIMEST=$OPTARG
			;;
		f)
			FORCED="-f"
			;;
		y)
			YES_TO_ALL="yes"
			;;
		r)
			TRACKING_REMOTE=$OPTARG
			;;
		a)
			A_MESSAGE=$OPTARG
			AMMEND="yes"
			;;
		?)
			echo "Syntax error:" 1>&2
			print_dotag_help $0 1>&2
			exit 2
			;;

		esac
	done
	shift $(($OPTIND - 1))

	PREFIX=${PREFIX-"daily"}
	NUMBER=${NUMBER-"0"}
	BRANCH=${BRANCH-$(rg.cbr.sh)}
	SUFFIX=${SUFFIX-${DFLT_DOTAG_SUFFIX}}
	FORCED=${FORCED-""}
	TIMEST=${TIMEST-$(date +"%Y.%m.%d")}
	AMMEND=${AMMEND-"no"}
	YES_TO_ALL=${YES_TO_ALL-"no"}
	A_MESSAGE=${A_MESSAGE-"empty"}
	TRACKING_REMOTE=${TRACKING_REMOTE-"${DFLT_DOTAG_TRACKING_REMOTE}"}

	if [ ! $? -eq 0 ]; then
		echo "Error: $(basenamr $0) dors not take arguments" 1>&2
		print_dotag_help $0 1>&2
		exit 2
	fi

