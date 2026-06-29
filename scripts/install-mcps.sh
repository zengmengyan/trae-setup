#!/bin/bash
# ============================================================
# install-mcps.sh - 安装 MCP 配置（支持全局/项目级别）
#
# 用法:
#   ./install-mcps.sh                        # 安装到全局 + 当前项目
#   ./install-mcps.sh --global               # 仅安装到全局
#   ./install-mcps.sh --project [路径]       # 仅安装到指定项目
#   ./install-mcps.sh --init                 # 初始化 .mcp.env 配置
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
MCPS_SRC="$PROJECT_ROOT/mcps"
ENV_FILE="$PROJECT_ROOT/.mcp.env"
ENV_EXAMPLE="$PROJECT_ROOT/.mcp.env.example"

# 全局 MCP 目标
GLOBAL_MCP_DIR="$HOME/Library/Application Support/Trae CN/User"
GLOBAL_MCP_FILE="$GLOBAL_MCP_DIR/mcp.json"

# ============================================================
# 工具函数
# ============================================================

print_banner() {
  echo "=========================================="
  echo "  Trae MCP 配置安装工具"
  echo "=========================================="
  echo ""
}

usage() {
  echo "用法:"
  echo "  $0                       安装到全局 + 当前项目"
  echo "  $0 --global              仅安装到全局"
  echo "  $0 --project [路径]      仅安装到指定项目"
  echo "  $0 --init                初始化 .mcp.env 配置"
  exit 0
}

