#!/bin/bash
# ============================================================
# install-skills.sh - 安装 Skills 到用户级别
# 目标: ~/.trae-cn/skills/<name>/SKILL.md
# ============================================================

set -e

SKILLS_SRC="$(cd "$(dirname "$0")/../skills" && pwd)"
SKILLS_DST="$HOME/.trae-cn/skills"

if [ ! -d "$SKILLS_SRC" ]; then
  echo "   [错误] 未找到 Skills 目录: $SKILLS_SRC"
  exit 1
fi

mkdir -p "$SKILLS_DST"

INSTALLED=0
SKIPPED=0

for skill_dir in "$SKILLS_SRC"/*/; do
  [ ! -d "$skill_dir" ] && continue
  name="$(basename "$skill_dir")"

  if [ ! -f "$skill_dir/SKILL.md" ]; then
    echo "   [跳过] $name"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi

  mkdir -p "$SKILLS_DST/$name"
  cp "$skill_dir/SKILL.md" "$SKILLS_DST/$name/SKILL.md"

  # 复制其他关联文件
  for f in "$skill_dir"/*; do
    bn="$(basename "$f")"
    [ "$bn" = "SKILL.md" ] && continue
    cp -r "$f" "$SKILLS_DST/$name/$bn" 2>/dev/null || true
  done

  echo "   [✓] $name"
  INSTALLED=$((INSTALLED + 1))
done

echo ""
echo "  安装完成: $INSTALLED 个 Skill（跳过 $SKIPPED）"
