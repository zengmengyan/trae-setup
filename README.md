# Trae Setup

Trae IDE 用户级配置工具 — 一条命令安装 Skills 和 MCP 到用户级别，所有项目自动可用。

## 快速开始

```bash
git clone https://github.com/zengmengyan/trae-setup.git
cd trae-setup
bash install.sh
# 重启 Trae IDE ✓
```

## 命令选项

| 命令 | 说明 |
|------|------|
| `bash install.sh` | 安装 Skills + MCP 到用户级别 |
| `bash install.sh --skills` | 仅安装 Skills |
| `bash install.sh --mcps` | 仅安装 MCP |

## 安装位置

| 配置 | 路径 | 作用范围 |
|------|------|---------|
| **Skills** | `~/.trae-cn/skills/` | 所有项目 |
| **MCP** | `~/Library/Application Support/Trae CN/User/mcp.json` | 所有项目 |

## 安装内容

### Skills

| Skill | 说明 |
|-------|------|
| **frontend-design** | 高质量前端界面设计，避免通用 AI 审美 |

### MCP

| MCP Server | 功能 |
|-----------|------|
| **GitHub** | 仓库管理、Issue/PR、代码搜索 |

安装 MCP 前请先在 `mcps/github/mcp.json` 中填入你的 `GITHUB_TOKEN`。

## 新电脑迁移流程

```bash
# 1. 安装 Trae IDE
# 2. 克隆本仓库
git clone https://github.com/zengmengyan/trae-setup.git
cd trae-setup

# 3. 填写 API Token（如果配置了 MCP）
vim mcps/github/mcp.json

# 4. 一键安装
bash install.sh

# 5. 重启 Trae IDE ✓
```

## 配置结构

```
trae-setup/
├── install.sh                   # 主安装脚本
├── scripts/
│   ├── install-skills.sh        # 安装 Skills 到 ~/.trae-cn/skills/
│   └── install-mcps.sh          # 合并 MCP 到用户 mcp.json
├── skills/<name>/SKILL.md       # Skill 模板
└── mcps/<name>/mcp.json         # MCP 模板
```

## 注意

- `mcp.json` 中包含 API Token 等敏感信息，**不要提交到 Git 仓库**
- 本仓库已将 `mcps/` 目录加入 `.gitignore` 以防意外提交 Token
- 每次安装会**合并** MCP 配置，不会覆盖已有的其他 MCP Server