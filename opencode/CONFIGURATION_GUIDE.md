# OpenCode + Oh My OpenCode 高阶配置说明

## 📋 配置概览

本配置为 OpenCode 和 oh-my-opencode 插件提供最大化性能和优化的高阶配置。

---

## 🚀 配置亮点

### 1. 智能模型分配
- **推理/架构类**: GLM-4.7 (深度推理)
- **编码/实现类**: QWen3 Code (专注编码)
- **快速处理类**: MiniMax-M2.1 (高效低成本)

### 2. 完整 Agent 生态系统
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

### 4. 性能优化
- 动态上下文修剪
- 后台任务并发控制
- 智能去重和错误清除
- 会话恢复机制

---

## 📦 opencode.json 配置

### 模型定义

#### Google Provider
```json
"google": {
  "models": {
    "antigravity-gemini-3-pro-high": { "thinking": true },
    "antigravity-gemini-3-pro-low": { "thinking": true },
    "antigravity-gemini-3-flash": { } // 快速响应
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

## 🔧 oh-my-opencode.json 配置

### Agent 配置策略

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

| Category | 模型 | 温度 | 推理力度 | 用途 |
|----------|------|------|----------|------|
| **visual-engineering** | QWen3 Code | 0.6 | - | 前端 UI/UX |
| **ultrabrain** | GLM-4.7 | 0.5 | high | 深度逻辑推理 |
| **artistry** | GLM-4.7 | 0.9 | - | 创意任务 |
| **quick** | MiniMax-M2.1 | 0.2 | - | 简单任务 |
| **unspecified-low** | MiniMax-M2.1 | 0.4 | - | 通用低工作量 |
| **unspecified-high** | GLM-4.7 | 0.5 | - | 通用高工作量 |
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
    "alibaba-cn/glm-4.7": 3,              // 限制昂贵模型
    "alibaba-cn/qwen-coder-plus": 5,      // 平衡
    "alibaba-cn/MiniMax-M2.1": 10,        // 允许更多并发
    "google/antigravity-gemini-3-flash": 15 // 快速模型
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

---

## 🔍 工作流示例

### 场景 1: 快速修复
```typescript
delegate_task(category="quick", prompt="Fix broken API endpoint")
// 自动使用 MiniMax-M2.1，低成本快速完成
```

### 场景 2: 前端重构
```typescript
delegate_task(
  category="visual-engineering",
  load_skills=["frontend-ui-ux"],
  prompt="Refactor dashboard with modern UI"
)
// 自动使用 QWen3 Code，注入设计思维
```

### 场景 3: 架构设计
```typescript
delegate_task(
  category="ultrabrain",
  prompt="Design event-driven architecture for real-time system"
)
// 自动使用 GLM-4.7，深度推理
```

### 场景 4: 研究与实现
```typescript
// 并行运行
delegate_task(subagent_type="explore", run_in_background=true, prompt="Find existing auth patterns")
delegate_task(subagent_type="librarian", run_in_background=true, prompt="Find OAuth best practices")
// 快速探索 + 深度研究
```

---

## 📌 注意事项

1. **环境变量**: 确保设置了 `DASHSCOPE_API_KEY`
2. **Google Auth**: 建议使用 `opencode-antigravity-auth` 插件
3. **自动更新**: 已启用，保持最新版本
4. **Hooks**: 所有关键 hooks 已启用，建议保持

---

## 🎉 配置完成

配置已优化完成！重启 OpenCode 后即可使用。

### 快速验证
```bash
opencode models          # 查看可用模型
opencode agents         # 查看可用 Agent
```

### 享受高效编码体验！🚀