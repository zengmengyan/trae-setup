#!/bin/bash
# ============================================================
# trae-setup - Trae IDE 用户级配置工具
# 仓库: https://github.com/zengmengyan/trae-setup
# ============================================================
# 用法:
#   bash install.sh              # 安装 Skills + MCP（全局+项目）
#   bash install.sh --skills     # 仅安装 Skills
#   bash install.sh --mcps       # 仅安装 MCP（全局+项目）
#   bash install.sh --init       # 初始化 .mcp.env 配置
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
SKILLS_ARGS=""
MCP_ARGS=""
while [ $# -gt 0 ]; do
  case "$1" in
    --skills) INSTALL_MCPS=false; shift 1 ;;
    --skills-global) INSTALL_MCPS=false; SKILLS_ARGS="--global"; shift 1 ;;
    --skills-project) INSTALL_MCPS=false; SKILLS_ARGS="--project ${2:-.}"; shift 2 ;;
    --mcps) INSTALL_SKILLS=false; shift 1 ;;
    --mcps-global) INSTALL_SKILLS=false; MCP_ARGS="--global"; shift 1 ;;
    --mcps-project) INSTALL_SKILLS=false; MCP_ARGS="--project ${2:-.}"; shift 2 ;;
    --init)
      if [ -f "$SCRIPT_DIR/scripts/install-mcps.sh" ]; then
        bash "$SCRIPT_DIR/scripts/install-mcps.sh" --init
      fi
      exit 0 ;;
    -h|--help)
      echo "用法:"
      echo "  bash install.sh                       安装 Skills + MCP（全局+项目）"
      echo "  bash install.sh --skills              仅安装 Skills（全局+项目）"
      echo "  bash install.sh --skills-global       仅安装 Skills（全局）"
      echo "  bash install.sh --skills-project [路径] 仅安装 Skills（项目）"
      echo "  bash install.sh --mcps                仅安装 MCP（全局+项目）"
      echo "  bash install.sh --mcps-global         仅安装 MCP（全局）"
      echo "  bash install.sh --mcps-project [路径]   仅安装 MCP（项目）"
      echo "  bash install.sh --init                初始化 .mcp.env 配置"
      exit 0 ;;
    *) echo "未知参数: $1"; exit 1 ;;
  esac
done

if [ "$INSTALL_SKILLS" = true ]; then
  echo ">> 安装 Skills..."
  if [ -f "$SCRIPT_DIR/scripts/install-skills.sh" ]; then
    # shellcheck disable=SC2086
    bash "$SCRIPT_DIR/scripts/install-skills.sh" $SKILLS_ARGS
  else
    echo "   [错误] 未找到 scripts/install-skills.sh"
    exit 1
  fi
  echo ""
fi

if [ "$INSTALL_MCPS" = true ]; then
  echo ">> 安装 MCP..."
  if [ -f "$SCRIPT_DIR/scripts/install-mcps.sh" ]; then
    # shellcheck disable=SC2086
    bash "$SCRIPT_DIR/scripts/install-mcps.sh" $MCP_ARGS
  else
    echo "   [错误] 未找到 scripts/install-mcps.sh"
    exit 1
  fi
  echo ""
fi

echo "  ✅ 安装完成！重启 Trae IDE 后生效"
echo ""
echo "  安装位置:"
echo "    Skills 全局: ~/.trae-cn/skills/"
echo "    Skills 项目: .trae/skills/  .agents/skills/"
echo "    MCP 全局: ~/Library/Application Support/Trae CN/User/mcp.json"
echo "    MCP 项目: .trae/mcps/mcp.json"
