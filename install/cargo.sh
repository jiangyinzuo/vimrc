#!/bin/bash

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

cargo install ripgrep --features 'pcre2'
cargo install fd-find
cargo install git-delta
cargo install stylua
