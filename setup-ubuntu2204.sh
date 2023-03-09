#!/bin/bash

apt install -y npm
npm install -g n
n latest

apt install -y ripgrep fzf fd-find tree bat clangd
