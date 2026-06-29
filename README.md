# Trae Setup

Trae IDE 一键配置工具 — 一条命令安装全局 Skills，快速迁移开发环境。

## 快速开始

```bash
git clone https://github.com/zengmengyan/trae-setup.git
cd trae-setup

# 安装全局 Skills
bash install.sh

# 重启 Trae IDE ✓
```

## 命令选项

| 命令 | 说明 |
|------|------|
| `bash install.sh` | 安装全局 Skills |
| `bash install.sh --mcps` | 查看 MCP 模板配置 |
| `bash install.sh --mcps ./project` | 安装 MCP 到指定项目 |

## 安装内容

### Skills（全局安装到 `~/.trae-cn/skills/`）

所有 Trae IDE 项目均可使用，重启 IDE 后生效。

| Skill | 说明 |
|-------|------|
| **frontend-design** | 高质量前端界面设计，避免通用 AI 审美 |

### MCP 配置

根据 [Trae 官方文档](https://docs.trae.cn/ide_add-mcp-servers)，MCP 的安装方式如下：

#### 项目级 MCP（团队共享）

在项目 `.trae/mcp.json` 中配置，提交到 Git 仓库后团队共享：

```json
{
  "mcpServers": {
    "mcp_GitHub": {
      "command": "npx",
      "args": ["-y", "@modelcontextprotocol/server-github"],
      "env": {
        "GITHUB_TOKEN": "<your-token>"
      }
    }
  }
}
```

使用 `bash install.sh --mcps ./project` 可生成模板。

#### 全局 MCP（所有项目可用）

通过 IDE 设置界面配置：

1. 打开 **Trae IDE** → **设置** → **MCP**
2. 点击 **添加** → **从市场添加**（或 **手动添加**）
3. 填入配置信息

> 注意：MCP 的全局配置需要用到 API Token/密钥等敏感信息，不适合提交到 Git 仓库，因此**只能通过 IDE 设置界面配置**。

## 新电脑迁移流程

```bash
# 1. 安装 Trae IDE
# 2. 克隆配置仓库
git clone https://github.com/zengmengyan/trae-setup.git
cd trae-setup

# 3. 安装全局 Skills（所有项目通用）
bash install.sh

# 4. 安装项目级 MCP（如需要）
bash install.sh --mcps ./my-project
# 然后编辑 .trae/mcp.json 填入 Token

# 5. 全局 MCP 需在 IDE 设置中重新配置
#    这是设计如此：Token 是敏感信息，不应提交到 Git

# 6. 重启 Trae IDE ✓
```

## 配置结构

```
trae-setup/
├── install.sh                   # 一键安装脚本
├── scripts/
│   ├── install-skills.sh        # 安装 Skills（全局）
│   └── install-mcps.sh          # 安装 MCP（项目级）
├── skills/
│   └── <name>/SKILL.md          # Skill 定义
└── mcps/
    └── <name>/mcp.json          # MCP 配置模板
```

## 贡献配置

欢迎提交 PR 贡献更多 Skill 和 MCP 模板。

> 参考文档：https://docs.trae.cn/ide_model-context-protocol