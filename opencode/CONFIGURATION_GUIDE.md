# OpenCode + Oh My OpenCode 高阶配置说明

## 📋 配置概览

本配置为 OpenCode 和 oh-my-opencode 插件提供最大化性能和优化的高阶配置，支持**双配置系统**，可在 Antigravity 优先和 Alibaba 优先之间灵活切换。

---

## 🚀 配置亮点

### 1. 双配置系统
- **Antigravity 优先配置**: 充分利用 Google Antigravity 免费额度，使用 Claude Opus/Sonnet 和 Gemini 3 Pro/Flash
- **Alibaba 优先配置**: 稳定的 Alibaba 服务，使用 GLM-4.7、QWen3 Code 和 MiniMax-M2.1
- **一键切换**: 使用 `switch-opencode-config.sh` 脚本快速切换配置

### 2. 智能模型分配

#### Antigravity 优先配置
- **推理/架构类**: Claude Opus 4.5 Thinking (深度推理)
- **编码/实现类**: Claude Sonnet 4.5 Thinking (专注编码)
- **前端 UI/UX**: Gemini 3 Pro (多模态支持)
- **快速处理类**: Gemini 3 Flash (高效低成本)

#### Alibaba 优先配置
- **推理/架构类**: GLM-4.7 (深度推理)
- **编码/实现类**: QWen3 Code (专注编码)
- **快速处理类**: MiniMax-M2.1 (高效低成本)

### 4. 完整 Agent 生态系统
13 个专业化 Agent，每个针对特定任务优化：
- Sisyphus: 主协调器
- Prometheus: 计划师
- Metis: 计划顾问
- Momus: 计划审查者
- Oracle: 设计与调试
- Librarian: 研究专家
- Explore: 快速探索
- Atlas: 执行协调器
- ... 等等

### 3. 8 种任务类别
使用 `delegate_task` 时自动应用优化配置：
- `visual-engineering`: 前端 UI/UX
- `ultrabrain`: 深度逻辑推理
- `artistry`: 创意任务
- `quick`: 简单快速任务
- `unspecified-low`: 通用低工作量
- `unspecified-high`: 通用高工作量
- `writing`: 文档写作
- `deep`: 自主问题解决

### 4. 8 种任务类别
使用 `delegate_task` 时自动应用优化配置：
- `visual-engineering`: 前端 UI/UX
- `ultrabrain`: 深度逻辑推理
- `artistry`: 创意任务
- `quick`: 简单快速任务
- `unspecified-low`: 通用低工作量
- `unspecified-high`: 通用高工作量
- `writing`: 文档写作
- `deep`: 自主问题解决

### 5. 性能优化
- 动态上下文修剪
- 后台任务并发控制
- 智能去重和错误清除
- 会话恢复机制
- 4 帐号智能轮换（Antigravity）

---

## 📁 文件结构

```
~/.config/opencode/
├── oh-my-opencode-antigravity.json   # Antigravity 优先配置
├── oh-my-opencode-alibaba.json       # Alibaba 优先配置
├── oh-my-opencode.json                     -> 符号链接（指向当前配置）
├── switch-opencode-config.sh               # 配置切换脚本
├── antigravity.json                        # Antigravity 帐号配置
├── opencode.json                           # 模型定义
└── antigravity-accounts.json               # Google 帐号信息
```

---

## 📦 opencode.json 配置

### 模型定义

