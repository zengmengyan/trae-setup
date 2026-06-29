#!/bin/bash
# ============================================================
# install-mcps.sh - 安装 MCP 到用户级别
# 目标: ~/Library/Application Support/Trae CN/User/mcp.json
# ============================================================

set -e

MCP_FILE="$HOME/Library/Application Support/Trae CN/User/mcp.json"
MCPS_SRC="$(cd "$(dirname "$0")/../mcps" && pwd)"

if [ ! -d "$MCPS_SRC" ]; then
  echo "   [错误] 未找到 MCP 模板目录: $MCPS_SRC"
  exit 1
fi

# 收集所有模板中的 mcpServers
MERGED_SERVERS="{}"

for mcp_dir in "$MCPS_SRC"/*/; do
  [ ! -d "$mcp_dir" ] && continue
  json_file="$mcp_dir/mcp.json"
  [ ! -f "$json_file" ] && continue

  name="$(basename "$mcp_dir")"

  # 提取 mcpServers
  EXTRACTED=$(python3 -c "
import json
with open('$json_file') as f:
    data = json.load(f)
print(json.dumps(data.get('mcpServers', {})))
")

  # 合并
  MERGED_SERVERS=$(python3 -c "
import json
base = json.loads('''$MERGED_SERVERS'''.strip())
extra = json.loads('''$EXTRACTED'''.strip())
base.update(extra)
print(json.dumps(base))
")

  echo "   [✓] $name"
done

# 检查现有 mcp.json 并合并
if [ -f "$MCP_FILE" ]; then
  echo ""
  echo "   检测到现有 mcp.json，正在合并..."
  FINAL=$(python3 -c "
import json
with open('$MCP_FILE') as f:
    existing = json.load(f)
new_servers = json.loads('''$MERGED_SERVERS'''.strip())
existing.setdefault('mcpServers', {}).update(new_servers)
print(json.dumps(existing, indent=2))
")
else
  FINAL=$(python3 -c "
import json
servers = json.loads('''$MERGED_SERVERS'''.strip())
result = {'mcpServers': servers}
print(json.dumps(result, indent=2))
")
fi

# 写入
mkdir -p "$(dirname "$MCP_FILE")"
echo "$FINAL" > "$MCP_FILE"

echo ""
echo "  已合并到: $MCP_FILE"
echo ""
echo "  注意：mcp.json 中包含 API Token，请确保："
echo "    1. 已在模板中填入你的 Token"
echo "    2. 此文件不要提交到 Git"
