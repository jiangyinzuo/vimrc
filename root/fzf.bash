#!/bin/bash

# We install fzf via vim-plug
export PATH=$PATH:$HOME/plugged/fzf/bin

# Reference: https://github.com/junegunn/fzf#fzf-tmux-script
export FZF_TMUX=1

# Extended-search-mode
# 
# 'wild	exact-match
# or start fzf with -e
# Reference: https://github.com/junegunn/fzf#extended-search-mode

# https://github.com/lincheney/fzf-tab-completion is removed, use fzf default completion instead
# Reference: https://github.com/junegunn/fzf/tree/master/shell
source $HOME/plugged/fzf/shell/key-bindings.bash
source $HOME/plugged/fzf/shell/completion.bash

# Reference: https://github.com/junegunn/fzf#fuzzy-completion-for-bash-and-zsh
# Use ** as the trigger sequence
export FZF_COMPLETION_TRIGGER='**'
# Options to fzf command
export FZF_COMPLETION_OPTS='--border --info=inline'
# Options for path completion (e.g. vim **<TAB>)
export FZF_COMPLETION_PATH_OPTS='--walker file,dir,follow,hidden'
# Options for directory completion (e.g. cd **<TAB>)
export FZF_COMPLETION_DIR_OPTS='--walker dir,follow'

### Customizing completion source for paths and directories
# Use fd (https://github.com/sharkdp/fd) instead of the default find
# command for listing path candidates.
# - The first argument to the function ($1) is the base path to start traversal
# - See the source code (completion.{bash,zsh}) for the details.
_fzf_compgen_path() {
  fd --hidden --follow --exclude ".git" . "$1"
}

# Use fd to generate the list for directory completion
_fzf_compgen_dir() {
  fd --type d --hidden --follow --exclude ".git" . "$1"
}

# Advanced customization of fzf options via _fzf_comprun function
# - The first argument to the function is the name of the command.
# - You should make sure to pass the rest of the arguments to fzf.
_fzf_comprun() {
  local command=$1
  shift

  case "$command" in
    cd)           fzf --preview 'tree -C {} | head -200'   "$@" ;;
    z)            fzf +s --tac --preview 'tree -C {} | head -200' "$@" ;;
    goto)         fzf +s --tac --preview 'tree -C {2..} | head -200' "$@" ;;
    export|unset) fzf --preview "eval 'echo \$'{}"         "$@" ;;
    ssh)          fzf --preview 'dig {}'                   "$@" ;;
    *)            fzf --preview 'batcat -n --color=always {}' "$@" ;;
  esac
}

# sudo apt install bat
# alias "bat=batcat" in Ubuntu

# https://github.com/phiresky/ripgrep-all

# z **<TAB>: select a history directory, then press Enter to jump.
_fzf_complete_z() {
  if [[ ${COMP_WORDS[COMP_CWORD]} != *"${FZF_COMPLETION_TRIGGER-'**'}" ]]; then
    mapfile -t COMPREPLY < <(_z --complete "$COMP_LINE")
    return
  fi
  _fzf_complete --no-multi -- "$@" < <(
    z -l | awk '$1 != "common:" { sub(/^[[:space:]]*[^[:space:]]+[[:space:]]+/, ""); print }'
  )
}

_fzf_complete_z_post() {
  local directory
  while IFS= read -r directory; do
    printf '%q\n' "$directory"
  done
}

# goto **<TAB>: select a registered alias, then press Enter to jump.
_fzf_complete_goto() {
  _fzf_complete --no-multi -- "$@" < <(
    _goto_resolve_db
    [[ -f $GOTO_DB ]] && cat "$GOTO_DB"
  )
}

_fzf_complete_goto_post() {
  awk '{print $1}'
}

complete -o nospace -F _fzf_complete_z z
__fzf_orig_completion < <(complete -p goto 2>/dev/null)
__fzf_defc goto _fzf_complete_goto '-o nospace'
