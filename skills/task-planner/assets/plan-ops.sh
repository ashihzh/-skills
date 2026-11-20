#!/usr/bin/env bash
# plan-ops.sh —— .plan 目录唯一合法的清理/归档/审计/校验工具
# 默认 dry-run：只有显式传 --apply 才真正动文件。
# 五个子命令：scan / attic / archive / compact-audit / check
# 约束：_attic 永不自动删；archive 前先落 _evidence-manifest.tsv；保护最近 5 轮。
set -u

# 工作区根 = 本脚本所在目录的上两级（.plan/_tools/plan-ops.sh → .plan → workspace）
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PLAN_DIR="$(cd "$SCRIPT_DIR/.." && pwd)"
ROOT="$(cd "$PLAN_DIR/.." && pwd)"
cd "$ROOT" || exit 1

PLAN_REL=".plan"
AT="$PLAN_DIR/_attic"
TOOLS="$PLAN_DIR/_tools"
ARC="$PLAN_DIR/archive"

DRY=1
APPLY=0
for a in "$@"; do
  case "$a" in
    --apply) DRY=0; APPLY=1;;
    --dry-run) DRY=1; APPLY=0;;
  esac
done

ACT() { # ACT <cmd...> —— dry-run 时只打印
  if [ "$DRY" -eq 1 ]; then
    printf '  [dry-run] %s\n' "$*"
  else
    printf '  [apply ] %s\n' "$*"
    eval "$*"
  fi
}

# 从轮目录名提取前导轮号：r26-bilinote-multiuser → 26；recon-r55 → 空
round_num() { echo "$1" | sed -n 's/^r\([0-9][0-9]*\).*/\1/p'; }

# 纯 bash 的 basename（避开 MSYS 下 ls/basename 对 Windows 反斜杠路径的处理问题）
dir_base() { local p="${1%/}"; echo "${p##*/}"; }

# 保护窗：最近 5 个「不同轮号」（hardcode=5 = D5 最近5轮），永不 archive、永不压缩
PROTECT_N=5
protected() {
  local n=$(round_num "$1") nums x b d
  [ -z "$n" ] && return 1
  nums=""
  for d in "$PLAN_DIR"/r*/; do
    [ -d "$d" ] || continue
    b=$(dir_base "$d"); x=$(round_num "$b")
    [ -n "$x" ] && nums="$nums $x"
  done
  nums=$(echo $nums | tr ' ' '\n' | grep -E '^[0-9]+$' | sort -rn -u | head -"$PROTECT_N")
  for x in $nums; do [ "$n" = "$x" ] && return 0; done
  return 1
}

usage() {
  cat <<'EOF'
用法: bash .plan/_tools/plan-ops.sh <子命令> [--dry-run|--apply]
  scan                          输出 .plan 全量体积表 + 违规清单（只读）
  attic  --round rNN            把该轮 evidence/ 与根散落 _* 挪进 _attic/<轮>/
  archive --rounds r26-r56      终态轮三件套 → archive/<轮>/；先落 evidence manifest
  compact-audit                 断链压缩四条件算候选组，输出报告（只读）
  check                         违规检查，有红退出码 1（只读）
默认 dry-run；要真动文件必须显式 --apply。
EOF
}

# ---------- scan ----------
cmd_scan() {
  echo "=== .plan 体积表 ==="
  du -sh "$PLAN_DIR"
  du -sm "$PLAN_DIR"/* 2>/dev/null | sort -rn | head -60
  echo
  echo "=== 根散落 _* （除 _attic/_tools）==="
  find "$PLAN_DIR" -maxdepth 1 -name '_*' -printf '%f\n' | grep -vE '^(_attic|_tools)$' | sort
  echo
  echo "=== 违规轮目录 ==="
  check_violations
}

# ---------- check（也被 scan 复用）----------
check_violations() {
  local red=0 f
  # 1) .plan 根出现 _*（除 _attic/_tools）→ 红
  for f in $(find "$PLAN_DIR" -maxdepth 1 -name '_*' 2>/dev/null); do
    case "$(basename "$f")" in _attic|_tools) continue;; esac
    echo "  [RED] 根散落待归档: $(basename "$f")"; red=$((red+1))
  done
  # 2) 轮目录里出现临时产物 / 证据目录 → 红（最近 5 轮对 evidence/ 只警告）
  for d in "$PLAN_DIR"/r*/; do
    [ -d "$d" ] || continue
    local b=$(basename "$d")
    for f in $(find "$d" -maxdepth 1 -type f \( -name '_*' -o -name '*.mjs' -o -name '*.py' -o -name '*.sh' -o -name '*.png' -o -name '*.json' \) 2>/dev/null); do
      echo "  [RED] 轮目录临时产物: ${b}/$(basename "$f")"; red=$((red+1))
    done
    if [ -d "$d/evidence" ]; then
      if protected "$b"; then
        echo "  [WARN] 保护窗内轮有 evidence/（允许）: $b"
      else
        echo "  [RED] 非保护轮仍有 evidence/: $b"; red=$((red+1))
      fi
    fi
  done
  # 3) INDEX.md 缺「压缩授权」行 → 红
  if ! grep -q '压缩授权' "$PLAN_DIR/INDEX.md" 2>/dev/null; then
    echo "  [RED] INDEX.md 缺「压缩授权」行"; red=$((red+1))
  fi
  echo "  [check] 红灯数=$red"
  [ "$red" -gt 0 ] && return 1 || return 0
}

