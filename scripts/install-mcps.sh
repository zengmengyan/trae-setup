#!/bin/bash
# install-mcps.sh - 安装 MCP 配置到项目
# 根据官方文档正确安装 MCP：
#   项目级：复制 mcp.json 到 .trae/mcp.json
#   全局级：提示通过 IDE 设置界面配置
# https://docs.trae.cn/ide_add-mcp-servers

set -e

MCPS_SRC_DIR="$(cd "$(dirname "$0")/../mcps" && pwd)"

if [ $# -ge 1 ]; then
  PROJECT_DIR="$1"
else
  PROJECT_DIR="$(pwd)"
fi

DOT_TRAE_DIR="$PROJECT_DIR/.trae"

echo "=========================================="
echo "  Trae MCP 配置安装工具"
echo "=========================================="

if [ ! -d "$PROJECT_DIR" ]; then
  echo "[错误] 项目目录不存在: $PROJECT_DIR"
  exit 1
fi

mkdir -p "$DOT_TRAE_DIR"

INSTALLED=0
echo ">> 加载 MCP 模板配置"

for mcp_dir in "$MCPS_SRC_DIR"/*/; do
  mcp_name="$(basename "$mcp_dir")"
  mcp_json="$mcp_dir/mcp.json"
  if [ ! -f "$mcp_json" ]; then
    echo "   [跳过] $mcp_name"
    continue
  fi
  echo "   [✓] 已加载 MCP 模板: $mcp_name"
  INSTALLED=$((INSTALLED + 1))
done

echo ""
echo "共加载 $INSTALLED 个 MCP 模板"
echo ""
echo "安装方式："
echo ""
echo "  [1] 项目级安装（适合团队共享）："
echo "      cp mcps/<name>/mcp.json .trae/mcp.json"
echo "      然后编辑 .trae/mcp.json 填入 API Token"
echo ""
echo "  [2] 全局安装（所有项目可用）："
echo "      Trae IDE → 设置 → MCP → 添加 → 手动添加"
echo "      粘贴 mcp.json 中的配置内容"
echo ""
echo "  [3] 从市场安装（如 GitHub MCP）："
echo "      Trae IDE → 设置 → MCP → 添加 → 从市场添加"
echo ""

# 显示所有模板内容
for mcp_dir in "$MCPS_SRC_DIR"/*/; do
  mcp_json="$mcp_dir/mcp.json"
  [ ! -f "$mcp_json" ] && continue
  echo "--- MCP: $(basename "$mcp_dir") ---"
  cat "$mcp_json"
  echo ""
done
