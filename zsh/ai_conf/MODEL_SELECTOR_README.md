# Claude Code 第三方模型选择器

使用 fzf 在 Claude Code 中快速切换第三方大模型 API。

## 功能特点

- 🎯 使用 `ccc` 命令启动交互式模型选择器
- 🔄 支持多个第三方模型提供商
- ⚡ 基于 fzf 的快速选择界面
- 🔒 安全的环境变量管理
- 📝 默认使用 Claude 官方订阅

## 文件说明

```
~/.config/zsh/ai_conf/
├── models.conf              # 模型配置文件
├── model-selector.sh        # fzf 选择器脚本
├── api-keys.example         # API Key 配置示例
├── MODEL_SELECTOR_README.md # 本说明文档
└── ai_api.conf                     # 原有 AI API 配置

~/.config/zsh/
└── zsh_alias                       # zsh 别名配置（包含 ccc）
```

## 快速开始

### 1. 配置 API Keys

参考 `~/.config/api-keys.example`，在你的 shell 配置文件中添加 API Keys：

```bash
# 编辑环境变量配置
nvim ~/.config/zsh/zsh_env
# 或者
nvim ~/.zshrc

# 添加 API Keys（示例）
export ANTHROPIC_API_KEY="sk-ant-api03-xxxxx"
export ZHIPU_API_KEY="your-zhipu-key"
export DEEPSEEK_API_KEY="your-deepseek-key"

# 重新加载配置
source ~/.zshrc
```

### 2. 配置模型列表

编辑 `~/.config/zsh/ai_conf/models.conf`，添加或修改模型配置：

```bash
nvim ~/.config/zsh/ai_conf/models.conf
```

**配置格式：**
```
模型名称|API_BASE_URL|API_KEY_ENV_VAR|MODEL_NAME|描述
```

**示例：**
```
Claude Official|https://api.anthropic.com|ANTHROPIC_API_KEY|claude-sonnet-4-5|Claude 官方订阅（默认）
DeepSeek|http://localhost:4000|DEEPSEEK_API_KEY|deepseek-chat|DeepSeek
```

### 3. 使用选择器

```bash
# 启动模型选择器
ccc

# 或带参数启动
ccc --cwd ~/my-project
```

**操作说明：**
- `↑/↓` 或 `j/k` - 选择模型
- `Enter` - 确认选择并启动 Claude Code
- `Esc` - 取消（使用默认 Claude Official）

## 支持的模型

当前配置支持以下模型提供商：

| 提供商 | 模型 | Anthropic 兼容 | 官网 |
|--------|------|----------------|------|
| Claude Official | claude-sonnet-4-5 | ✅ 原生 | [Anthropic](https://anthropic.com) |
| Kimi AI | kimi-k2 | ✅ 原生支持 | [Moonshot](https://platform.moonshot.cn/) |
| DeepSeek | deepseek-chat | ✅ 原生支持 | [DeepSeek](https://platform.deepseek.com/) |
| 智谱 AI | glm-4 | ⚠️ 需要 LiteLLM | [智谱 AI](https://open.bigmodel.cn/) |
| Minimax | minimax | ⚠️ 需要 LiteLLM | [Minimax](https://api.minimax.chat/) |

**说明：**
- ✅ **原生支持**：提供商官方支持 Anthropic API 格式，无需额外网关
- ⚠️ **需要 LiteLLM**：需要通过 LiteLLM Gateway 转换 API 格式

## 高级配置

### 使用 LiteLLM 统一网关

如果你想使用统一的 LiteLLM 网关管理多个模型：

```bash
# 1. 安装 LiteLLM
pip install litellm

# 2. 创建 LiteLLM 配置文件
cat > ~/.config/litellm-config.yaml <<EOF
model_list:
  - model_name: glm-4
    litellm_params:
      model: zhipu/glm-4
      api_key: os.environ/ZHIPU_API_KEY

  - model_name: deepseek-chat
    litellm_params:
      model: deepseek/deepseek-chat
      api_key: os.environ/DEEPSEEK_API_KEY
EOF

# 3. 启动 LiteLLM 服务
litellm --config ~/.config/litellm-config.yaml --port 4000

# 4. 更新 models.conf 中的 YOUR_LITELLM_URL
# 改为: http://localhost:4000
```

### 自定义选择器样式

编辑 `~/.config/zsh/ai_conf/model-selector.sh` 中的 fzf 参数：

```bash
selected=$(echo "$models" | fzf \
    --height=60% \              # 调整高度
    --layout=reverse \          # 布局方向
    --border=rounded \          # 边框样式
    --prompt="🤖 选择模型 > " \ # 自定义提示符
    --color=dark \              # 颜色主题
    ...)
```

## 故障排查

### 问题：命令 `ccc` 找不到

**解决方法：**
```bash
# 重新加载 zsh 配置
source ~/.zshrc

# 检查别名是否生效
alias | grep ccc
```

### 问题：API Key 未设置警告

**解决方法：**
```bash
# 检查环境变量
echo $ANTHROPIC_API_KEY
echo $DEEPSEEK_API_KEY

# 确保在 ~/.zshrc 或 ~/.config/zsh/zsh_env 中已配置
export YOUR_API_KEY="your-key-here"
```

### 问题：fzf 未安装

**解决方法：**
```bash
# macOS
brew install fzf

# 验证安装
fzf --version
```

### 问题：模型连接失败

**检查清单：**
1. API Key 是否正确
2. 网络连接是否正常
3. API Base URL 是否正确
4. LiteLLM 网关是否运行（如果使用）

## 注意事项

⚠️ **第三方模型支持：**

Claude Code 支持通过 `ANTHROPIC_BASE_URL` 切换到第三方 AI 提供商：

1. **原生支持 Anthropic API 格式**：
   - ✅ Kimi AI（月之暗面）：`https://api.moonshot.cn/anthropic`
   - ✅ DeepSeek：`https://api.deepseek.com/anthropic`
   - 无需额外配置，直接使用

2. **需要 LiteLLM Gateway 转换**：
   - ⚠️ 智谱 AI、Minimax 等不支持 Anthropic 格式的提供商
   - 需要通过 LiteLLM Gateway 转换 API 格式

🔒 **安全提示：**
- 不要将 API Keys 提交到 Git 仓库
- 建议使用环境变量或加密的密钥管理器
- 定期轮换 API Keys

## 参考资料

- [Claude Code 官方文档](https://code.claude.com/docs/)
- [Kimi AI Claude Code 配置指南](https://www.cnblogs.com/h5l0/p/18980806)
- [DeepSeek Anthropic API 文档](https://api-docs.deepseek.com/guides/anthropic_api)
- [LiteLLM 文档](https://docs.litellm.ai/)
- [fzf GitHub](https://github.com/junegunn/fzf)

