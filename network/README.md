## 基于Linux network namespace的网络隔离(netns.sh)

基于Linux network namespace + iptables + dnsmasq（DNS代理服务器）实现轻量级网络隔离空间。

iptables 规则本身是与网络命名空间绑定的。每个网络命名空间都有自己的独立规则表。

`iptables -L` 查看当前命名空间的防火墙规则。

网络拓扑图
```
+---------------------------------------------------------------+
|                        Linux 宿主机                           |
|                                                               |
|  +------------------------+    +--------------------------+   |
|  |  默认网络命名空间      |    |  隔离网络命名空间 (myns) |   |
|  |  (main netns)          |    |                          |   |
|  |                        |    |                          |   |
|  |  +------------------+  |    |  +------------------+    |   |
|  |  |    eth0          |  |    |  |   veth-guest     |    |   |
|  |  |  (外网接口)      |  |    |  |  192.168.100.2/24|    |   |
|  |  |                  |  |    |  |                  |    |   |
|  |  +------------------+  |    |  +------------------+    |   |
|  |          |             |    |          |               |   |
|  |  +------------------+  |    |  +-------------------+   |   |
|  |  |   veth-host      |  |    |  |  iptables OUTPUT  |   |   |
|  |  |  192.168.100.1/24|  |    |  |   -d 1.1.1.1 DROP |   |   |
|  |  +------------------+  |    |  |   -d 8.8.8.8 DROP |   |   |
|  |          |             |    |  |     黑名单IP      |   |   |
|  |          |             |    |  +-------+-----------+   |   |
|  |          |             |    |          |               |   |
|  |          |             +----+----------+---------------+   |
|  |          |                             |               |   |
|  |          +-----------------------------+               |   |
|  |                 虚拟网卡对 (veth pair)                 |   |
|  |                                                        |   |
|  |  +------------------------+                            |   |
|  |  |   dnsmasq              |                            |   |
|  |  |  监听:192.168.100.1:53 |                            |   |
|  |  |  上游:127.0.0.53       |                            |   |
|  |  +------------------------+                            |   |
|  |                                                        |   |
|  |  主机iptables规则:                                     |   |
|  |  - NAT MASQUERADE                                      |   |
|  |  - FORWARD 允许转发                                    |   |
|  |  - INPUT 允许DNS查询                                   |   |
|  +--------------------------------------------------------+   |
|            |                                                  |
|            |                                                  |
+------------|--------------------------------------------------+
             |
             |
        +----+----+
        |  互联网 |
        +---------+
```

### 数据流说明

出站流量：

    myns内进程 → veth-guest → veth-host → iptables FORWARD → eth0 → 互联网

入站流量：

    互联网 → eth0 → iptables FORWARD → veth-host → veth-guest → myns内进程

DNS查询：

    myns内进程 → veth-guest → veth-host → dnsmasq(192.168.100.1:53) → 127.0.0.53 → 返回结果

黑名单阻挡：

    myns内进程 → 尝试访问1.1.1.1 → myns内iptables OUTPUT链 → DROP

### 为什么不需要网桥

网桥是一个数据链路层（OSI第2层） 的设备，它在不同的网络段之间转发帧（Frame）。在Linux中，网桥的本质是一个虚拟交换机，它的核心价值在于：

- 在数据链路层连接多个网络段
- 通过MAC地址学习实现智能转发
- 提供二层网络隔离和管理功能

```
+------------------------------------------------------+
|                   Linux网桥                          |
|                  (br0)                               |
|                                                      |
|  +----------------+                                  |
|  | MAC地址学习表  |                                  |
|  | MAC-A -> port1 |                                  |
|  | MAC-B -> port2 |                                  |
|  | MAC-C -> port3 |                                  |
|  +----------------+                                  |
|         |            |            |            |     |
|     +-------+    +-------+    +-------+    +-------+ |
|     | port1 |    | port2 |    | port3 |    | port4 | |
|     +-------+    +-------+    +-------+    +-------+ |
|         |            |            |            |     |
|      veth1        veth2        veth3         eth0    |
|     (容器A)       (容器B)       (容器C)    (物理网卡)|
+------------------------------------------------------+
```

#### 工作流程

**MAC地址学习：**

当数据帧从某个端口进入时，网桥记录源MAC地址和端口的对应关系

例如：从port1收到源MAC为AA:BB:CC:DD:EE:FF的帧，就在表中记录 AA:BB:CC:DD:EE:FF -> port1

**帧转发决策：**

已知单播帧：如果目标MAC在表中，只转发到对应端口

未知单播帧：泛洪到所有其他端口（除接收端口外）

广播/组播帧：泛洪到所有其他端口

**环路防止：**

使用STP（生成树协议）防止网络环路

阻塞某些端口以确保无环拓扑

#### 网桥的主要作用

1. 网络分段和隔离

