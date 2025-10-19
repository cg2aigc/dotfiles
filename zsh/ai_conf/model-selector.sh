#!/bin/bash

# Claude Code 模型选择器
# 使用 fzf 选择第三方大模型 API

CONFIG_FILE="$HOME/.config/zsh/ai_conf/models.conf"

# 检查配置文件是否存在
if [[ ! -f "$CONFIG_FILE" ]]; then
    echo "错误：配置文件不存在 $CONFIG_FILE"
    exit 1
fi

# 检查 fzf 是否安装
if ! command -v fzf &> /dev/null; then
    echo "错误：fzf 未安装。请先安装 fzf："
    echo "  brew install fzf"
    exit 1
fi

# 读取配置文件（跳过注释和空行）
models=$(grep -v '^#' "$CONFIG_FILE" | grep -v '^$')

# 使用 fzf 选择模型
selected=$(echo "$models" | fzf \
    --height=40% \
    --layout=reverse \
    --border \
    --prompt="选择模型 > " \
    --header="使用 ↑↓ 选择，Enter 确认，Esc 取消" \
    --preview='echo {}' \
    --preview-window=down:3:wrap \
    --delimiter="|" \
    --with-nth=1,5)

# 如果取消选择，使用默认 Claude Official
if [[ -z "$selected" ]]; then
    echo "未选择模型，使用默认 Claude Official"
    selected=$(echo "$models" | grep "Claude Official")
fi

# 解析选择的模型配置
IFS='|' read -r model_name base_url api_key_var model_id description <<< "$selected"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✨ 已选择模型：$model_name"
echo "🔗 API Base URL: $base_url"
echo "🔑 API Key 变量: ${!api_key_var}"
echo "🤖 模型 ID: $model_id"
echo "📝 描述：$description"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo

# 检查 API Key 是否设置
if [[ -z "${!api_key_var}" && $model_name != 'Claude Official' ]]; then
    echo "⚠️  警告：环境变量 $api_key_var 未设置"
    echo "请在 ~/.zshrc 中添加："
    echo "  export $api_key_var='${!api_key_var}'"
    echo
    read -p "是否继续？(y/N) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 1
    fi
fi

# 1. 创建专属临时目录（避开系统/tmp中的.sock文件）
CLAUDE_TMP_DIR="$HOME/tmp/claude-code"
mkdir -p "$CLAUDE_TMP_DIR"

# 2. 针对非默认模型，注入API相关环境变量
if [[ $model_name != 'Claude Official' ]]; then
    # 基础环境变量（解决.sock监控问题）
    export TMPDIR="$CLAUDE_TMP_DIR"
    export CLAUDE_CODE_DISABLE_FILE_WATCHERS=1
    export CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC=1

    # claude 相关环境变量
    export ANTHROPIC_BASE_URL="$base_url"
    export ANTHROPIC_AUTH_TOKEN="${!api_key_var}"
    export ANTHROPIC_MODEL="$model_id"
    export ANTHROPIC_SMALL_FAST_MODEL="$model_id"
    export ANTHROPIC_DEFAULT_SONNET_MODEL="$model_id"
    export ANTHROPIC_DEFAULT_OPUS_MODEL="$model_id"
    export ANTHROPIC_DEFAULT_HAIKU_MODEL="$model_id"
fi

# ====================== 统一启动逻辑 ======================
echo "🚀 启动 Claude Code（模型：$model_name）..."
echo

# 直接启动claude，无需临时settings文件
claude "$@"

# 3. 清理环境变量（避免影响后续终端会话）
unset ANTHROPIC_BASE_URL ANTHROPIC_AUTH_TOKEN ANTHROPIC_MODEL
unset ANTHROPIC_SMALL_FAST_MODEL ANTHROPIC_DEFAULT_SONNET_MODEL
unset ANTHROPIC_DEFAULT_OPUS_MODEL ANTHROPIC_DEFAULT_HAIKU_MODEL
unset TMPDIR CLAUDE_CODE_DISABLE_FILE_WATCHERS CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC


# if [[ $model_name == 'Claude Official' ]]; then
#   # 使用默认订阅，直接启动
#   echo "🚀 启动 Claude Code（使用默认订阅）..."
#   echo
#   claude "$@"
# else
#   # 创建临时配置文件
#   TEMP_SETTINGS="/tmp/claude-settings-$$.json"
#
#   cat > "$TEMP_SETTINGS" << EOF
# {
#   "env": {
#     "ANTHROPIC_BASE_URL": "$base_url",
#     "ANTHROPIC_AUTH_TOKEN": "${!api_key_var}",
#     "ANTHROPIC_MODEL": "$model_id",
#     "ANTHROPIC_SMALL_FAST_MODEL": "$model_id",
#     "ANTHROPIC_DEFAULT_SONNET_MODEL": "$model_id",
#     "ANTHROPIC_DEFAULT_OPUS_MODEL": "$model_id",
#     "ANTHROPIC_DEFAULT_HAIKU_MODEL": "$model_id",
#     "CLAUDE_CODE_DISABLE_NONESSENTIAL_TRAFFIC": "1"
#   }
# }
# EOF
#
#   echo "🚀 启动 Claude Code"
#   echo
#
#   # 使用 --settings 参数启动 claude
#   claude --settings "$TEMP_SETTINGS" "$@"
#
#   # 清理临时文件
#   rm -f "$TEMP_SETTINGS"
# fi
