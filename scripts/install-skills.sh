#!/bin/bash
# install-skills.sh - 安装全局 Skills 到 ~/.trae-cn/skills/
set -e
SKILLS_SRC_DIR="$(cd "$(dirname "$0")/../skills" && pwd)"
SKILLS_DST_DIR="$HOME/.trae-cn/skills"
echo "=========================================="
echo "  Trae Skills 安装工具"
echo "=========================================="
if [ ! -d "$SKILLS_SRC_DIR" ]; then
  echo "[错误] 未找到 Skills 目录: $SKILLS_SRC_DIR"
  exit 1
fi
mkdir -p "$SKILLS_DST_DIR"
INSTALLED=0
SKIPPED=0
echo ">> 正在安装 Skills 到: $SKILLS_DST_DIR"
for skill_dir in "$SKILLS_SRC_DIR"/*/; do
  skill_name="$(basename "$skill_dir")"
  if [ ! -f "$skill_dir/SKILL.md" ]; then
    echo "   [跳过] $skill_name"
    SKIPPED=$((SKIPPED + 1))
    continue
  fi
  mkdir -p "$SKILLS_DST_DIR/$skill_name"
  cp "$skill_dir/SKILL.md" "$SKILLS_DST_DIR/$skill_name/SKILL.md"
  for extra_file in "$skill_dir"/*; do
    extra_name="$(basename "$extra_file")"
    if [ "$extra_name" != "SKILL.md" ]; then
      cp -r "$extra_file" "$SKILLS_DST_DIR/$skill_name/$extra_name" 2>/dev/null || true
    fi
  done
  echo "   [✓] 已安装: $skill_name"
  INSTALLED=$((INSTALLED + 1))
done
echo ""
echo "  安装完成! 已安装: $INSTALLED  已跳过: $SKIPPED"
echo "  提示: 重启 Trae IDE 后生效"
