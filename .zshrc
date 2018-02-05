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


# ls
export CLICOLOR=1
export LSCOLORS=GxCxcxdxCxegedabagacad

alias ls='ls -G'
alias ll='ls -Gl'
alias la='ls -Gla'

# version control system info
autoload -Uz vcs_info

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git:*' stagedstr "%{${fg[red]}%}*%{${reset_color}%}"
zstyle ':vcs_info:git:*' unstagedstr "%{${fg[yellow]%}+%{${reset_color}%}"
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
alias gco='git checkout'
alias gd='git diff'
alias gst='git status'
alias gl='git log --graph'
alias glo='git log --graph --oneline'

# tig
alias tigs='tig status'


# prompt
setopt prompt_subst

function _precmd_prompt () {
  print
  print -P ' %{${fg[green]}%}%~%{${reset_color}%}'
}
add-zsh-hook precmd _precmd_prompt

PROMPT='%(?.%{${fg[cyan]}%}.%{${fg[red]}%})%# %{${reset_color}%}'
RPROMPT='${vcs_info_msg_0_}'

