#!/bin/bash

_cargo_installed=false
if command -v cargo >/dev/null 2>&1; then
  _cargo_installed=true
fi

function install_cargo() {
	if [ "$_cargo_installed" = false ]; then
		_cargo_installed=true
		curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	fi
}

function install_git_delta() {
	install_cargo
	prompt=$prompt"
		=== git-delta ===
		source ~/.bashrc
		cargo install git-delta

	"
}
