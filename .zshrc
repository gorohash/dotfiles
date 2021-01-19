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
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gr='git restore'
alias gst='git stash'
alias gsp='git stash pop'

function gs() {
  if [[ "$#" != 0 ]]; then
    git switch "$@"
	return
  fi
  local branches branch
  branches=$(git branch --all --sort=-authordate | grep -v HEAD | cut -b 3-)
  branch=$(echo "$branches" | fzf --border --height=40% --reverse | sed "s/.* //" | sed "s#remotes/[^/]*/##")
  git switch "$branch"
}

function gco() {
  if [[ "$#" != 0 ]]; then
    git checkout "$@"
	return
  fi
  local branches branch
  branches=$(git branch --all --sort=-authordate | grep -v HEAD | cut -b 3-)
  branch=$(echo "$branches" | fzf --border --height=40% --reverse)
  git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
}

# tig
alias tgs='tig status'

# ghq
function cdg() {
  local repository
  repository=$(ghq list | fzf +s --height=40% --reverse) && cd "$(ghq root)/$repository"
}

# ssh
function sshf() {
  local host
  host=$(cat ~/.ssh/config | awk '/^Host/ { print $2 }' | fzf) && ssh "$host" 
}

# docker
alias dc='docker-compose'
alias d='docker'

# terraform
alias tf='terraform'

# prompt
setopt prompt_subst

function _git_diff_between_local_and_remotes() {
  if [[ "$(git rev-parse --is-inside-work-tree 2>/dev/null)" = "true" ]]; then
    head="$(git rev-parse HEAD)"
    for remote in $(git rev-parse --remotes)
    do
      if [[ "$head" = "$remote" ]]; then
        return 0
      fi
    done
    echo "%{${fg[cyan]}%}↑↓%{${reset_color}%}"
  fi
  return 0
}

function _precmd_prompt () {
  print
  print -P ' %{${fg[green]}%}%~%{${reset_color}%}'
}
add-zsh-hook precmd _precmd_prompt

PROMPT='%(?.%{${fg[cyan]}%}.%{${fg[red]}%})%# %{${reset_color}%}'
RPROMPT='$(_git_diff_between_local_and_remotes)${vcs_info_msg_0_}'

# local settings
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

