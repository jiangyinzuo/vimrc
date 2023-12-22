direction=$1
shift

_help() {
	echo "Usage: $0 from|to <user@host>"
	exit 1
}

if [ -z "$1" ]; then
	_help
fi

case $direction in
	"to")
		rsync-git . $1:~/vimrc
		;;
	"from")
		rsync-git $1:~/vimrc .
		;;
	*)
		_help
		;;
esac
