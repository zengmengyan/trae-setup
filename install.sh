#!/bin/bash
# ============================================================
# trae-setup - Trae IDE 一键配置工具
# 仓库: https://github.com/zengmengyan/trae-setup
# ============================================================
# 用法:
#   bash install.sh                    # 安装 Skills（默认）
#   bash install.sh --skills           # 仅安装 Skills
#   bash install.sh --mcps             # 安装 MCP 到当前项目
#   bash install.sh --mcps ./project   # 安装 MCP 到指定项目
#   bash install.sh --mcps-global      # 安装 MCP 到全局（所有项目可用）
#   bash install.sh --all              # 安装 Skills + MCP（当前项目）
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

install_mcps_project() {
  local target_dir="${1:-$(pwd)}"
  if [ -f "$SCRIPT_DIR/scripts/install-mcps.sh" ]; then
    bash "$SCRIPT_DIR/scripts/install-mcps.sh" "$target_dir"
  else
    echo "[错误] 未找到 scripts/install-mcps.sh"
    exit 1
  fi
}

install_mcps_global() {
  echo ">> 安装 MCP 到全局 (~/.trae-cn/mcps/)"
  echo ""
  local global_dir="$HOME/.trae-cn/mcps"
  if [ ! -d "$global_dir" ]; then
    echo "[错误] 未找到全局 MCP 目录: $global_dir"
    echo "请先在 Trae IDE 中打开任意项目并配置一个 MCP，然后重试。"
    exit 1
  fi
  local count=0
  for mcp_dir in "$SCRIPT_DIR/mcps"/*/; do
    local name="$(basename "$mcp_dir")"
    [ -z "$name" ] && continue
    echo "   安装 MCP: $name"
    for ws in "$global_dir"/s_*/; do
      local ws_name="$(basename "$ws")"
      mkdir -p "$ws/solo_agent/$name"
      if [ -d "$mcp_dir/solo_agent/" ]; then
        for server_dir in "$mcp_dir/solo_agent/"*/; do
          local server="$(basename "$server_dir")"
          mkdir -p "$ws/solo_agent/$server"
          cp -r "$server_dir"* "$ws/solo_agent/$server/" 2>/dev/null || true
          echo "   [✓] $ws_name -> solo_agent/$server"
          count=$((count + 1))
        done
      fi
    done
  done
  echo ""
  echo "  完成! 共安装到 $count 个工作区"
  echo "  重启 Trae IDE 后所有项目均可使用"
}

print_banner

if [ $# -eq 0 ]; then
  install_skills
  exit 0
fi

while [ $# -gt 0 ]; do
  case "$1" in
    --skills) install_skills ; shift 1 ;;
    --mcps)
      if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
        install_mcps_project "$2"; shift 2
      else
        install_mcps_project; shift 1
      fi ;;
    --mcps-global) install_mcps_global ; shift 1 ;;
    --all)
      install_skills
      if [ -n "$2" ] && [ "${2:0:1}" != "-" ]; then
        install_mcps_project "$2"; shift 2
      else
        install_mcps_project; shift 1
      fi ;;
    -h|--help)
      echo "用法:"
      echo "  bash install.sh                      安装 Skills"
      echo "  bash install.sh --mcps               安装 MCP 到当前项目"
      echo "  bash install.sh --mcps ./project     安装 MCP 到指定项目"
      echo "  bash install.sh --mcps-global        安装 MCP 到全局"
      exit 0 ;;
    *) echo "未知参数: $1" ; exit 1 ;;
  esac
done

echo ""
echo "  ✅ 安装完成！重启 Trae IDE 后生效"
