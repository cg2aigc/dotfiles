# 启用 fzf 默认快捷键和补全
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# 更好的预览（需要 bat 和 lsd）
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_DEFAULT_OPTS="
  --height=60%
  --layout=reverse
  --border
  --wrap
  --preview 'bat --style=numbers --color=always --line-range :200 {}'
  --preview-window=right:60%:wrap
"

# Ctrl-R 历史搜索（带预览）
bindkey '^R' fzf-history-widget
fzf-history-widget() {
  BUFFER=$(fc -l -n 1 | fzf --tac --no-sort \
    --height 40% --layout=reverse --border \
    --preview 'echo {}' --preview-window=up:3:wrap)
  CURSOR=$#BUFFER
  # 注释下面reset-prompt，与starship产生无限循环
  # 替换为redisplay
  # zle reset-prompt
  zle redisplay
}
zle -N fzf-history-widget

# Alt-C: 快速切换目录
bindkey '\ec' fzf-cd-widget
fzf-cd-widget() {
  local dir
  dir=$(fd --type d --hidden --follow --exclude .git | fzf)
  if [[ -n $dir ]]; then
    BUFFER="cd $dir"
    zle accept-line
  fi
}
zle -N fzf-cd-widget

