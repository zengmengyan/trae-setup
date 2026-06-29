# Trae Setup

Trae IDE 配置工具 — 一条命令安装 Skills 和 MCP，支持全局和项目级别。

## 快速开始

```bash
git clone https://github.com/zengmengyan/trae-setup.git
cd trae-setup

# 初始化 Token 配置
bash install.sh --init

# 编辑 .mcp.env 填入你的 GitHub Token，然后：
bash install.sh
# 重启 Trae IDE ✓
```

## 命令选项

### 主命令

| 命令 | 说明 |
|------|------|
| `bash install.sh` | 安装 Skills + MCP（全局 + 项目） |
| `bash install.sh --skills` | 仅安装 Skills（全局 + 项目） |
| `bash install.sh --skills-global` | 仅安装 Skills（全局） |
| `bash install.sh --skills-project [路径]` | 仅安装 Skills（项目） |
| `bash install.sh --mcps` | 仅安装 MCP（全局 + 项目） |
| `bash install.sh --mcps-global` | 仅安装 MCP（全局） |
| `bash install.sh --mcps-project [路径]` | 仅安装 MCP（项目） |
| `bash install.sh --init` | 初始化 `.mcp.env` 配置 |

### Skills 安装选项

也可直接调用 `scripts/install-skills.sh`：

| 命令 | 说明 |
|------|------|
| `bash scripts/install-skills.sh` | 安装到全局 + 当前项目 |
| `bash scripts/install-skills.sh --global` | 仅安装到全局 |
| `bash scripts/install-skills.sh --project /path` | 仅安装到指定项目 |

### MCP 安装选项

也可直接调用 `scripts/install-mcps.sh`：

| 命令 | 说明 |
|------|------|
| `bash scripts/install-mcps.sh` | 安装到全局 + 当前项目 |
| `bash scripts/install-mcps.sh --global` | 仅安装到全局 |
| `bash scripts/install-mcps.sh --project /path` | 仅安装到指定项目 |
| `bash scripts/install-mcps.sh --init` | 初始化 `.mcp.env` 配置 |

## 安装位置

| 配置 | 路径 | 作用范围 |
|------|------|---------|
| **Skills（全局）** | `~/.trae-cn/skills/` | 所有项目 |
| **Skills（项目）** | `<project>/.trae/skills/` + `<project>/.agents/skills/` | 当前项目 |
| **MCP（全局）** | `~/Library/Application Support/Trae CN/User/mcp.json` | 所有项目 |
| **MCP（项目）** | `<project>/.trae/mcps/mcp.json` | 当前项目 |

## 安装内容

### Skills

| Skill | 说明 |
|-------|------|
| **frontend-design** | 高质量前端界面设计，避免通用 AI 审美 |
| **cache-components** | Next.js Cache Components 和 PPR 专家指导 |

### MCP

| MCP Server | 功能 |
|-----------|------|
| **GitHub** | 仓库管理、Issue/PR、代码搜索 |

## Token 配置

安装 MCP 前，需要先配置 Token。有两种方式：

### 方式一：一键初始化（推荐）

```bash
bash install.sh --init
```

编辑生成的 `.mcp.env` 文件，填入你的 Token 值：

```bash
GITHUB_TOKEN=ghp_your_github_token_here
```

### 方式二：手动创建

```bash
cp .mcp.env.example .mcp.env
vim .mcp.env
```

`.mcp.env` 已被 `.gitignore` 忽略，不会提交到 Git 仓库。

## 新电脑迁移流程

```bash
# 1. 安装 Trae IDE
# 2. 克隆本仓库
git clone https://github.com/zengmengyan/trae-setup.git
cd trae-setup

# 3. 初始化并填写 Token
bash install.sh --init
vim .mcp.env

# 4. 一键安装
bash install.sh

# 5. 重启 Trae IDE ✓
```

## 配置结构

```
trae-setup/
├── install.sh                   # 主安装脚本
├── .mcp.env                     # Token 配置（不提交到 Git）
├── .mcp.env.example             # Token 配置模板
├── .gitignore
├── scripts/
│   ├── install-skills.sh        # 安装 Skills（支持全局/项目级别）
│   └── install-mcps.sh          # 安装 MCP（支持全局/项目级别）
├── mcps/
│   └── <name>/
│       ├── mcp.json             # MCP 模板（{{TOKEN}} 占位符）
│       └── ...                  # 关联工具定义
├── skills/
│   └── <name>/
│       └── SKILL.md             # Skill 模板
└── README.md
```

## 注意

- Token 通过 `.mcp.env` 管理，该文件已加入 `.gitignore`，**不会提交到 Git**
- MCP 模板使用 `{{TOKEN_NAME}}` 占位符，安装时自动替换为 `.mcp.env` 中的实际值
- 每次安装会**合并**现有 MCP 配置，不会覆盖已有的其他 MCP Server
