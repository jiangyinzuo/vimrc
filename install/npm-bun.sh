npm config set registry https://r.cnpmjs.org
npm install -g @anthropic-ai/claude-code @zed-industries/claude-code-acp
# npm安装需要高版本glibc
# 或者cargo install --locked tree-sitter-cli
npm install tree-sitter-cli
npm install -g --ignore-scripts @earendil-works/pi-coding-agent
npm install -g bun
bun install -g @oh-my-pi/pi-coding-agent
# omp会自动画图表，为了正确显示omp自动画的图表，需要安装fonts-noto-cjk
sudo apt-get install fonts-noto-cjk
fc-cache -f
