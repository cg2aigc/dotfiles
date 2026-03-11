#!/bin/bash

# Claude Code 提供商管理器
# 功能：
#   1. switch-provider   - 切换默认提供商（fzf 选择界面）
#   2. claude [args...]   - 启动 Claude Code（使用默认提供商配置）

CONFIG_FILE="$HOME/.config/zsh/ai_conf/models.conf"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# 检测调用方式：通过脚本名或环境变量判断
# 如果通过 'claude' 别名调用，则启动 Claude Code
if [[ "$0" == *"claude"* ]] || [[ "$CLAUDE_WRAPPER_MODE" == "1" ]]; then
  # ========== Claude Code 启动模式 ==========

  # 从 models.conf 读取默认提供商配置（第一列为 1 的行）
  config_line=$(grep -v '^#' "$CONFIG_FILE" | grep -v '^$' | grep '^1|')

  # 如果没有默认配置，直接启动 claude
  if [[ -z "$config_line" ]]; then
    exec claude "$@"
  fi

  # 解析配置（7字段格式：IS_DEFAULT|provider_name|base_url|api_key_var|opus_model|sonnet_model|haiku_model）
  IFS='|' read -r is_default provider_name base_url api_key_var opus_model sonnet_model haiku_model <<<"$config_line"

  # 如果默认提供商是 Claude 官方，直接启动
  if [[ "$provider_name" == "Claude" ]]; then
    exec claude "$@"
  fi

  # 检查 API Key 是否设置
  if [[ -z "${!api_key_var}" ]]; then
    echo "⚠️  警告：环境变量 $api_key_var 未设置"
    echo "请在 ~/.zshrc 中添加："
    echo "  export $api_key_var='your-api-key'"
    echo
    echo "将使用默认 Claude"
    exec claude "$@"
  fi

  # 创建临时目录
  CLAUDE_TMP_DIR="$HOME/tmp/claude-code"
  mkdir -p "$CLAUDE_TMP_DIR"

  # 设置环境变量
  export TMPDIR="$CLAUDE_TMP_DIR"
  export CLAUDE_CODE_DISABLE_FILE_WATCHERS=1
  export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

  unset ANTHROPIC_API_KEY ANTHROPIC_AUTH_TOKEN
  export ANTHROPIC_AUTH_TOKEN="${!api_key_var}"
  export ANTHROPIC_BASE_URL="$base_url"
  export ANTHROPIC_MODEL="$sonnet_model"
  export ANTHROPIC_SMALL_FAST_MODEL="$haiku_model"
  export ANTHROPIC_DEFAULT_SONNET_MODEL="$sonnet_model"
  export ANTHROPIC_DEFAULT_OPUS_MODEL="$opus_model"
  export ANTHROPIC_DEFAULT_HAIKU_MODEL="$haiku_model"

  # 启动 claude，传递所有参数
  exec claude "$@"
fi

# ========== 提供商切换模式 ==========

# 检查配置文件是否存在
if [[ ! -f "$CONFIG_FILE" ]]; then
  echo "错误：配置文件不存在 $CONFIG_FILE"
  exit 1
fi

# 检查 fzf 是否安装
if ! command -v fzf &>/dev/null; then
  echo "错误：fzf 未安装。请先安装 fzf："
  echo "  brew install fzf"
  exit 1
fi

# 读取配置文件（跳过注释和空行，提取第2列为提供商名称）
providers=$(grep -v '^#' "$CONFIG_FILE" | grep -v '^$' | cut -d'|' -f2)

# 使用 fzf 选择提供商
selected=$(echo "$providers" | fzf \
  --height=40% \
  --layout=reverse \
  --border \
  --prompt="选择默认提供商 > " \
  --header="使用 ↑↓ 选择，Enter 确认，Esc 取消" \
  --preview-window=down:5:wrap)

# 如果取消选择
if [[ -z "$selected" ]]; then
  echo "已取消"
  exit 0
fi

# 更新 models.conf
# 步骤1: 将所有配置行（以0或1开头）的第一列设为 0
# 步骤2: 将匹配选中提供商的行的第一列设为 1

temp_file=$(mktemp)
while IFS= read -r line; do
  if [[ "$line" =~ ^[01]\| ]]; then
    # 这是配置行，提取提供商名称
    provider=$(echo "$line" | cut -d'|' -f2)
    if [[ "$provider" == "$selected" ]]; then
      # 设为默认
      echo "1${line:1}" >>"$temp_file"
    else
      # 设为非默认
      echo "0${line:1}" >>"$temp_file"
    fi
  else
    # 注释或空行，保持不变
    echo "$line" >>"$temp_file"
  fi
done <"$CONFIG_FILE"

mv "$temp_file" "$CONFIG_FILE"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ 已切换默认提供商：$selected"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo
echo "现在可以直接运行 'claude' 使用该提供商"

