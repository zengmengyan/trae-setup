#!/bin/bash
# ============================================================
# install-skills.sh - 安装 Skills（支持全局/项目级别）
#
# 用法:
#   ./install-skills.sh                  # 安装到全局 + 当前项目
#   ./install-skills.sh --global         # 仅安装到全局
#   ./install-skills.sh --project [路径] # 仅安装到指定项目
# ============================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
SKILLS_SRC="$PROJECT_ROOT/skills"

# 全局 Skills 目标
GLOBAL_SKILLS_DIR="$HOME/.trae-cn/skills"

# ============================================================
# 工具函数
# ============================================================

print_banner() {
  echo "=========================================="
  echo "  Trae Skills 安装工具"
  echo "=========================================="
  echo ""
}

usage() {
  echo "用法:"
  echo "  $0                       安装到全局 + 当前项目"
  echo "  $0 --global              仅安装到全局"
  echo "  $0 --project [路径]      仅安装到指定项目"
  exit 0
}

# 安装 Skills 到指定目录
install_to_dir() {
  local dst_dir="$1"
  local label="$2"

  if [ ! -d "$SKILLS_SRC" ]; then
    echo "   [错误] 未找到 Skills 目录: $SKILLS_SRC" >&2
    exit 1
  fi

  mkdir -p "$dst_dir"

  local installed=0
  local skipped=0

  for skill_dir in "$SKILLS_SRC"/*/; do
    [ ! -d "$skill_dir" ] && continue
    name="$(basename "$skill_dir")"

    if [ ! -f "$skill_dir/SKILL.md" ]; then
      echo "   [跳过] $name" >&2
      skipped=$((skipped + 1))
      continue
    fi

    mkdir -p "$dst_dir/$name"
    cp "$skill_dir/SKILL.md" "$dst_dir/$name/SKILL.md"

    # 复制其他关联文件
    for f in "$skill_dir"/*; do
      bn="$(basename "$f")"
      [ "$bn" = "SKILL.md" ] && continue
      cp -r "$f" "$dst_dir/$name/$bn" 2>/dev/null || true
    done

    echo "   [✓] $name" >&2
    installed=$((installed + 1))
  done

  echo "   $label: $installed 个 Skill（跳过 $skipped）" >&2
  echo "$installed"
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
    -h|--help) usage ;;
    *) echo "未知参数: $1"; usage ;;
  esac
done

print_banner

# 确定安装目标
INSTALL_GLOBAL=false
INSTALL_PROJECT=false

if [ "$MODE" = "global" ]; then
  INSTALL_GLOBAL=true
elif [ "$MODE" = "project" ]; then
  INSTALL_PROJECT=true
  [ -z "$PROJECT_PATH" ] && PROJECT_PATH="$(pwd)"
else
  INSTALL_GLOBAL=true
  INSTALL_PROJECT=true
  PROJECT_PATH="$(pwd)"
fi

TOTAL=0

if [ "$INSTALL_GLOBAL" = true ]; then
  echo ">> 安装到全局级别..."
  GLOBAL_DST="$GLOBAL_SKILLS_DIR"
  result=$(install_to_dir "$GLOBAL_DST" "全局")
  [ -n "$result" ] && TOTAL=$((TOTAL + result))
  echo ""
fi

if [ "$INSTALL_PROJECT" = true ]; then
  if [ ! -d "$PROJECT_PATH" ]; then
    echo "   [错误] 项目目录不存在: $PROJECT_PATH" >&2
    exit 1
  fi

  echo ">> 安装到项目级别..."
  result=$(install_to_dir "$PROJECT_PATH/.trae/skills" ".trae/skills")
  [ -n "$result" ] && TOTAL=$((TOTAL + result))
  result=$(install_to_dir "$PROJECT_PATH/.agents/skills" ".agents/skills")
  [ -n "$result" ] && TOTAL=$((TOTAL + result))
  echo ""
fi

echo "=========================================="
echo "  Skills 安装完成！"
echo "=========================================="
