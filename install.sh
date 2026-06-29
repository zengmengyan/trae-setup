#!/bin/bash
# ============================================================
# trae-setup - Trae IDE 一键配置工具
# 仓库: https://github.com/zengmengyan/trae-setup
# ============================================================
# 用法:
#   bash install.sh                # 安装 Skills + MCP
#   bash install.sh --skills       # 仅安装 Skills
#   bash install.sh --mcps         # 仅安装 MCP
#   bash install.sh --mcps ./my-project  # 安装 MCP 到指定项目
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "  ╔══════════════════════════════════════════╗"
echo "  ║        Trae Setup - 一键配置工具         ║"
echo "  ║    https://github.com/zengmengyan/trae-setup  ║"
echo "  ╚══════════════════════════════════════════╝"
echo ""

# ---- 参数解析 ----
INSTALL_SKILLS=true
INSTALL_MCPS=false
MCPS_PROJECT_DIR=""

while [ $# -gt 0 ]; do
  case "$1" in
    --skills)
      INSTALL_SKILLS=true
      INSTALL_MCPS=false
      shift 1
      ;;
    --mcps)
      INSTALL_SKILLS=false
      INSTALL_MCPS=true
      if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
        MCPS_PROJECT_DIR="$2"
        shift 2
      else
        shift 1
      fi
      ;;
    --all)
      INSTALL_SKILLS=true
      INSTALL_MCPS=true
      if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
        MCPS_PROJECT_DIR="$2"
        shift 2
      fi
      shift 1
      ;;
    -h|--help)
      echo "用法:"
      echo "  bash install.sh                        安装 Skills + 当前项目 MCP"
      echo "  bash install.sh --skills               仅安装 Skills"
      echo "  bash install.sh --mcps                 仅安装 MCP 到当前目录"
      echo "  bash install.sh --mcps ./project       安装 MCP 到指定项目"
      echo "  bash install.sh --all ./project        安装 Skills + MCP 到指定项目"
      exit 0
      ;;
    *)
      echo "[错误] 未知参数: $1"
      echo "执行 bash install.sh --help 查看帮助"
      exit 1
      ;;
  esac
done

# ---- 安装 Skills ----
if [ "$INSTALL_SKILLS" = true ]; then
  if [ -f "$SCRIPT_DIR/scripts/install-skills.sh" ]; then
    bash "$SCRIPT_DIR/scripts/install-skills.sh"
  else
    echo "[警告] 未找到 scripts/install-skills.sh"
  fi
fi

# ---- 安装 MCP ----
if [ "$INSTALL_MCPS" = true ]; then
  if [ -f "$SCRIPT_DIR/scripts/install-mcps.sh" ]; then
    if [ -n "$MCPS_PROJECT_DIR" ]; then
      bash "$SCRIPT_DIR/scripts/install-mcps.sh" "$MCPS_PROJECT_DIR"
    else
      bash "$SCRIPT_DIR/scripts/install-mcps.sh"
    fi
  else
    echo "[警告] 未找到 scripts/install-mcps.sh"
  fi
fi

echo ""
echo "  ✅ 配置安装完成！"
echo ""
echo "  后续步骤:"
echo "    1. 重启 Trae IDE"
echo "    2. 如需安装到其他项目，执行:"
echo "       bash install.sh --mcps <项目目录>"
