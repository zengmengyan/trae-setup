# Trae Setup

Trae IDE 项目配置工具 — 为你的项目安装 Skills 和 MCP 配置，随 Git 版本管理，团队共享。

## 快速开始

```bash
# 1. 克隆本仓库
git clone https://github.com/zengmengyan/trae-setup.git

# 2. 为你的项目安装配置
cd your-project
bash ../trae-setup/install.sh

# 3. 编辑 .trae/mcp.json 填入 API Token

# 4. 提交到你的项目仓库
git add .trae/
git commit -m "chore: 添加 Trae 项目配置"
```

## 命令选项

| 命令 | 说明 |
|------|------|
| `bash install.sh` | 安装 Skills + MCP 到当前目录 |
| `bash install.sh ./my-project` | 安装到指定项目 |
| `bash install.sh --skills` | 仅安装 Skills |
| `bash install.sh --mcps` | 仅安装 MCP |

## 安装内容

### Skills（项目级 `.trae/skills/`）

| Skill | 说明 |
|-------|------|
| **frontend-design** | 高质量前端界面设计，避免通用 AI 审美 |

### MCP（项目级 `.trae/mcp.json`）

| MCP Server | 说明 |
|-----------|------|
| **GitHub** | GitHub API 集成：仓库管理、Issue/PR、代码搜索 |

## 新电脑迁移流程

```bash
# 克隆项目
git clone your-project.git
cd your-project

# .trae/ 目录已经在项目中，直接可用
# 只需在 IDE 设置中重新配置 MCP 的 API Token
```

> MCP 的 Token 是敏感信息，建议通过环境变量或 IDE 设置配置，不要提交到 Git。

## 配置结构

```
trae-setup/                    # 本仓库（配置模板源）
├── install.sh
├── skills/<name>/SKILL.md
└── mcps/<name>/mcp.json

your-project/                  # 你的项目（安装目标）
└── .trae/
    ├── skills/<name>/SKILL.md
    └── mcp.json
```

## 贡献配置

欢迎提交 PR 贡献更多 Skill 和 MCP 模板：

```
trae-setup/
├── skills/<name>/SKILL.md      # 添加 Skill
└── mcps/<name>/mcp.json        # 添加 MCP 模板
```