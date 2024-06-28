#!/usr/bin/env python3
import os
import subprocess
from collections import defaultdict
from datetime import datetime

# 获取文件列表
result = subprocess.run(
    ["fd", "--hidden", "--type", "f", ".bak", os.path.expanduser("~/.vim/backup")],
    capture_output=True,
    text=True,
)
files = result.stdout.splitlines()
if result.returncode != 0:
    print("获取文件列表失败")
    print(result.stderr)
    exit(result.returncode)

# 使用字典存储每个文件的最新版本
latest_files = defaultdict(str)

# 解析文件名和时间戳
# /root/.vim/backup/vim/root/.vim/vimrc~~2024-0627-22:14:07.bak
for file in files:
    base_name, timestamp_str = file.split("~~")

    # 比较并更新最新版本文件
    if timestamp_str > latest_files[base_name]:
        latest_files[base_name] = timestamp_str

# 删除旧版本文件
for file in files:
    base_name, timestamp_str = file.split("~~")
    if timestamp_str != latest_files[base_name]:
        print(f"删除旧版本文件: {file}")
        os.remove(file)
