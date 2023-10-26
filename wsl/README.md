# WSL设置

Windows矢量图画图软件: draw.io

## 设置Windows浏览器为WSL2浏览器

如何让Windows下的浏览器成为wsl2的默认浏览器 - 顾源源童鞋的文章 - 知乎
https://zhuanlan.zhihu.com/p/136108063

评论
```
其实是有专用的命令更改默认浏览器的，即update-alternatives,
采用楼主的命令，建立在/usr/bin/msedge 这个可执行文件
sudo ln /mnt/c/Program\ Files\ \(x86\)/Microsoft/Edge/Application/msedge.exe msedge -s 把msedge 加入到浏览器的备选行
sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /usr/bin/msedge 200然后进行切换，选择对应msedge的数字（由于我设置的优先级比原始的高，所以不用这一步也可以）
sudo update-alternatives --config x-www-browse选择对应的msedge以就可以了
```

```
(base) root@DESKTOP-TI1H94P:/usr/bin# ll x-www-browser
lrwxrwxrwx 1 root root 31 Jan 22  2023 x-www-browser -> /etc/alternatives/x-www-browser*
(base) root@DESKTOP-TI1H94P:/etc/alternatives# ll x-www-browser
lrwxrwxrwx 1 root root 63 Feb 10  2023 x-www-browser -> '/mnt/c/Program Files (x86)/Google/Chrome/Application/chrome.exe'*
```

