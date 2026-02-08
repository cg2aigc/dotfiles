# OpenCode Configuration Switcher 使用说明

## 📋 概述

`switch-opencode-config.sh` 是一个灵活的 OpenCode 配置管理工具，支持多个配置文件的快速切换。

## 🚀 特性

- ✅ **自动发现配置**：自动扫描 `oh-my-opencode-*.json` 模式的配置文件
- ✅ **灵活切换**：支持指定配置名称切换或循环切换
- ✅ **状态查看**：显示当前激活的配置及其详细信息
- ✅ **配置列表**：列出所有可用的配置文件
- ✅ **易于扩展**：新增配置只需添加符合命名模式的文件
- ✅ **自动备份**：切换前自动备份非符号链接的配置文件

## 📁 文件要求

配置文件必须遵循命名模式：`oh-my-opencode-*.json`

示例：
- `oh-my-opencode-antigravity.json`
- `oh-my-opencode-alibaba.json`
- `oh-my-opencode-custom-profile.json`

## 🎯 使用方法

### 查看帮助

```bash
~/.config/opencode/switch-opencode-config.sh --help
~/.config/opencode/switch-opencode-config.sh -h
```

### 查看当前配置状态

```bash
~/.config/opencode/switch-opencode-config.sh status
```

输出示例：
```
========================================
  OpenCode Configuration Status
========================================

Current config: oh-my-opencode-antigravity.json

Description: Antigravity priority - Claude Opus/Sonnet + Gemini 3

Active models:
  • Reasoning agents: Claude Opus 4.5 Thinking
  • Coding agents:    Claude Sonnet 4.5 Thinking
  • UI/UX tasks:      Gemini 3 Pro
  • Quick tasks:      Gemini 3 Flash
```

### 列出所有可用配置

```bash
~/.config/opencode/switch-opencode-config.sh list
```

输出示例：
```
========================================
  Available Configuration Profiles
========================================

Found 2 configuration profile(s):

[1] alibaba
    File: oh-my-opencode-alibaba.json
    Desc: Alibaba priority - GLM-4.7 + QWen3 Code + MiniMax

[2] antigravity (active)
    File: oh-my-opencode-antigravity.json
    Desc: Antigravity priority - Claude Opus/Sonnet + Gemini 3
```

### 切换到指定配置

```bash
# 切换到 Antigravity 优先配置
~/.config/opencode/switch-opencode-config.sh switch antigravity

# 切换到 Alibaba 优先配置
~/.config/opencode/switch-opencode-config.sh switch alibaba
```

### 循环切换配置

```bash
# 在配置之间循环切换
~/.config/opencode/switch-opencode-config.sh switch
```

不带参数的 `switch` 命令会自动切换到列表中的下一个配置。

## 🔧 添加新配置

### 步骤

1. **创建配置文件**

```bash
# 在 ~/.config/opencode/ 目录下创建新配置
cp ~/.config/opencode/oh-my-opencode-antigravity.json \
   ~/.config/opencode/oh-my-opencode-my-custom-profile.json
```

2. **编辑配置文件**

```bash
vim ~/.config/opencode/oh-my-opencode-my-custom-profile.json
```

3. **验证配置**

```bash
# 列出所有配置，确认新配置已被发现
~/.config/opencode/switch-opencode-config.sh list
```

4. **切换到新配置**

```bash
~/.config/opencode/switch-opencode-config.sh switch my-custom-profile
```

### 配置文件命名规范

- 必须以 `oh-my-opencode-` 开头
- 必须以 `.json` 结尾
- 中间部分是配置名称（用于切换命令）

示例：
- ✅ `oh-my-opencode-antigravity.json`
- ✅ `oh-my-opencode-alibaba.json`
- ✅ `oh-my-opencode-custom-profile.json`
- ❌ `my-config.json`（不符合命名模式）
- ❌ `oh-my-opencode.json`（这是符号链接，不是配置文件）

## 📝 配置描述

脚本会自动为配置文件生成描述信息：

1. **优先从 JSON 文件中提取**：如果配置文件中包含 `"description"` 字段
2. **基于文件名生成**：根据文件名中的关键词（antigravity/alibaba）生成描述

### 自定义描述

在配置文件的 JSON 中添加 `description` 字段：

```json
{
  "$schema": "https://raw.githubusercontent.com/code-yeongyu/oh-my-opencode/master/assets/oh-my-opencode.schema.json",
  "description": "My custom configuration profile",
  ...
}
```

## ⚠️ 注意事项

1. **重启 OpenCode**：切换配置后需要重启 OpenCode 才能生效
2. **备份机制**：脚本会自动备份非符号链接的配置文件
3. **权限要求**：确保脚本有执行权限（`chmod +x switch-opencode-config.sh`）
4. **配置路径**：所有配置文件必须放在 `~/.config/opencode/` 目录下

## 🎨 输出颜色说明

脚本使用颜色编码来区分不同类型的信息：

- 🟢 **绿色**：成功信息、当前激活的配置
- 🔵 **蓝色**：一般信息
- 🟡 **黄色**：警告信息
- 🔴 **红色**：错误信息
- 🔵 **青色**：描述信息
- **粗体**：标题和重要信息

## 🔍 故障排除

### 配置文件未被发现

**问题**：`list` 命令没有显示你的配置文件

**解决方案**：
1. 检查文件命名是否符合模式 `oh-my-opencode-*.json`
2. 确认文件在正确的目录：`~/.config/opencode/`
3. 检查文件权限：`ls -la ~/.config/opencode/oh-my-opencode-*.json`

### 切换失败

**问题**：切换配置时出现错误

**解决方案**：
1. 确认配置名称正确（使用 `list` 命令查看）
2. 检查目标配置文件是否存在
3. 查看错误信息以获取更多详情

### 符号链接问题

**问题**：配置切换后 OpenCode 没有使用新配置

**解决方案**：
1. 确认符号链接正确：`ls -la ~/.config/opencode/oh-my-opencode.json`
2. 重启 OpenCode
3. 检查 OpenCode 配置缓存

## 📚 相关文档

- [OpenCode 配置指南](./CONFIGURATION_GUIDE.md)
- [opencode-antigravity-auth 文档](https://github.com/NoeFabris/opencode-antigravity-auth)
- [oh-my-opencode 文档](https://github.com/code-yeongyu/oh-my-opencode)

## 💡 最佳实践

1. **定期检查额度**：使用 `opencode auth login` 检查 Antigravity 额度
2. **及时切换配置**：额度用完后及时切换到备用配置
3. **备份重要配置**：定期备份自定义配置文件
4. **测试新配置**：切换前先验证配置文件的正确性

## 🎉 开始使用

```bash
# 查看帮助
~/.config/opencode/switch-opencode-config.sh --help

# 查看当前状态
~/.config/opencode/switch-opencode-config.sh status

# 列出所有配置
~/.config/opencode/switch-opencode-config.sh list

# 切换配置
~/.config/opencode/switch-opencode-config.sh switch <config-name>
```

享受灵活的配置管理！🚀