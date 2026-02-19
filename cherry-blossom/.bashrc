# ---------------------------
# ~/.bashrc
# ---------------------------

# NVM (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "/usr/share/nvm/init-nvm.sh" ] && \. "/usr/share/nvm/init-nvm.sh" # Load NVM

# Local binaries
export PATH="$HOME/.local/bin:$PATH"

# Node binaries (ensure default Node version is in PATH)
[ -d "$NVM_DIR/versions/node/$(nvm version)/bin" ] &&
  export PATH="$NVM_DIR/versions/node/$(nvm version)/bin:$PATH"

# Color palette
COLOR_TIME="38;5;44"
#COLOR_BRACKET="38;5;39"
#COLOR_USER="38;5;141"
#COLOR_DIR="38;5;108"
#COLOR_BRANCH="38;5;141"
COLOR_GIT_CLEAN="38;5;245"
COLOR_GIT_DIRTY="38;5;173"

alias ls='ls --color=auto'
alias grep='grep --color=auto'
# PS1='[\u@\h \W]\$ '
# PS1='\[\e[32m\]┌──(\[\e[94;1m\]\u\[\e[94m\]@\[\e[94m\]\h\[\e[0;32m\])-[\[\e[38;5;46;1m\]\w\[\e[0;32m\]] [\[\e[32m\]$?\[\e[32m\]]\n\[\e[32m\]╰─\[\e[94;1m\]\$\[\e[0m\] '

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion

# Git branch name
git_branch() {
  git rev-parse --abbrev-ref HEAD 2>/dev/null
}

# Git status with muted color if clean
git_status() {
  local staged_add staged_del unstaged_add unstaged_del

  read staged_add staged_del <<<$(git diff --cached --numstat 2>/dev/null |
    awk '{a+=$1; d+=$2} END {print a+0, d+0}')

  read unstaged_add unstaged_del <<<$(git diff --numstat 2>/dev/null |
    awk '{a+=$1; d+=$2} END {print a+0, d+0}')

  if ((staged_add + staged_del + unstaged_add + unstaged_del == 0)); then
    printf "\e[${COLOR_GIT_CLEAN}m✓ clean"
  else
    printf "\e[${COLOR_GIT_DIRTY}m+%d -%d ↑%d ↓%d" \
      "$staged_add" "$staged_del" "$unstaged_add" "$unstaged_del"
  fi
}

# PS1
# PS1='|-- \t \u@\h \w $(branch=$(parse_git_branch); [ -n "$branch" ] && echo "<$branch>$(parse_git_status)")\n|-- > '

# --- Prompt ---
PS1='\[\e[${COLOR_BRACKET}m\]┌───[\[\e[${COLOR_TIME}m\]\t\[\e[${COLOR_BRACKET}m\]] \
(\[\e[${COLOR_USER}m\]\u\[\e[${COLOR_BRACKET}m\]@\[\e[${COLOR_USER}m\]\h\[\e[${COLOR_BRACKET}m\]) \
[\[\e[${COLOR_DIR}m\]\w\[\e[${COLOR_BRACKET}m\]] \
$(branch=$(git_branch); \
  [ -n "$branch" ] && printf "[\[\e[${COLOR_BRANCH}m\]%s \[\e[0m\]%s\[\e[${COLOR_BRACKET}m\]]" \
  "$branch" "$(git_status)")\
\n\[\e[${COLOR_BRACKET}m\]╰─\[\e[${COLOR_BRANCH}m\]>\[\e[0m\] '