cmd_check() { check_violations; }

# ---------- attic ----------
cmd_attic() {
  local round="" a
  for a in "$@"; do case "$a" in --round) shift; round="${1:-}";; esac; done
  [ -z "$round" ] && { echo "attic 需要 --round rNN"; return 2; }
  local src="$PLAN_DIR/$round" dst="$AT/$round"
  echo "=== attic $round → $dst ==="
  if [ -d "$src/evidence" ]; then
    # 注意：目标父目录必须是 $dst（不含 evidence），否则会嵌成 evidence/evidence/
    ACT "mkdir -p '$dst' && mv '$src/evidence' '$dst/evidence'"
  fi
  # 根散落 _* 文件 → _attic/_root-tmp/（只在本轮 attic 时做一次，统一入口）
  local rf
  for rf in $(find "$PLAN_DIR" -maxdepth 1 -name '_*' -type f 2>/dev/null); do
    case "$(basename "$rf")" in _attic|_tools) continue;; esac
    ACT "mkdir -p '$AT/_root-tmp' && mv '$rf' '$AT/_root-tmp/'"
  done
}

# ---------- archive ----------
cmd_archive() {
  local range="" a
  for a in "$@"; do case "$a" in --rounds) shift; range="${1:-}";; esac; done
  [ -z "$range" ] && { echo "archive 需要 --rounds rNN-rMM"; return 2; }
  local lo hi lon hin
  lo=${range%-*}; hi=${range#*-}; lon=$(round_num "$lo"); hin=$(round_num "$hi")
  local manifest="$ARC/_evidence-manifest.tsv"
  echo "=== archive $range → $ARC/<轮>/（保护窗 $PROTECT_N 轮）==="
  [ "$DRY" -eq 1 ] && ACT "mkdir -p '$ARC'" || mkdir -p "$ARC"
  local d b n keep
  for d in "$PLAN_DIR"/r*/; do
    [ -d "$d" ] || continue
    b=$(basename "$d"); n=$(round_num "$b")
    [ -n "$n" ] || continue
    [ "$n" -ge "$lon" ] && [ "$n" -le "$hin" ] || continue
    if protected "$b"; then echo "  [SKIP 保护窗] $b"; continue; fi
    echo "  [ARCHIVE] $b"
    # 先 manifest 再删 evidence
    if [ -d "$d/evidence" ]; then
      local f
      for f in $(find "$d/evidence" -type f 2>/dev/null); do
        local sz md
        sz=$(stat -c %s "$f" 2>/dev/null || echo 0)
        md=$(md5sum "$f" 2>/dev/null | cut -c1-8)
        if [ "$DRY" -eq 1 ]; then
          printf '  [dry-run] manifest <<< %s\t%s\t%s\n' "$f" "$sz" "$md"
        else
          printf '%s\t%s\t%s\n' "$f" "$sz" "$md" >> "$manifest"
        fi
      done
      ACT "rm -rf '$d/evidence'"
    fi
    # 目标父目录为 $ARC（不含 $b），避免嵌成 archive/r26/r26/
    ACT "mkdir -p '$ARC' && mv '$d' '$ARC/$b'"
  done
}

# ---------- compact-audit ----------
cmd_compact_audit() {
  echo "=== 断链压缩审计（只读；保护最近 $PROTECT_N 轮）==="
  local n b d inherited="" p=""
  echo "--- 候选判定：状态终态 + 链已断 + 同主题≥3 + 不在保护窗 ---"
  printf '%-30s %-14s %-10s %-8s\n' ROUND STATUS CHAINED PROTECTED
  for d in "$PLAN_DIR"/r*/ "$ARC"/r*/; do
    [ -d "$d" ] || continue
    b=$(basename "$d"); n=$(round_num "$b"); [ -n "$n" ] || continue
    local st=$(grep -oE '\| 状态 \|[^|]*' "$d/ROUND.md" 2>/dev/null | sed 's/| 状态 |//; s/ |$//; s/^ *//; s/ *$//; s/\*//g; s/（.*//; s/(.*//; s/^ *//; s/ *$//' | head -1)
    [ -z "$st" ] && st=unknown
    inherited=$(grep -rhoE '\| 继承自 \|[^|]*' "$PLAN_DIR"/r*/ROUND.md 2>/dev/null | grep -c "r${n}-")
    if protected "$b"; then p=YES; else p=no; fi
    printf '%-30s %-14s %-10s %-8s\n' "$b" "$st" "$inherited" "$p"
  done
  echo
  echo "--- 建议（按主题词分组，≥3 轮；仅报告，不实删）---"
  echo "  · 站点线 r50/r54/r55/r56（personal-site / site-features / content-platform / polish）"
  echo "  · 玻璃/视觉线 r28–r32/r37/r38（frontend-revamp → visual-punch → glass-conflict → liquid-glass）"
  echo "  · 收口/计量线 r44–r48（storage-reclaim / root-admin / commercial / usage-metering / input）"
  echo "  注：以上为启发式建议；真压缩须由 task-compactor 按四条候选条件复核并由用户批准（manual）。"
}

case "${1:-}" in
  scan) cmd_scan;;
  check) cmd_check;;
  attic) shift; cmd_attic "$@";;
  archive) shift; cmd_archive "$@";;
  compact-audit) cmd_compact_audit;;
  *) usage; exit 2;;
esac
