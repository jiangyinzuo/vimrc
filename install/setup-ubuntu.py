import subprocess
import os


def get_ubuntu_code_name() -> str:
    return subprocess.check_output(["lsb_release", "-rs"], text=True)


def get_ubuntu_version() -> float:
    """通过 lsb_release 命令获取 Ubuntu 版本号"""
    try:
        output = subprocess.check_output(["lsb_release", "-rs"], text=True)
        return float(output.strip())
    except subprocess.CalledProcessError:
        print("无法获取 Ubuntu 版本号")
        return 0


ubuntu_version = get_ubuntu_version()
code_name = get_ubuntu_code_name()

print(f"当前 Ubuntu 版本号为: {ubuntu_version}, code name为: {code_name}")

apt_install_list = [
    'tree bat git cmake sqlformat python3-dev python3-distutils wamerican',
]

if ubuntu_version <= 18.04:
    print("""
    ripgrep:
    请前往 https://github.com/BurntSushi/ripgrep/releases 下载对应版本的 ripgrep deb package (14.1.0可用)
    运行 sudo dpkg -i <package_name>.deb 安装 ripgrep
    fd:
    请前往 https://github.com/sharkdp/fd/releases/download/v9.0.0/fd-musl_9.0.0_amd64.deb 下载对应musl版本的 fd deb package, musl代表不依赖 glibc (9.0.0可用)
    运行 sudo dpkg -i <package_name>.deb 安装 fd
    """)
else:
    apt_install_list += ['ripgrep', 'fd-find', 'neovim']

os.system(f'apt install {" ".join(apt_install_list)}')
