#!/bin/bash
# Linux network namespace + iptables + dnsmasq 实现轻量级网络隔离空间

# ==================== 可配置变量 ====================
# 网络命名空间名称
NETNS_NAME="myns"

# 虚拟网卡对名称
VETH_HOST="veth-host"
VETH_GUEST="veth-guest"

# 网络配置
NETNS_IP="192.168.100.2"
HOST_IP="192.168.100.1"
SUBNET="192.168.100.0/24"

# 主机外网接口（根据实际情况修改）
WAN_INTERFACE="eth0"

# DNS 配置。可以通过cat /etc/resolv.conf查看当前系统的DNS服务器。127.0.0.53是阿里云服务器的DNS配置。
DNS_SERVER="127.0.0.53"
DNS_LISTEN_IP="$HOST_IP"

# 可以使用`dig +short baidu.com qq.com`获取域名对应的IP
# 黑名单IP（空格分隔）
BLACKLIST_IPS="1.1.1.1 8.8.8.8"

# 白名单IP（空格分隔，如果使用白名单模式）
WHITELIST_IPS="20.205.243.166 140.82.121.3" # example.com, github.com

# 日志文件
DNSMASQ_LOG="/var/log/dnsmasq.${NETNS_NAME}.log"

# ==================== 函数定义 ====================

function setup_netns() {
    echo "设置网络命名空间: $NETNS_NAME"

    # 清理可能存在的旧配置
    cleanup_netns 2>/dev/null

    # 初始化网络命名空间和虚拟网卡
    ip netns add "$NETNS_NAME"
    ip link add "$VETH_HOST" type veth peer name "$VETH_GUEST"
    ip link set "$VETH_GUEST" netns "$NETNS_NAME"

    # 配置隔离空间网络
    ip netns exec "$NETNS_NAME" ip addr add "${NETNS_IP}/24" dev "$VETH_GUEST"
    ip netns exec "$NETNS_NAME" ip link set "$VETH_GUEST" up
    ip netns exec "$NETNS_NAME" ip route add default via "$HOST_IP"

    # 配置主机端网络
    ip addr add "${HOST_IP}/24" dev "$VETH_HOST"
    ip link set "$VETH_HOST" up

    # 开启转发和 NAT
    sysctl -w net.ipv4.ip_forward=1
    iptables -t nat -A POSTROUTING -s "$SUBNET" -o "$WAN_INTERFACE" -j MASQUERADE

    # 转发规则
    iptables -I FORWARD -i "$VETH_HOST" -o "$WAN_INTERFACE" -j ACCEPT
    iptables -I FORWARD -i "$WAN_INTERFACE" -o "$VETH_HOST" -m state --state RELATED,ESTABLISHED -j ACCEPT

    # DNS 端口允许规则
    iptables -I INPUT -i "$VETH_HOST" -p udp --dport 53 -j ACCEPT
    iptables -I INPUT -i "$VETH_HOST" -p tcp --dport 53 -j ACCEPT

    echo "网络命名空间 '$NETNS_NAME' 设置完成"
}

