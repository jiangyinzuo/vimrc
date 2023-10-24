apt install wslu -y
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
