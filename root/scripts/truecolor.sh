#!/bin/bash
# test true color support in terminal
for i in {0..255}; do
    r=$((i * 255 / 255))
    g=$(((255 - i) * 255 / 255))
    b=200
    printf "\e[38;2;%d;%d;%dm█" $r $g $b
done
printf "\e[0m\n"