function setup_dns_server() {
    echo "设置DNS服务器..."

    # 创建网络命名空间的resolv.conf目录和文件
    mkdir -p "/etc/netns/${NETNS_NAME}/"
    cat > "/etc/netns/${NETNS_NAME}/resolv.conf" << EOF
nameserver $DNS_LISTEN_IP
options edns0 trust-ad
search .
EOF

    # 创建dnsmasq配置
    cat > "/etc/dnsmasq.${NETNS_NAME}.conf" << EOF
# 监听虚拟接口
interface=$VETH_HOST
except-interface=lo
bind-interfaces

# DNS转发配置
no-hosts
read-ethers
server=$DNS_SERVER

## 日志配置
# 记录所有 DNS 查询
log-queries
# 指定日志文件
log-facility=$DNSMASQ_LOG

# address: dnsmasq将匹配的域名解析到指定IP
# server: dnsmasq将匹配的域名转发到指定DNS服务器
# 因此address和server分别用于黑名单和白名单配置
# ==================== 黑名单域名 ====================
# 以下域名将被解析到 0.0.0.0（拒绝访问）
# ip netns exec $NETNS_NAME dig +short github.com 返回0.0.0.0
address=/.doubleclick.net/0.0.0.0
address=/.googleadservices.com/0.0.0.0
address=/.adserver.com/0.0.0.0
address=/.tracking-domain.com/0.0.0.0
address=/.facebook.com/0.0.0.0
# 匹配所有twitter.com，api.twitter.com，foo.bar.twitter.com等一级、二级、多级域名
address=/.twitter.com/0.0.0.0
# 通配符屏蔽整个域名家族
address=/.ad./0.0.0.0
address=/.track./0.0.0.0
address=/.qq.com/0.0.0.0

# ==================== 白名单域名 ====================
# 以下域名将正常解析（允许访问）
server=/.google.com/${DNS_SERVER}
server=/.github.com/${DNS_SERVER}
server=/.stackoverflow.com/${DNS_SERVER}
server=/.wikipedia.org/${DNS_SERVER}
server=/.docker.com/${DNS_SERVER}
server=/.npmjs.com/${DNS_SERVER}
server=/.python.org/${DNS_SERVER}
server=/.ubuntu.com/${DNS_SERVER}

# ==================== 默认行为开关 ====================
# 重要：取消下面这行的注释来启用严格模式（拒绝所有未匹配域名）
# 保持注释则使用宽松模式（允许所有未匹配域名）

# no-resolv            # 不读取系统默认DNS配置
# address=/#/0.0.0.0   # 默认拒绝所有域名
EOF

    echo "DNS服务器配置完成"
}

function restart_dnsmasq() {
    echo "重启dnsmasq..."
    # -f是进程full name匹配
    pkill -f "dnsmasq.*${NETNS_NAME}"
    sleep 1
    start_dnsmasq
}

function start_dnsmasq() {
    echo "启动dnsmasq..."
    # 检查是否已在运行
    # -f是进程full name匹配
    if pgrep -f "dnsmasq.*${NETNS_NAME}" > /dev/null; then
        echo "dnsmasq已经在运行"
        return
    fi

    dnsmasq -C "/etc/dnsmasq.${NETNS_NAME}.conf"
    echo "dnsmasq启动完成"
}

function setup_myns_blacklist() {
    echo "设置黑名单规则..."

    # 清空现有的OUTPUT链规则
    ip netns exec "$NETNS_NAME" iptables -F OUTPUT 2>/dev/null

    # 设置默认策略为ACCEPT
    ip netns exec "$NETNS_NAME" iptables -P OUTPUT ACCEPT

    # 添加黑名单规则
    for ip in $BLACKLIST_IPS; do
        ip netns exec "$NETNS_NAME" iptables -A OUTPUT -d "$ip" -j DROP
        echo "已屏蔽: $ip"
    done

    echo "黑名单规则设置完成"
}

function setup_myns_whitelist() {
    echo "设置白名单规则..."

    # 清空现有的OUTPUT链规则
    ip netns exec "$NETNS_NAME" iptables -F OUTPUT 2>/dev/null

    # 设置默认策略为DROP（严格模式）
    ip netns exec "$NETNS_NAME" iptables -P OUTPUT DROP

    # 允许本地回环
    ip netns exec "$NETNS_NAME" iptables -A OUTPUT -o lo -j ACCEPT

    # 允许DNS查询
    ip netns exec "$NETNS_NAME" iptables -A OUTPUT -p udp --dport 53 -j ACCEPT

    # 允许访问网关（用于DNS）
    ip netns exec "$NETNS_NAME" iptables -A OUTPUT -d "$HOST_IP" -j ACCEPT

    # 添加白名单规则
    for ip in $WHITELIST_IPS; do
        ip netns exec "$NETNS_NAME" iptables -A OUTPUT -d "$ip" -j ACCEPT
        echo "已允许: $ip"
    done

    # 允许已建立的连接返回
    ip netns exec "$NETNS_NAME" iptables -A OUTPUT -m state --state RELATED,ESTABLISHED -j ACCEPT

    echo "白名单规则设置完成"
}