#### Google Provider（Antigravity）
```json
"google": {
  "models": {
    "antigravity-claude-opus-4-5-thinking": {
      "name": "Claude Opus 4.5 Thinking (Antigravity)",
      "limit": { "context": 200000, "output": 64000 },
      "modalities": { "input": ["text", "image", "pdf"], "output": ["text"] },
      "variants": {
        "low": { "thinkingConfig": { "thinkingBudget": 8192 } },
        "max": { "thinkingConfig": { "thinkingBudget": 32768 } }
      }
    },
    "antigravity-claude-opus-4-6-thinking": {
      "name": "Claude Opus 4.6 Thinking (Antigravity)",
      "limit": { "context": 200000, "output": 64000 },
      "modalities": { "input": ["text", "image", "pdf"], "output": ["text"] },
      "variants": {
        "low": { "thinkingConfig": { "thinkingBudget": 8192 } },
        "max": { "thinkingConfig": { "thinkingBudget": 32768 } }
      }
    },
    "antigravity-claude-sonnet-4-5-thinking": {
      "name": "Claude Sonnet 4.5 Thinking (Antigravity)",
      "limit": { "context": 200000, "output": 64000 },
      "modalities": { "input": ["text", "image", "pdf"], "output": ["text"] },
      "variants": {
        "low": { "thinkingConfig": { "thinkingBudget": 8192 } },
        "max": { "thinkingConfig": { "thinkingBudget": 32768 } }
      }
    },
    "antigravity-gemini-3-pro": {
      "name": "Gemini 3 Pro (Antigravity)",
      "limit": { "context": 1048576, "output": 65535 },
      "modalities": { "input": ["text", "image", "pdf"], "output": ["text"] },
      "variants": {
        "low": { "thinkingLevel": "low" },
        "high": { "thinkingLevel": "high" }
      }
    },
    "antigravity-gemini-3-flash": {
      "name": "Gemini 3 Flash (Antigravity)",
      "limit": { "context": 1048576, "output": 65536 },
      "modalities": { "input": ["text", "image", "pdf"], "output": ["text"] },
      "variants": {
        "minimal": { "thinkingLevel": "minimal" },
        "low": { "thinkingLevel": "low" },
        "medium": { "thinkingLevel": "medium" },
        "high": { "thinkingLevel": "high" }
      }
    }
  }
}
```

#### Alibaba (China) Provider
```json
"alibaba-cn": {
  "models": {
    "qwen-coder-plus": { },      // 编码专用
    "qwen-max": { },             // 通用推理
    "MiniMax-M2.1": { },         // 快速处理
    "glm-4.7": { "reasoning": true }, // 深度推理
    "glm-4-flash": { }           // 超快响应
  }
}
```

---

## 🔧 antigravity.json 配置

### 4 帐号智能轮换配置

```json
{
  "$schema": "https://raw.githubusercontent.com/NoeFabris/opencode-antigravity-auth/main/assets/antigravity.schema.json",
  "account_selection_strategy": "hybrid",
  "switch_on_first_rate_limit": true
}
```

**配置说明：**
- `account_selection_strategy: "hybrid"` - 智能健康评分 + token bucket + LRU 策略
- `switch_on_first_rate_limit: true` - 首次遇到 rate limit 立即切换

**可用策略：**
| 策略 | 适用场景 | 特点 |
|------|----------|------|
| `sticky` | 1 个帐号 | 固定使用，保留 prompt cache |
| `hybrid` | 2-5 个帐号 | 智能轮换，避免问题帐号 |
| `round-robin` | 5+ 个帐号 | 最大吞吐量，均匀分配 |

---

## 🔄 配置切换

### 使用切换脚本

```bash
# 查看当前配置状态
~/.config/opencode/switch-opencode-config.sh status

# 切换配置（在 Antigravity 和 Alibaba 之间切换）
~/.config/opencode/switch-opencode-config.sh

# 或明确指定切换
~/.config/opencode/switch-opencode-config.sh switch
```

### 手动切换

```bash
# 切换到 Antigravity 优先
ln -sf ~/.config/opencode/oh-my-opencode-antigravity.json \
      ~/.config/opencode/oh-my-opencode.json

# 切换到 Alibaba 优先
ln -sf ~/.config/opencode/oh-my-opencode-alibaba.json \
      ~/.config/opencode/oh-my-opencode.json
```

**⚠️ 重要：切换配置后需要重启 OpenCode 才能生效！**

---

## 🔧 oh-my-opencode.json 配置

### Agent 配置策略

#### Antigravity 优先配置

| Agent | 模型 | Variant | 温度 | 用途 |
|-------|------|---------|------|------|
| **sisyphus** | Claude Opus 4.5 Thinking | max | 0.7 | 主协调器 |
| **build** | Claude Sonnet 4.5 Thinking | max | 0.3 | 默认编码 |
| **plan** | Claude Opus 4.5 Thinking | max | 0.5 | 战略规划 |
| **prometheus** | Claude Opus 4.5 Thinking | max | 0.3 | 计划师 (READ-ONLY) |
| **metis** | Claude Opus 4.5 Thinking | max | 0.5 | 计划顾问 |
| **momus** | Claude Opus 4.5 Thinking | max | 0.2 | 计划审查 |
| **oracle** | Claude Opus 4.5 Thinking | max | 0.4 | 设计/调试 |
| **librarian** | Claude Opus 4.5 Thinking | max | 0.3 | 研究专家 |
| **explore** | Gemini 3 Flash | - | 0.1 | 快速搜索 |
| **multimodal-looker** | Gemini 3 Flash | - | 0.3 | 媒体分析 |
| **atlas** | Claude Opus 4.5 Thinking | max | 0.5 | 执行协调 |

