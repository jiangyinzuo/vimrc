#!/bin/bash

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# 或者npm install tree-sitter-cli
cargo install --locked tree-sitter-cli
cargo install ripgrep --features 'pcre2'
cargo install fd-find
cargo install git-delta
cargo install stylua
cargo install yazi-build
# 日志查看器
curl -fsSL https://github.com/pauloremoli/logana/releases/latest/download/logana-installer.sh
