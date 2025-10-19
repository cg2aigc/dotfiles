# 初始化 zoxide
eval "$(zoxide init zsh --cmd cd)"

# alias: j = jump
alias j='z'

# fzf 集成：快速模糊查找目录并跳转
zoxide-fzf() {
  local dir
  dir=$(zoxide query -l | fzf --height 40% --layout=reverse --border)
  if [[ -n $dir ]]; then
    cd "$dir" || return
  fi
}
alias zj='zoxide-fzf'

# 自动记录目录
chpwd() {
  zoxide add "$PWD"
}