function enter_netns() {
    echo "进入网络命名空间: $NETNS_NAME"
    ip netns exec "$NETNS_NAME" bash
}

function cleanup_netns() {
    echo "清理网络命名空间: $NETNS_NAME"

    # 删除网络命名空间（会自动删除内部的虚拟网卡）
    ip netns del "$NETNS_NAME" 2>/dev/null

    # 删除主机上的虚拟网卡
    ip link del "$VETH_HOST" 2>/dev/null

    # 删除NAT规则
    iptables -t nat -D POSTROUTING -s "$SUBNET" -o "$WAN_INTERFACE" -j MASQUERADE 2>/dev/null

    # 删除FORWARD规则
    iptables -D FORWARD -i "$VETH_HOST" -o "$WAN_INTERFACE" -j ACCEPT 2>/dev/null
    iptables -D FORWARD -i "$WAN_INTERFACE" -o "$VETH_HOST" -m state --state RELATED,ESTABLISHED -j ACCEPT 2>/dev/null

    # 删除INPUT规则
    iptables -D INPUT -i "$VETH_HOST" -p udp --dport 53 -j ACCEPT 2>/dev/null
    iptables -D INPUT -i "$VETH_HOST" -p tcp --dport 53 -j ACCEPT 2>/dev/null

    # 停止dnsmasq
    pkill -f "dnsmasq.*${NETNS_NAME}"

    echo "清理完成"
}

function show_status() {
    echo "=== 网络命名空间状态 ==="
    ip netns list
    echo ""

    echo "=== 虚拟网卡状态 ==="
    ip link show "$VETH_HOST" 2>/dev/null || echo "虚拟网卡 $VETH_HOST 不存在"
    echo ""

    echo "=== iptables规则 ==="
    iptables -L FORWARD -n -v --line-numbers | grep -E "(veth|${HOST_IP})"
    echo ""

    echo "=== dnsmasq进程 ==="
    pgrep -af "dnsmasq.*${NETNS_NAME}" || echo "dnsmasq未运行"
}

function show_usage() {
    echo "用法: $0 [选项]"
    echo "选项:"
    echo "  setup            设置网络命名空间和基本配置"
    echo "  dns-start        设置并启动DNS服务器"
    echo "  dns-restart      重启DNS服务器"
    echo "  blacklist        设置${NETNS_NAME}中的黑名单规则"
    echo "  whitelist        设置${NETNS_NAME}中的白名单规则"
    echo "  enter            进入网络命名空间"
    echo "  status           显示当前状态"
    echo "  cleanup          清理所有配置"
    echo "  all              执行完整设置（setup + dns）"
    echo "  help             显示帮助信息"
    echo ""
    echo "示例:"
    echo "  $0 setup       # 只设置网络"
    echo "  $0 all         # 完整设置"
    echo "  $0 enter       # 进入命名空间"
}

# ==================== 主程序 ====================

case "${1:-help}" in
    "setup")
        setup_netns
        ;;
    "dns-start")
        setup_dns_server
        start_dnsmasq
        ;;
    "dns-restart")
        restart_dnsmasq
        ;;
    "blacklist")
        setup_myns_blacklist
        ;;
    "whitelist")
        setup_myns_whitelist
        ;;
    "enter")
        enter_netns
        ;;
    "status")
        show_status
        ;;
    "cleanup")
        cleanup_netns
        ;;
    "all")
        setup_netns
        setup_dns_server
        start_dnsmasq
        echo "完整设置完成！使用 '$0 enter' 进入网络命名空间"
        ;;
    "help"|*)
        show_usage
        ;;
esac
