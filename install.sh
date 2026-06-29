#!/bin/bash
# ============================================================
# trae-setup - Trae IDE 一键配置工具
# 仓库: https://github.com/zengmengyan/trae-setup
# 文档: https://docs.trae.cn/ide_add-mcp-servers
# ============================================================
# 用法:
#   bash install.sh                    # 安装全局 Skills（推荐）
#   bash install.sh --mcps             # 查看 MCP 模板配置
#   bash install.sh --mcps ./project   # 安装 MCP 到指定项目
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

print_banner() {
  echo ""
  echo "  ╔══════════════════════════════════════════╗"
  echo "  ║        Trae Setup - 一键配置工具         ║"
  echo "  ║    https://github.com/zengmengyan/trae-setup  ║"
  echo "  ╚══════════════════════════════════════════╝"
  echo ""
}

install_skills() {
  if [ -f "$SCRIPT_DIR/scripts/install-skills.sh" ]; then
    bash "$SCRIPT_DIR/scripts/install-skills.sh"
  else
    echo "[错误] 未找到 scripts/install-skills.sh"
    exit 1
  fi
}

install_mcps() {
  local target_dir="${1:-$(pwd)}"
  if [ -f "$SCRIPT_DIR/scripts/install-mcps.sh" ]; then
    bash "$SCRIPT_DIR/scripts/install-mcps.sh" "$target_dir"
  else
    echo "[错误] 未找到 scripts/install-mcps.sh"
    exit 1
  fi
}

print_banner

if [ $# -eq 0 ]; then
  install_skills
  echo ""
  echo "  ✅ Skills 安装完成！重启 Trae IDE 后生效"
  echo ""
  echo "  如需安装 MCP，运行: bash install.sh --mcps"
  exit 0
fi

while [ $# -gt 0 ]; do
  case "$1" in
    --skills) install_skills ; shift 1 ;;
    --mcps)
      if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
        install_mcps "$2"; shift 2
      else
        install_mcps; shift 1
      fi ;;
    -h|--help)
      echo "用法:"
      echo "  bash install.sh                 安装 Skills（推荐）"
      echo "  bash install.sh --mcps          查看 MCP 模板"
      echo "  bash install.sh --mcps ./proj   安装 MCP 到指定项目"
      echo ""
      echo "MCP 全局安装（所有项目可用）："
      echo "  打开 Trae IDE → 设置 → MCP → 添加"
      exit 0 ;;
    *) echo "未知参数: $1" ; exit 1 ;;
  esac
done
