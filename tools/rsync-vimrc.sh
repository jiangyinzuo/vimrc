direction=$1
shift

_help() {
	echo "Usage: $0 from|to <user@host> [-f]"
	exit 1
}

_git_worktree_origin_dir() {
	gitdir=$(git rev-parse --git-dir)
	if [[ "$gitdir" == '.git' ]]; then
		echo "not in worktree"
		exit 1
	fi
	# /root/vimrc/.git/worktrees/vimrc-kiwi -> /root/vimrc
	# 去掉.git/worktrees及其后面的内容
	origin_dir=$(echo $gitdir | sed 's/\.git\/worktrees\/.*//')
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

# 获取当前脚本所在git仓库的根目录
worktree_dir=$(git rev-parse --show-toplevel)
worktree_basename=$(basename $worktree_dir)
echo "worktree_dir: $worktree_dir"
cd $worktree_dir
_git_worktree_origin_dir
echo "origin_dir: $origin_dir"

case $direction in
	"to")
		# 在远程主机上执行checkrepo.py脚本，若返回非0值，则退出
		ssh $host "python3 ~/vimrc/root/scripts/checkrepo.py safersync --repo $worktree_dir"
		# 如果没有指定-f参数，且返回非0值，则退出
		if [[ $? -ne 0 && "$force" != '-f' ]]; then
			echo -e "\033[31mcheckrepo.py failed\033[0m"
			exit 1
		fi
		rsync-git $worktree_dir/ $host:~/$worktree_basename
		rsync-git $origin_dir $host:~/vimrc
		;;
	"from")
		# 在本地主机上执行checkrepo.py脚本，若返回非0值，则退出
		python3 ~/vimrc/root/scripts/checkrepo.py safersync --repo $worktree_dir
		# 如果没有指定-f参数，且返回非0值，则退出
		if [[ $? -ne 0 && "$force" != '-f' ]]; then
			echo -e "\033[31mcheckrepo.py failed\033[0m"
			exit 1
		fi
		rsync-git $host:~/$worktree_basename/ $worktree_dir/
		;;
	*)
		_help
		;;
esac
