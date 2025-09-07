```bash```
# 后台启动
docker-compose up -d
# 查看网络
docker network ls
# 查看网络详情
docker network inspect app-with-firewall_app-network
# 查看dnsmasq日志
docker exec -it dns-proxy less /var/log/dnsmasq.log
# 停止
docker-compose down
```
