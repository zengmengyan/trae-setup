#!/bin/bash
# ============================================================
# trae-setup - 为项目安装 Trae Skills 和 MCP 配置
# 仓库: https://github.com/zengmengyan/trae-setup
# ============================================================
# 用法:
#   bash install.sh                    # 安装 Skills + MCP 到当前目录
#   bash install.sh ./my-project       # 安装 Skills + MCP 到指定项目
#   bash install.sh --skills           # 仅安装 Skills
#   bash install.sh --mcps             # 仅安装 MCP
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_DIR="$(pwd)"
INSTALL_SKILLS=true
INSTALL_MCPS=true

while [ $# -gt 0 ]; do
  case "$1" in
    --skills) INSTALL_MCPS=false; shift 1 ;;
    --mcps) INSTALL_SKILLS=false; shift 1 ;;
    -h|--help)
      echo "用法:"
      echo "  bash install.sh                安装 Skills + MCP 到当前项目"
      echo "  bash install.sh ./project      安装 Skills + MCP 到指定项目"
      echo "  bash install.sh --skills       仅安装 Skills"
      echo "  bash install.sh --mcps         仅安装 MCP"
      exit 0 ;;
    -*)
      echo "未知参数: $1"
      exit 1 ;;
    *)
      PROJECT_DIR="$1"
      shift 1 ;;
  esac
done

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║     Trae Setup - 项目配置工具            ║"
echo "  ║     https://github.com/zengmengyan/trae-setup  ║"
 echo "  ╚══════════════════════════════════════════╝"
echo ""
echo "  目标项目: $PROJECT_DIR"
echo ""

if [ ! -d "$PROJECT_DIR" ]; then
  echo "[错误] 项目目录不存在: $PROJECT_DIR"
  exit 1
fi

DOT_TRAE_DIR="$PROJECT_DIR/.trae"
mkdir -p "$DOT_TRAE_DIR"

# ---- 安装 Skills ----
if [ "$INSTALL_SKILLS" = true ]; then
  SKILLS_SRC="$SCRIPT_DIR/skills"
  SKILLS_DST="$DOT_TRAE_DIR/skills"
  echo ">> 安装 Skills 到: $SKILLS_DST"
  echo ""

  if [ ! -d "$SKILLS_SRC" ]; then
    echo "   [错误] 未找到 Skills 目录: $SKILLS_SRC"
  else
    INSTALLED=0
    for skill_dir in "$SKILLS_SRC"/*/; do
      [ ! -d "$skill_dir" ] && continue
      name="$(basename "$skill_dir")"
      [ ! -f "$skill_dir/SKILL.md" ] && echo "   [跳过] $name" && continue
      mkdir -p "$SKILLS_DST/$name"
      cp "$skill_dir/SKILL.md" "$SKILLS_DST/$name/SKILL.md"
      echo "   [✓] $name"
      INSTALLED=$((INSTALLED + 1))
    done
    echo ""
    echo "   安装完成: $INSTALLED 个 Skill"
  fi
fi

# ---- 安装 MCP ----
if [ "$INSTALL_MCPS" = true ]; then
  echo ""
  echo ">> 安装 MCP 配置到: $DOT_TRAE_DIR/mcp.json"
  echo ""

  MCPS_SRC="$SCRIPT_DIR/mcps"
  if [ ! -d "$MCPS_SRC" ]; then
    echo "   [错误] 未找到 MCP 模板目录: $MCPS_SRC"
  else
    INSTALLED=0
    # 合并所有 mcp.json 中的 mcpServers
    MERGED=$(cat <<'EOF'
{
  "mcpServers": {
EOF
)
    FIRST=true
    for mcp_dir in "$MCPS_SRC"/*/; do
      [ ! -d "$mcp_dir" ] && continue
      json_file="$mcp_dir/mcp.json"
      [ ! -f "$json_file" ] && continue

      name="$(basename "$mcp_dir")"
      # 提取 mcpServers 内容
      CONTENT=$(python3 -c "
import json
with open('$json_file') as f:
    data = json.load(f)
servers = data.get('mcpServers', {})
print(json.dumps(servers, indent=4))
" 2>/dev/null || cat "$json_file")

      echo "   [✓] $name"
      INSTALLED=$((INSTALLED + 1))
    done

    if [ $INSTALLED -gt 0 ]; then
      echo ""
      echo "   模板已加载，请手动合并到 $DOT_TRAE_DIR/mcp.json"
      echo "   注意: 需要填入你的 API Token"
    fi
  fi
fi

echo ""
echo "  ✅ 项目配置完成！"
echo ""
echo "  后续步骤:"
echo "    1. 编辑 .trae/mcp.json 填入 API Token"
echo "    2. 执行 git add .trae/ 添加到版本管理"
echo "    3. 推送代码到远程仓库"
