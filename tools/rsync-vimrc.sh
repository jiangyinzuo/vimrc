direction=$1
shift

_help() {
	echo "Usage: $0 from|to <user@host> [-f]"
	exit 1
}

host=$1
if [ -z "$host" ]; then
	_help
fi

shift
case $1 in
	-f)
		force="-f"
		;;
	*)
		force=""
		;;
esac

case $direction in
	"to")
		# 在远程主机上执行checkrepo.py脚本，若返回非0值，则退出
		ssh $host "python3 ~/vimrc/root/scripts/checkrepo.py ~/vimrc"
		# 如果没有指定-f参数，且返回非0值，则退出
		if [[ $? -ne 0 && "$force" != '-f' ]]; then
			echo -e "\033[31mcheckrepo.py failed\033[0m"
			exit 1
		fi
		rsync-git . $host:~/vimrc
		;;
	"from")
		# 在本地主机上执行checkrepo.py脚本，若返回非0值，则退出
		python3 ~/vimrc/root/scripts/checkrepo.py ~/vimrc
		# 如果没有指定-f参数，且返回非0值，则退出
		if [[ $? -ne 0 && "$force" != '-f' ]]; then
			echo -e "\033[31mcheckrepo.py failed\033[0m"
			exit 1
		fi
		rsync-git $host:~/vimrc ~
		;;
	*)
		_help
		;;
esac
