#!/usr/bin/env bash
# 在目标机器本机编译（支持 ARM64），不需要 sudo 运行本脚本。
# 依赖（按系统选择）：
#   Ubuntu/Debian: sudo apt-get install build-essential pkg-config libfuse3-dev
#   openEuler/RHEL: sudo yum install gcc make pkgconf-pkg-config fuse-devel
# 不传目录：git clone 官方最新默认分支；另需 git autoconf automake libtool。
# 用法：~/vimrc/install/build_bindfs.sh [源码目录]
# 配合 ai-infra-dev：传入同步并解压后的目录，如 ~/devtools/openeuler24.03-lts-aarch64/bindfs-1.17.7
# 可选：JOBS=8 PREFIX="$HOME/.local" ~/vimrc/install/build_bindfs.sh /path/to/bindfs
# 默认安装到 ~/.local，需将 ~/.local/bin 加入 PATH；BUILD_DIR 默认 ~/build。
# 自动下载的临时源码会清理；传入目录保留（构建会在其中生成文件）。
# 不创建挂载，不修改 /etc/fuse.conf；不接受版本号参数。
set -euo pipefail

if [[ ${1:-} == -h || ${1:-} == --help ]]; then
    printf 'Usage: %s [SOURCE_DIR]\nWithout SOURCE_DIR: clone latest official default branch.\nEnvironment: PREFIX=$HOME/.local, BUILD_DIR=$HOME/build, JOBS=8\n' "$0"
    exit 0
fi
[[ $# -le 1 ]] || { echo 'error: expected at most one source directory' >&2; exit 2; }
prefix=${PREFIX:-$HOME/.local}
build_dir=${BUILD_DIR:-$HOME/build}
jobs=${JOBS:-8}
[[ $prefix == /* && $build_dir == /* ]] || { echo 'error: PREFIX and BUILD_DIR must be absolute paths' >&2; exit 2; }
[[ $jobs =~ ^[1-9][0-9]*$ ]] || { echo 'error: JOBS must be a positive integer' >&2; exit 2; }
source_dir=${1:-}
if [[ -n $source_dir ]]; then
    [[ -d $source_dir ]] || { printf 'error: source directory not found: %s\n' "$source_dir" >&2; exit 2; }
    source_dir=$(CDPATH= cd -- "$source_dir" && pwd)
fi
for command in make gcc pkg-config; do
    command -v "$command" >/dev/null || { printf 'error: missing %s\n' "$command" >&2; exit 1; }
done
if ! pkg-config --exists 'fuse3 >= 3.0' && ! pkg-config --exists 'fuse >= 2.8'; then
    printf '%s\n' 'error: FUSE development library required.' \
        'Ubuntu/Debian: sudo apt-get install build-essential pkg-config libfuse3-dev' \
        'openEuler/RHEL: sudo yum install gcc make pkgconf-pkg-config fuse-devel' >&2
    exit 1
fi

if [[ -z $source_dir ]]; then
    command -v git >/dev/null || { echo 'error: git is required for downloading source' >&2; exit 1; }
    mkdir -p -- "$build_dir"
    work=$(mktemp -d "$build_dir/bindfs.XXXXXX")
    trap 'rm -rf -- "$work"' EXIT
    source_dir="$work/bindfs"
    git clone --depth=1 https://github.com/mpartel/bindfs.git "$source_dir"
fi
cd -- "$source_dir"
if [[ ! -f configure ]]; then
    [[ -f autogen.sh ]] || { echo 'error: source lacks configure and autogen.sh' >&2; exit 1; }
    for command in autoreconf automake libtoolize; do
        command -v "$command" >/dev/null || { printf 'error: missing %s; install autoconf automake libtool\n' "$command" >&2; exit 1; }
    done
    sh autogen.sh
fi
printf 'Build bindfs from %s; prefix=%s; jobs=%s\n' "$source_dir" "$prefix" "$jobs"
./configure --prefix="$prefix"
make -j"$jobs"
make install
"$prefix/bin/bindfs" --version
printf 'Installed: %s/bin/bindfs\nEnsure %s/bin is in PATH.\n' "$prefix" "$prefix"