#### Alibaba 优先配置

| Agent | 模型 | 温度 | 用途 |
|-------|------|------|------|
| **sisyphus** | GLM-4.7 | 0.7 | 主协调器 |
| **build** | QWen3 Code | 0.3 | 默认编码 |
| **plan** | GLM-4.7 | 0.5 | 战略规划 |
| **prometheus** | GLM-4.7 | 0.3 | 计划师 (READ-ONLY) |
| **metis** | GLM-4.7 | 0.5 | 计划顾问 |
| **momus** | GLM-4.7 | 0.2 | 计划审查 |
| **oracle** | GLM-4.7 | 0.4 | 设计/调试 |
| **librarian** | GLM-4.7 | 0.3 | 研究专家 |
| **explore** | MiniMax-M2.1 | 0.1 | 快速搜索 |
| **multimodal-looker** | MiniMax-M2.1 | 0.3 | 媒体分析 |
| **atlas** | GLM-4.7 | 0.5 | 执行协调 |

### Category 配置策略

#### Antigravity 优先配置

| Category | 模型 | Variant | 温度 | 用途 |
|----------|------|---------|------|------|
| **visual-engineering** | Gemini 3 Pro | high | 0.6 | 前端 UI/UX |
| **ultrabrain** | Claude Opus 4.5 Thinking | max | 0.5 | 深度逻辑推理 |
| **artistry** | Claude Opus 4.5 Thinking | max | 0.9 | 创意任务 |
| **quick** | Gemini 3 Flash | - | 0.2 | 简单任务 |
| **unspecified-low** | Gemini 3 Flash | - | 0.4 | 通用低工作量 |
| **unspecified-high** | Claude Sonnet 4.5 Thinking | max | 0.5 | 通用高工作量 |
| **writing** | Gemini 3 Flash | - | 0.7 | 文档写作 |
| **deep** | Claude Opus 4.5 Thinking | max | 0.5 | 自主问题解决 |

#### Alibaba 优先配置

| Category | 模型 | 温度 | 推理力度 | 用途 |
|----------|------|------|----------|------|
| **visual-engineering** | QWen3 Code | 0.6 | - | 前端 UI/UX |
| **ultrabrain** | GLM-4.7 | 0.5 | high | 深度逻辑推理 |
| **artistry** | GLM-4.7 | 0.9 | - | 创意任务 |
| **quick** | MiniMax-M2.1 | 0.2 | - | 简单任务 |
| **unspecified-low** | MiniMax-M2.1 | 0.4 | - | 通用低工作量 |
| **unspecified-high** | QWen3 Code | 0.5 | - | 通用高工作量 |
| **writing** | MiniMax-M2.1 | 0.7 | - | 文档写作 |
| **deep** | GLM-4.7 | 0.5 | high | 自主问题解决 |

---

## ⚡ 性能优化配置

### 后台任务并发
```json
"background_task": {
  "defaultConcurrency": 5,
  "providerConcurrency": {
    "google": 10,
    "alibaba-cn": 8
  },
  "modelConcurrency": {
    "google/antigravity-claude-opus-4-5-thinking": 3,
    "google/antigravity-claude-sonnet-4-5-thinking": 5,
    "google/antigravity-gemini-3-pro": 5,
    "google/antigravity-gemini-3-flash": 15,
    "alibaba-cn/glm-4.7": 3,
    "alibaba-cn/qwen-coder-plus": 5,
    "alibaba-cn/MiniMax-M2.1": 10
  }
}
```

### 动态上下文修剪
```json
"experimental": {
  "dynamic_context_pruning": {
    "enabled": true,
    "notification": "detailed",
    "turn_protection": { "enabled": true, "turns": 3 },
    "strategies": {
      "deduplication": { "enabled": true },
      "supersede_writes": { "enabled": true },
      "purge_errors": { "enabled": true },
      "remove_unchanged_files": { "enabled": true }
    }
  }
}
```

