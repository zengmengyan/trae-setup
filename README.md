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
| `bash install.sh` | 安装 Skills（默认） |
| `bash install.sh --skills` | 仅安装 Skills |
| `bash install.sh --mcps` | 安装 MCP 到当前项目 |
| `bash install.sh --mcps ./project` | 安装 MCP 到指定项目 |
| `bash install.sh --all ./project` | 安装 Skills + MCP 到指定项目 |

## 安装内容

### Skills（全局安装到 `~/.trae-cn/skills/`）

| Skill | 说明 |
|-------|------|
| **frontend-design** | 高质量前端界面设计，避免通用 AI 审美 |

### MCP（项目级安装到 `.trae/mcps/`）

| MCP Server | 说明 |
|-----------|------|
| **GitHub** | GitHub API 集成工具箱 |

## 新电脑迁移流程

```bash
# 1. 安装 Trae IDE
# 2. 克隆配置仓库
git clone https://github.com/zengmengyan/trae-setup.git
cd trae-setup

# 3. 安装全局 Skills
bash install.sh

# 4. 克隆项目并安装 MCP
git clone <your-project>
cd <your-project>
bash ../trae-setup/install.sh --mcps

# 5. 重启 Trae IDE ✓
```

## 贡献配置

添加自定义 Skill 或 MCP 后提交 PR：

```
trae-setup/
├── skills/<name>/SKILL.md
└── mcps/<name>/solo_agent/<server>/...
```