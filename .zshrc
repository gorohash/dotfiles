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
_fzf_history() {
  BUFFER=$(fc -ln 1 | fzf --tac | sed -r 's/\\/\\\\/g')
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
_precmd_vcs_info() {
  LANG=en_US.UTF-8
  vcs_info
}
add-zsh-hook precmd _precmd_vcs_info

# git
alias ga='git add'
alias gb='git branch'
alias gc='git commit'
alias gd='git diff'
alias gl='git log --graph'
alias glo='git log --graph --oneline'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gpl='git pull'
alias gr='git reset'
alias grs='git restore'
alias grb='git rebase'
alias gst='git stash'
alias gw='git worktree'

# tig
alias tgs='tig status'

# git functions
cdg() {
  local repository
  repository=$(ghq list | fzf --height=40% --reverse) || return
  cd "$(ghq root)/$repository"
}

cdw() {
  local ghq_root="$(ghq root)"

  local selected
  selected="$(
    git worktree list \
    | while read -r path rest; do
        if [[ "$path" == "$ghq_root"/* ]]; then
          echo "main\t${path}"
        else
          echo "${path##*/}\t${path}"
        fi
      done \
    | fzf --height=40% --reverse --with-nth=1 --delimiter='\t' \
    | cut -f2
  )" || return
  cd "$selected"
}

gs() {
  if [[ "$#" != 0 ]]; then
    git switch "$@"
	return
  fi
  local branches branch
  branches=$(git branch --all --sort=-authordate | grep -v HEAD | cut -b 3-)
  branch=$(echo "$branches" | fzf --border --height=40% --reverse | sed "s/.* //" | sed "s#remotes/[^/]*/##")
  git switch "$branch"
}

gwa() {
  if [[ $# -eq 0 ]]; then
    echo "Usage: gwa <worktree-name> [git worktree add options...]" >&2
    return 1
  fi

  local worktree_name="$1"
  shift

  if [[ "$worktree_name" == "main" ]]; then
    echo "Error: 'main' is not allowed as a worktree name" >&2
    return 1
  fi

  local git_common_dir="$(git rev-parse --git-common-dir 2>/dev/null)" || {
    echo "Error: not inside a git repository" >&2
    return 1
  }
  local repo_root="$(cd "${git_common_dir}/.." && pwd)"

  local ghq_root="$(ghq root)"
  local rel_path="${repo_root#$ghq_root/}"
  if [[ "$rel_path" == "$repo_root" ]]; then
    echo "Error: not inside a ghq-managed repository" >&2
    return 1
  fi

  local worktree_path="${HOME}/worktrees/${rel_path}/${worktree_name}"

  git worktree add "$worktree_path" "$@" && cd "$worktree_path"
}

# ssh
sshf() {
  local host
  host=$(cat ~/.ssh/config | awk '/^Host/ { print $2 }' | fzf) && ssh "$host" 
}

# aws
awsprof() {
  local profile
  profile=$(cat ~/.aws/config | grep "^\[profile .*\]$" | sed -e "s/^\[profile \(.*\)\]$/\1/" | fzf) && echo "export AWS_PROFILE=$profile\nexport AWS_SDK_LOAD_CONFIG=true\n" >> ./.envrc 
}  

# docker
alias dc='docker compose'
alias d='docker'

# terraform
alias tf='terraform'

# prompt
setopt prompt_subst

_git_diff_between_local_and_remotes() {
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

_precmd_prompt() {
  print
  print -P ' %{${fg[green]}%}%~%{${reset_color}%}'
}
add-zsh-hook precmd _precmd_prompt

PROMPT='%(?.%{${fg[cyan]}%}.%{${fg[red]}%})%# %{${reset_color}%}'
RPROMPT='$(_git_diff_between_local_and_remotes)${vcs_info_msg_0_}'

# local settings
if [[ -f ~/.zshrc.local ]]; then
  source ~/.zshrc.local
fi

