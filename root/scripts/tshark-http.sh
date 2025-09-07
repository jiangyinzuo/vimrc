# 使用 tshark 同时捕获 HTTP Host 和 TLS SNI
# -i需要设置为正确的网络接口，可以通过`ip a`命令查看
tshark -i eth0 \
  -f "tcp port 80 or tcp port 443" \
  -Y "http" \
  -T fields \
  -e frame.time \
  -e ip.src \
  -e ip.dst \
  -e http.host \
  -e http.request.method \
  -e http.request.uri \
  -e http.response.code
