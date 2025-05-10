#!/bin/bash

echo "TPM directory: ~/.tmux/plugins/tpm"
echo "See: https://github.com/tmux-plugins/tpm"

if test ! -d ~/.tmux/plugins/tpm; then
	echo "Installing TPM..."
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
	~/.tmux/plugins/tpm/bin/install_plugins
else
	echo "TPM already installed"
fi
