# Trae Setup

Trae IDE 一键配置工具 — 一条命令安装全局 Skills 和 MCP 配置，让新电脑快速复用开发环境。

## 快速开始

```bash
git clone https://github.com/zengmengyan/trae-setup.git
cd trae-setup
bash install.sh
```

## 命令选项

| 命令 | 说明 |
|------|------|
| `bash install.sh` | 安装全局 Skills |
| `bash install.sh --skills` | 仅安装 Skills |
| `bash install.sh --mcps` | 安装 MCP 到当前项目 `.trae/mcps/` |
| `bash install.sh --mcps ./project` | 安装 MCP 到指定项目 |
| `bash install.sh --mcps-global` | **安装 MCP 到全局**（所有项目可用） |
| `bash install.sh --all ./project` | 安装 Skills + MCP |

## 安装内容

### Skills（全局安装到 `~/.trae-cn/skills/`）

所有 Trae IDE 项目均可使用，重启 IDE 后生效。

| Skill | 说明 |
|-------|------|
| **frontend-design** | 高质量前端界面设计，避免通用 AI 审美 |

### MCP（可选：项目级或全局）

| 安装方式 | 路径 | 适用场景 |
|---------|------|---------|
| `--mcps` | `.trae/mcps/`（项目级） | 随 Git 版本管理，团队共享 |
| `--mcps-global` | `~/.trae-cn/mcps/`（全局） | 所有项目自动可用，个人全局配置 |

| MCP Server | 说明 |
|-----------|------|
| **GitHub** | GitHub API 集成：仓库管理、Issue/PR 操作、代码搜索等 |

## 新电脑迁移流程

```bash
# 1. 安装 Trae IDE
# 2. 克隆配置仓库
git clone https://github.com/zengmengyan/trae-setup.git
cd trae-setup

# 3. 安装全局 Skills
bash install.sh

# 4. 安装全局 MCP（可选，所有项目共用）
bash install.sh --mcps-global

# 5. 重启 Trae IDE ✓
```

> 如果你希望 MCP 跟随项目走（Git 版本管理），使用 `bash install.sh --mcps` 安装到项目级别即可。

## 贡献配置

欢迎提交 PR 贡献更多 Skill 和 MCP 配置：

```
trae-setup/
├── skills/<name>/SKILL.md
└── mcps/<name>/solo_agent/<server>/...
```