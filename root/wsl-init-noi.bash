export DOC2=/mnt/d/doc2
export PATH="$DOC2/chunqiu/daily-app:$PATH"
alias start='cmd.exe /C start ""'

# experimental feature, See: https://github.com/jiangyinzuo/dblp-api dev branch
alias dblp="python3 ~/dblp-api/main.py"

# cmd.exe /c mklink /d parameter_server  "D:\doc2\cs\aisys\parameter_server"
mklinkd() {
	if [ $# -eq 2 ]; then
		target=$2
		target=${target/\/mnt\/d/D:}
		target=${target//\//\\}
		echo 'create link: ' $1 ' target: ' $target
		cmd.exe /c mklink /d $1 $target
	elif [ $# -eq 1 ]; then
		# mklinkd /mnt/d/doc2/cs/aisys
		target=$1
		link=${target##*/} # link = "aisys"
		target=${target/\/mnt\/d/D:}
		echo $target
		target=${target//\//\\}
		echo 'create link: ' $link ' target: ' $target
		cmd.exe /c mklink /d $link $target
	fi
}

mklink() {
	if [ $# -eq 2 ]; then
		target=$2
		target=${target/\/mnt\/d/D:}
		target=${target//\//\\}
		echo 'create link: ' $1 ' target: ' $target
		cmd.exe /c mklink $1 $target
	elif [ $# -eq 1 ]; then
		# mklinkd /mnt/d/doc2/cs/aisys
		target=$1
		link=${target##*/} # link = "aisys"
		target=${target/\/mnt\/d/D:}
		echo $target
		target=${target//\//\\}
		echo 'create link: ' $link ' target: ' $target
		cmd.exe /c mklink $link $target
	fi
}

