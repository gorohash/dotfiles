export LANG=ja_JP.UTF-8

# options
setopt print_eight_bit
setopt no_beep
setopt auto_cd
setopt auto_pushd
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt hist_reduce_blanks

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# vim like keybind
bindkey -v

# use colors
autoload -Uz colors
colors

# hook
autoload -Uz add-zsh-hook

# auto complete
fpath=(/usr/local/share/zsh-completions $fpath)

autoload -Uz compinit
compinit -C

zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
zstyle ':completion:*' menu select
setopt menu_complete


# environment dependence
case ${OSTYPE} in
  darwin*)
    # for macOS

    # ls
    export CLICOLOR=1
    export LSCOLORS=GxCxcxdxCxegedabagacad

    alias ls='ls -G'
    ;;

  linux*)
    # for Linux
	
	# ls
	alias ls='ls --color=auto'
    ;;

esac

# ls
alias ll='ls -l'
alias la='ls -la'

# history
function _fzf_history() {
  BUFFER=$(fc -ln 1 | fzf +s --tac | sed -r 's/\\/\\\\/g')
  CURSOR=$#BUFFER
  zle reset-prompt
}
zle -N _fzf_history
bindkey '^R' _fzf_history

# version control system info
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%{${fg[red]}%}*%{${reset_color}%}"
zstyle ':vcs_info:git:*' unstagedstr "%{${fg[yellow]}%}+%{${reset_color}%}"
zstyle ':vcs_info:*' formats "%c%u [ %{${fg[magenta]}%}%b%{${reset_color}%} ]"
zstyle ':vcs_info:*' actionformats ""
function _precmd_vcs_info () {
  LANG=en_US.UTF-8
  vcs_info
}
add-zsh-hook precmd _precmd_vcs_info

# git
alias ga='git add'
alias gc='git commit'
alias gcob='git checkout -b'
alias gd='git diff'
alias gl='git log --graph'
alias glo='git log --graph --oneline'
alias gp='git push'
alias gpl='git pull'
alias gs='git stash'
alias gsp='git stash pop'
alias gst='git status'

function gco() {
  if [ $# -eq 0 ]; then
    git branch --sort=-authordate | cut -b 3- | peco | xargs git checkout
  else
    git checkout $*
  fi
}

# tig
alias tgs='tig status'

# ghq
alias cdg='cd $(ghq root)/$(ghq list | fzf +s --height=40% --reverse)'

# prompt
setopt prompt_subst

function _precmd_prompt () {
  print
  print -P ' %{${fg[green]}%}%~%{${reset_color}%}'
}
add-zsh-hook precmd _precmd_prompt

PROMPT='%(?.%{${fg[cyan]}%}.%{${fg[red]}%})%# %{${reset_color}%}'
RPROMPT='${vcs_info_msg_0_}'

# local settings
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
