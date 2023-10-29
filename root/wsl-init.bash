#!/bin/bash

export DOC2=/mnt/d/doc2
export CODE_HOME=~
echo -e "forget?? run \033[32mforget\033[0m"
# echo ''
# echo 'Database and CLI is Way of Life!' # https://wayoflifeapp.com/
# echo ''

alias start='cmd.exe /C start ""'

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

# 检查是否是今天第一次启动shell
if [ ! -f /tmp/reminder_done ]; then
	# 执行脚本
	$VIMRC_ROOT/scripts/forget
	# 创建一个标记文件，表示今天已经提醒过了
	touch /tmp/reminder_done
	# 设置该文件在次日0点自动删除
	at midnight -f "rm /tmp/reminder_done" 2>/dev/null
fi

######################### Clash Proxy ########################
clashproxy() {
	if [[ $1 == 'on' ]]; then
		# Clash for Windows, WSL2走Clash代理
		# 配置Clash: 找到General > Allow LAN，打开开关。
		# https://wph.im/199.html
		hostip=$(cat /etc/resolv.conf |grep -oP '(?<=nameserver\ ).*')
		( 
			set -x
			export https_proxy="http://${hostip}:7890"
			export http_proxy="http://${hostip}:7890"
			export all_proxy="socks5://${hostip}:7890"
		)
	else
		(
			set -x
			unset https_proxy
			unset http_proxy
			unset all_proxy
		)
	fi
}
##############################################################
