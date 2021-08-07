source .profile
# Set up the prompt

autoload -Uz promptinit
promptinit
prompt adam1

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -e

# Keep 1000 lines of history within the shell and save it to ~/.zsh_history:
HISTSIZE=1000
SAVEHIST=1000
HISTFILE=~/.zsh_history

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

source /usr/share/autojump/autojump.sh on startup

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

load_nvm() {
	unset -f nvm
	export NVM_DIR="$HOME/.nvm"
	[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
}

nvm() {
	load_nvm
	nvm "$@"
}

vim() {
	unset -f vim
	if ! command -v node &> /dev/null
		then load_nvm
	fi
	vim "$@"
}

conda_setup() {
	# >>> conda initialize >>>
	# !! Contents within this block are managed by 'conda init' !!
	__conda_setup="$('/opt/anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
	if [ $? -eq 0 ]; then
    		eval "$__conda_setup"
	else
   		if [ -f "/opt/anaconda3/etc/profile.d/conda.sh" ]; then
       			. "/opt/anaconda3/etc/profile.d/conda.sh"
   		else
  			export PATH="/opt/anaconda3/bin:$PATH"
  		fi
	fi
	unset __conda_setup
	# <<< conda initialize <<<
}

conda() {
	unset -f conda
	if ! command -v conda &> /dev/null
		then conda_setup
	fi
	conda "$@"
}

anaconda() {
	unset -f anaconda
	if ! command -v anaconda &> /dev/null
		then conda_setup
	fi
	anaconda "$@"
}
