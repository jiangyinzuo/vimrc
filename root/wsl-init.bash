#!/bin/bash

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