# 读取 .mcp.env，生成 Python 可用的 JSON 格式的键值对
load_env() {
  if [ ! -f "$ENV_FILE" ]; then
    echo "   [错误] 未找到 $ENV_FILE"
    echo "   请先执行: $0 --init"
    exit 1
  fi

  # 用 Python 解析 .mcp.env（去掉注释和空行，提取 KEY=VALUE）
  ENV_JSON=$(python3 -c "
import json
env = {}
with open('$ENV_FILE') as f:
    for line in f:
        line = line.strip()
        if not line or line.startswith('#'):
            continue
        if '=' in line:
            key, _, value = line.partition('=')
            env[key.strip()] = value.strip()
print(json.dumps(env))
")
  echo "$ENV_JSON"
}

# 替换模板中的 {{KEY}} 占位符
substitute_tokens() {
  local template="$1"
  local env_json="$2"
  python3 -c "
import json, sys

with open('$template') as f:
    content = f.read()

env = json.loads('$env_json')
for key, value in env.items():
    content = content.replace('{{' + key + '}}', value)

# 验证是否还有未替换的占位符
if '{{' in content:
    print(json.dumps(None))
else:
    data = json.loads(content)
    print(json.dumps(data))
"
}

# 收集并合并所有 MCP 配置（输出 JSON 到 stdout，日志到 stderr）
collect_mcps() {
  local env_json="$1"

  if [ ! -d "$MCPS_SRC" ]; then
    echo "   [错误] 未找到 MCP 模板目录: $MCPS_SRC" >&2
    exit 1
  fi

  local merged='{"mcpServers": {}}'

  for mcp_dir in "$MCPS_SRC"/*/; do
    [ ! -d "$mcp_dir" ] && continue
    json_file="$mcp_dir/mcp.json"
    [ ! -f "$json_file" ] && continue

    name="$(basename "$mcp_dir")"

    # 替换 Token
    local result
    result=$(substitute_tokens "$json_file" "$env_json")

    if [ "$result" = "null" ]; then
      echo "   [警告] $name 模板中包含未替换的占位符，请检查 .mcp.env" >&2
      continue
    fi

    # 合并（写入临时文件避免 shell 变量引用问题）
    local tmp_file
    tmp_file=$(mktemp)
    echo "$merged" > "$tmp_file"
    merged=$(python3 -c "
import json
with open('$tmp_file') as f:
    base = json.load(f)
extra = json.loads('''$result'''.strip())
base['mcpServers'].update(extra.get('mcpServers', {}))
print(json.dumps(base, indent=2))
")
    rm -f "$tmp_file"

    echo "   [✓] $name" >&2
  done

  echo "$merged"
}

# 合并到已有的 mcp.json（输出 JSON 到 stdout，日志到 stderr）
merge_existing() {
  local new_content="$1"
  local target_file="$2"

  if [ -f "$target_file" ]; then
    echo "   检测到现有 mcp.json，正在合并..." >&2
    local tmp_file
    tmp_file=$(mktemp)
    echo "$new_content" > "$tmp_file"
    python3 -c "
import json
with open('$target_file') as f:
    existing = json.load(f)
with open('$tmp_file') as f:
    new_data = json.load(f)
existing.setdefault('mcpServers', {}).update(new_data.get('mcpServers', {}))
print(json.dumps(existing, indent=2))
"
    rm -f "$tmp_file"
  else
    echo "$new_content"
  fi
}

# 安装到目标位置
install_to() {
  local content="$1"
  local target_file="$2"

  mkdir -p "$(dirname "$target_file")"
  echo "$content" > "$target_file"
  echo "   [✓] 已安装到: $target_file"
}

# ============================================================
# 主逻辑
# ============================================================

# 解析参数
MODE=""
PROJECT_PATH=""
while [ $# -gt 0 ]; do
  case "$1" in
    --global) MODE="global"; shift ;;
    --project) MODE="project"; PROJECT_PATH="${2:-$(pwd)}"; shift 2 ;;
    --init) MODE="init"; shift ;;
    -h|--help) usage ;;
    *) echo "未知参数: $1"; usage ;;
  esac
done

# --init 模式：创建 .mcp.env
if [ "$MODE" = "init" ]; then
  if [ -f "$ENV_FILE" ]; then
    echo ".mcp.env 已存在"
  else
    cp "$ENV_EXAMPLE" "$ENV_FILE"
    echo "已创建 $ENV_FILE"
    echo "请编辑此文件填入你的 Token 后，再运行安装命令"
  fi
  exit 0
fi

print_banner

# 加载环境变量
echo ">> 加载 Token 配置..."
ENV_JSON=$(load_env)
echo "   [✓] 已加载 $(echo "$ENV_JSON" | python3 -c "import json,sys; print(len(json.load(sys.stdin)))") 个 Token"
echo ""

# 收集 MCP 配置
echo ">> 收集 MCP 模板..."
MCP_CONTENT=$(collect_mcps "$ENV_JSON")
echo ""

# 确定安装目标
INSTALL_GLOBAL=false
INSTALL_PROJECT=false

if [ "$MODE" = "global" ]; then
  INSTALL_GLOBAL=true
elif [ "$MODE" = "project" ]; then
  INSTALL_PROJECT=true
  # 如果未指定路径，使用当前目录
  [ -z "$PROJECT_PATH" ] && PROJECT_PATH="$(pwd)"
else
  # 默认：安装到全局 + 当前项目
  INSTALL_GLOBAL=true
  INSTALL_PROJECT=true
  PROJECT_PATH="$(pwd)"
fi

# 安装到全局
if [ "$INSTALL_GLOBAL" = true ]; then
  echo ">> 安装到全局级别..."
  FINAL=$(merge_existing "$MCP_CONTENT" "$GLOBAL_MCP_FILE")
  install_to "$FINAL" "$GLOBAL_MCP_FILE"
  echo ""
fi

# 安装到项目级别
if [ "$INSTALL_PROJECT" = true ]; then
  PROJECT_MCP_DIR="$PROJECT_PATH/.trae/mcps"
  PROJECT_MCP_FILE="$PROJECT_MCP_DIR/mcp.json"

  if [ ! -d "$PROJECT_PATH" ]; then
    echo "   [错误] 项目目录不存在: $PROJECT_PATH"
    exit 1
  fi

  echo ">> 安装到项目级别..."
  mkdir -p "$PROJECT_MCP_DIR"
  FINAL=$(merge_existing "$MCP_CONTENT" "$PROJECT_MCP_FILE")
  install_to "$FINAL" "$PROJECT_MCP_FILE"
  echo ""
fi

echo "=========================================="
echo "  安装完成!"
echo "  提示: 重启 Trae IDE 后生效"
echo "=========================================="
