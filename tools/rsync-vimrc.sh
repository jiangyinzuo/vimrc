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
		# 在远程主机上执行checkrepo.py脚本，若返回非0值，则退出
		# ssh $1 "python3 ~/vimrc/root/scripts/checkrepo.py ~/vimrc"
		if [ $? -ne 0 ]; then
			echo "checkrepo.py failed"
			exit 1
		fi
		rsync-git . $1:~/vimrc
		;;
	"from")
		# 在本地主机上执行checkrepo.py脚本，若返回非0值，则退出
		python3 ~/vimrc/root/scripts/checkrepo.py ~/vimrc
		if [ $? -ne 0 ]; then
			echo "checkrepo.py failed"
			exit 1
		fi
		rsync-git $1:~/vimrc ~
		;;
	*)
		_help
		;;
esac
