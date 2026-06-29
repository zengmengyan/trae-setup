#!/bin/bash
# install-mcps.sh - 安装 MCP 配置到项目 .trae/mcps/
set -e
MCPS_SRC_DIR="$(cd "$(dirname "$0")/../mcps" && pwd)"
if [ $# -ge 1 ]; then
  PROJECT_DIR="$1"
else
  PROJECT_DIR="$(pwd)"
fi
MCPS_DST_DIR="$PROJECT_DIR/.trae/mcps"
echo "=========================================="
echo "  Trae MCP 配置安装工具"
echo "=========================================="
if [ ! -d "$MCPS_SRC_DIR" ]; then
  echo "[错误] 未找到 MCP 配置目录: $MCPS_SRC_DIR"
  exit 1
fi
if [ ! -d "$PROJECT_DIR" ]; then
  echo "[错误] 项目目录不存在: $PROJECT_DIR"
  exit 1
fi
mkdir -p "$MCPS_DST_DIR"
INSTALLED=0
echo ">> 安装 MCP 配置到: $MCPS_DST_DIR"
for mcp_dir in "$MCPS_SRC_DIR"/*/; do
  mcp_name="$(basename "$mcp_dir")"
  if [ ! -d "$mcp_dir/solo_agent" ]; then
    echo "   [跳过] $mcp_name"
    continue
  fi
  cp -r "$mcp_dir"/* "$MCPS_DST_DIR/"
  echo "   [✓] 已安装 MCP: $mcp_name"
  INSTALLED=$((INSTALLED + 1))
done
echo ""
echo "  安装完成! 已安装 $INSTALLED 个 MCP 配置"
echo "  提示: 请将 .trae/mcps/ 提交到 Git 仓库"