```bash
# 创建多个网桥实现VLAN隔离
brctl addbr br-vlan10
brctl addbr br-vlan20
# 不同网桥上的设备在二层隔离
```

2. 容器网络互联
```bash
# Docker默认使用docker0网桥
docker run -d --name container1 nginx
docker run -d --name container2 nginx
# 两个容器通过docker0网桥可以相互通信
```

3. 虚拟网络扩展
```bash
# 将物理网卡加入网桥
brctl addif br0 eth0
# 现在所有连接到br0的设备都可以通过eth0访问外网
```

4. 流量监控和管理
```bash
# 可以在网桥端口上设置流量控制
tc qdisc add dev veth0 root tbf rate 1mbit burst 32kbit latency 400ms
```

#### 小结

如果需要多个隔离环境（如多个docker容器）相互通信 → 选择网桥方案

如果只需要单个隔离环境访问外网 → 选择veth方案（更简单高效）

如果需要二层网络特性（VLAN、MAC过滤等） → 选择网桥方案

如果追求最小性能开销和简单性 → 选择veth方案

## 获取域名对应的IP

```bash
dig +short baidu.com qq.com
```

## 基于Docker容器的网络隔离

### 方案一：应用容器内iptables

启动容器时需要增加两个capabilities：

- NET_ADMIN: 防火墙，可以用iptables
- NET_RAW: 原始套接字，可以用ping

```bash
docker run -it --name isolated-container --cap-add=NET_ADMIN --cap-add=NET_RAW --privileged ubuntu bash
```

进入容器后通过`iptables -L`，可以看到容器内的iptables规则较宿主机不同，是独立的。

添加黑名单IP：

```bash
# 清空OUTPUT链
iptables -F OUTPUT
# 默认允许所有出站流量
iptables -P OUTPUT ACCEPT
# 阻挡8.8.8.8
iptables -A OUTPUT -d 8.8.8.8 -j DROP
```

添加白名单IP：

```bash
# 清空OUTPUT链
iptables -F OUTPUT
# 默认阻挡所有出站流量
iptables -P OUTPUT DROP
# 允许访问本地回环接口
iptables -A OUTPUT -o lo -j ACCEPT
# 允许DNS查询
iptables -A OUTPUT -p udp --dport 53 -j ACCEPT
# 允许访问 8.8.8.8
iptables -A OUTPUT -d 8.8.8.8 -j ACCEPT
```

### 方案二：宿主机HTTP proxy server / DNS server

#### 宿主机HTTP proxy server（不推荐）

```bash
docker run -it --rm   -e http_proxy="http://172.17.0.1:3128"   -e https_proxy="http://172.17.0.1:3128"   -e HTTP_PROXY="http://172.17.0.1:3128"   -e HTTPS_PROXY="http://172.17.0.1:3128"   -e no_proxy="localhost,127.0.0.1,.local"   -e NO_PROXY="localhost,127.0.0.1,.local"   alpine wget -O- http://example.com
```

部分程序可能不支持`http_proxy`环境变量，需要单独配置，比较麻烦。

#### 宿主机DNS server（不推荐）

docker0网桥的IP地址通常是 `172.17.0.1`，可以通过`ip addr show docker0` 查看。

```
root@iZbp1d879slg73e0i9v3oqZ:~# ip addr show docker0
3: docker0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP group default
    link/ether 02:42:34:dc:fe:bc brd ff:ff:ff:ff:ff:ff
    inet 172.17.0.1/16 brd 172.17.255.255 scope global docker0
       valid_lft forever preferred_lft forever
    inet6 fe80::42:34ff:fedc:febc/64 scope link
       valid_lft forever preferred_lft forever
```

不推荐宿主机另起DNS server，因为53端口可能被占用。Docker容器指定 `--dns`仅仅是指定容器内 `/etc/resolv.conf` 的 `nameserver`，而`/etc/resolv.conf`无法指定默认端口号。

```
root@iZbp1d879slg73e0i9v3oqZ:~# docker run -it --name isolated-container2 --rm --dns 172.17.0.1 docker.m.daocloud.io/alpine nslookup -port=5353 github.com
Server:         172.17.0.1
Address:        172.17.0.1:5353

Non-authoritative answer:
Name:   github.com
Address: 20.205.243.166

Non-authoritative answer:

root@iZbp1d879slg73e0i9v3oqZ:~# docker run -it --name isolated-container2 --rm --dns 172.17.0.1 docker.m.daocloud.io/alpine cat /etc/resolv.conf
# Generated by Docker Engine.
# This file can be edited; Docker Engine will not make further changes once it
# has been modified.

nameserver 172.17.0.1
search .

# Based on host file: '/run/systemd/resolve/resolv.conf' (legacy)
# Overrides: [nameservers]
```

### 方案三：Docker Compose 应用容器 + sidecar容器（DNS server）

HTTP Proxy server因为需要配置环境变量，且部分程序不支持，不推荐使用。

见 `sidecar-dns-proxy/` 目录。
