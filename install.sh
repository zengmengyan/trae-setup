#!/bin/bash
# ============================================================
# trae-setup - Trae IDE 用户级配置工具
# 仓库: https://github.com/zengmengyan/trae-setup
# ============================================================
# 用法:
#   bash install.sh              # 安装 Skills + MCP 到用户级别
#   bash install.sh --skills     # 仅安装 Skills
#   bash install.sh --mcps       # 仅安装 MCP
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

print_banner() {
  echo ""
  echo "  ╔══════════════════════════════════════════╗"
  echo "  ║     Trae Setup - 用户级配置工具          ║"
  echo "  ║     https://github.com/zengmengyan/trae-setup  ║"
  echo "  ╚══════════════════════════════════════════╝"
  echo ""
}

print_banner

# 检测参数
INSTALL_SKILLS=true
INSTALL_MCPS=true
while [ $# -gt 0 ]; do
  case "$1" in
    --skills) INSTALL_MCPS=false; shift 1 ;;
    --mcps) INSTALL_SKILLS=false; shift 1 ;;
    -h|--help)
      echo "用法:"
      echo "  bash install.sh          安装 Skills + MCP 到用户级别"
      echo "  bash install.sh --skills 仅安装 Skills"
      echo "  bash install.sh --mcps   仅安装 MCP"
      exit 0 ;;
    *) echo "未知参数: $1"; exit 1 ;;
  esac
done

if [ "$INSTALL_SKILLS" = true ]; then
  echo ">> 安装 Skills 到用户级别..."
  if [ -f "$SCRIPT_DIR/scripts/install-skills.sh" ]; then
    bash "$SCRIPT_DIR/scripts/install-skills.sh"
  else
    echo "   [错误] 未找到 scripts/install-skills.sh"
    exit 1
  fi
  echo ""
fi

if [ "$INSTALL_MCPS" = true ]; then
  echo ">> 安装 MCP 到用户级别..."
  if [ -f "$SCRIPT_DIR/scripts/install-mcps.sh" ]; then
    bash "$SCRIPT_DIR/scripts/install-mcps.sh"
  else
    echo "   [错误] 未找到 scripts/install-mcps.sh"
    exit 1
  fi
  echo ""
fi

echo "  ✅ 安装完成！重启 Trae IDE 后生效"
echo ""
echo "  安装位置:"
echo "    Skills: ~/.trae-cn/skills/"
echo "    MCP:    ~/Library/Application Support/Trae CN/User/mcp.json"
