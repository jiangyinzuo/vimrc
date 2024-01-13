import subprocess

def get_ubuntu_version() -> float:
    """通过 lsb_release 命令获取 Ubuntu 版本号"""
    try:
        output = subprocess.check_output(["lsb_release", "-rs"], text=True)
        return float(output.strip())
    except subprocess.CalledProcessError:
        print("无法获取 Ubuntu 版本号")
        return 0

# 获取当前 Ubuntu 版本号
current_version = get_ubuntu_version()

if current_version:
    print(f"当前 Ubuntu 版本号为: {current_version}")

if current_version <= 18.04:
    print("""
    ripgrep:
    请前往 https://github.com/BurntSushi/ripgrep/releases 下载对应版本的 ripgrep deb package (14.1.0可用)
    运行 sudo dpkg -i <package_name>.deb 安装 ripgrep
    """)
else:
    print("""
    ripgrep:
    sudo apt-get install ripgrep
    """)
