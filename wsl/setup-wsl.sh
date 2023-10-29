DIR="$(dirname "$0")"

# 会自动添加wslview.desktop
# 每日提醒脚本依赖at
apt install wslu at -y
xdg-settings set default-web-browser wslview.desktop

# 添加start.desktop，可以直接用xdg-open或者vim gx快捷键打开文件
# pdf使用Windows的默认程序打开
# svg使用Windows的默认程序打开(请在windows中安装draw.io)
cat > /usr/share/applications/start.desktop <<EOF
[Desktop Entry]
Name=start
GenericName=start
Comment=start
Exec=cmd.exe /C start %U
Terminal=false
Type=Application
MimeType=application/pdf;application/x-pdf;application/x-gzpdf;application/x-bzpdf;application/x-xzpdf;application/x-lzpdf;image/svg+xml;
Categories=Viewer;Graphics;
Keywords=Viewer;Graphics;
EOF

# PPTX让Windows的默认程序打开
xdg-mime default start.desktop application/vnd.openxmlformats-officedocument.presentationml.presentation
# SVG让Windows的默认程序打开
xdg-mime default start.desktop image/svg+xml

cp $DIR/convert-pptx.ps1 /mnt/d/convert-pptx.ps1

########### CRON JOB ###########
# 每隔2小时删除/tmp/reminder_done
CRON_JOB="0 */2 * * * rm /tmp/reminder_done"

# 检查该cron任务是否已经存在
crontab -l | grep -q "/tmp/reminder_done"

# $? 是上一条命令的退出状态。如果grep找到了匹配行，退出状态是0。
if [ $? -eq 0 ]; then
	echo "Cron job already exists."
else
	(crontab -l ; echo "0 */2 * * * rm /tmp/reminder_done") | crontab -
	echo "Cron job added."
fi
#################################