---

## 🎯 最佳实践

### 1. 使用 Category 而非直接指定模型
**推荐:**
```typescript
delegate_task(category="quick", prompt="Fix typo in README.md")
```

**不推荐:**
```typescript
delegate_task(subagent_type="build", load_skills=[], prompt="Fix typo...")
```

### 2. 组合 Category + Skills
```typescript
// 前端开发 + UI 设计 + 浏览器验证
delegate_task(
  category="visual-engineering",
  load_skills=["frontend-ui-ux", "playwright"],
  prompt="Create responsive navbar with animations"
)

// Git 提交
delegate_task(
  category="quick",
  load_skills=["git-master"],
  prompt="Commit changes with proper message"
)
```

### 3. 深度推理任务
```typescript
delegate_task(
  category="ultrabrain",
  prompt="Design microservices architecture for large-scale app"
)
```

### 4. 计划驱动开发
1. 使用 `@plan` 启动 Prometheus 计划
2. 使用 `/start-work` 执行计划
3. Atlas 自动协调专门 Agent

### 5. 配置切换策略
- **默认使用 Antigravity 优先**，充分利用免费额度
- **当 Antigravity 额度用完后**，切换到 Alibaba 优先配置
- **定期检查额度**：运行 `opencode auth login` → "Check quotas"

---

## 🔍 工作流示例

### 场景 1: 快速修复
```typescript
delegate_task(category="quick", prompt="Fix broken API endpoint")
// Antigravity: Gemini 3 Flash
// Alibaba: MiniMax-M2.1
```

### 场景 2: 前端重构
```typescript
delegate_task(
  category="visual-engineering",
  load_skills=["frontend-ui-ux"],
  prompt="Refactor dashboard with modern UI"
)
// Antigravity: Gemini 3 Pro (high)
// Alibaba: QWen3 Code
```

### 场景 3: 架构设计
```typescript
delegate_task(
  category="ultrabrain",
  prompt="Design event-driven architecture for real-time system"
)
// Antigravity: Claude Opus 4.5 Thinking (max)
// Alibaba: GLM-4.7
```

### 场景 4: 研究与实现
```typescript
// 并行运行
delegate_task(subagent_type="explore", run_in_background=true, prompt="Find existing auth patterns")
delegate_task(subagent_type="librarian", run_in_background=true, prompt="Find OAuth best practices")
// Antigravity: Gemini 3 Flash + Claude Opus 4.5 Thinking
// Alibaba: MiniMax-M2.1 + GLM-4.7
```

### 场景 5: 配额耗尽处理
```bash
# 1. 检查额度
opencode auth login
# 选择 "Check quotas"

# 2. 如果 Antigravity 额度用完
~/.config/opencode/switch-opencode-config.sh

# 3. 重启 OpenCode
# 配置自动切换到 Alibaba 优先
```

---

## 📌 注意事项

1. **环境变量**: 确保设置了 `DASHSCOPE_API_KEY`
2. **Google Auth**: 已配置 `opencode-antigravity-auth` 插件和 4 个 Google 帐号
3. **自动更新**: 已启用，保持最新版本
4. **Hooks**: 所有关键 hooks 已启用，建议保持
5. **配置切换**: 切换配置后需要重启 OpenCode 才能生效
6. **额度管理**: Antigravity 额度用完后需要手动切换到 Alibaba 配置
7. **备份**: 原配置已自动备份到 `oh-my-opencode.json.bak.*`

---

## 🎉 配置完成

配置已优化完成！重启 OpenCode 后即可使用。

### 快速验证
```bash
# 查看当前配置状态
~/.config/opencode/switch-opencode-config.sh status

# 查看可用模型
opencode models

# 查看可用 Agent
opencode agents

# 检查 Antigravity 额度
opencode auth login
# 选择 "Check quotas"
```

### 配置切换
```bash
# 切换到另一个配置
~/.config/opencode/switch-opencode-config.sh

# 重启 OpenCode 使配置生效
```

### 享受高效编码体验！🚀

---

## 📚 相关资源

- [opencode-antigravity-auth 文档](https://github.com/NoeFabris/opencode-antigravity-auth)
- [oh-my-opencode 文档](https://github.com/code-yeongyu/oh-my-opencode)
- [OpenCode 官方文档](https://opencode.ai/docs/)