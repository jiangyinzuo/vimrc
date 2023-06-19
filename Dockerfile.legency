FROM ubuntu:22.04

ENV PATH /node/bin:$PATH

ADD myvim.tar /
RUN apt clean && \
	sed -i s@/archive.ubuntu.com/@/mirrors.ustc.edu.cn/@g /etc/apt/sources.list && \
	sed -i s@/security.ubuntu.com/@/mirrors.ustc.edu.cn/@g /etc/apt/sources.list && \
	apt update && apt install vim git g++ cmake ripgrep python3 clangd -y

