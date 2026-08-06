#!/usr/bin/env bash
#
# Wizard — 逐步引导人类完成手动流程。
# 由 /wizard skill 生成。
#
# "STAGES" 标记以上是 wizard 库：不要手改。
# 在标记以下编写每个步骤的 stages。

set -euo pipefail

# ──────────────────────────────────────────────────────────────────────────
# Wizard 库 — 愉悦、一致的 UX。每个 wizard 完全相同。
# ──────────────────────────────────────────────────────────────────────────

if [[ -t 1 ]] && command -v tput >/dev/null 2>&1 && [[ "$(tput colors 2>/dev/null || echo 0)" -ge 8 ]]; then
  BOLD=$(tput bold); DIM=$(tput dim); RESET=$(tput sgr0)
  BLUE=$(tput setaf 4); GREEN=$(tput setaf 2); YELLOW=$(tput setaf 3); RED=$(tput setaf 1)
else
  BOLD=""; DIM=""; RESET=""; BLUE=""; GREEN=""; YELLOW=""; RED=""
fi

# 作者在 stages 区顶部设置这两个值。
TOTAL_STAGES=0
TOTAL_MINUTES=0

_STAGE_INDEX=0
_MINUTES_ELAPSED=0
ENV_FILE="${ENV_FILE:-.env}"
WRITTEN_ENV=()    # 本轮写入 ENV_FILE 的 KEY
WRITTEN_SECRET=() # 本轮设置的 secret NAME
SKIPPED=()        # 未能完成的事（例如缺少 gh）

# _clear — 清屏，只保留当前步骤。输出不是终端时 no-op，方便管道日志可读。
_clear() {
  [[ -t 1 ]] || return 0
  if command -v tput >/dev/null 2>&1; then tput clear; else printf '\033[2J\033[3J\033[H'; fi
}

# banner "Title" — 开场：这个 wizard 做什么、大约多久。
banner() {
  _clear
  printf '\n%s%s  %s%s\n' "$BOLD" "$BLUE" "$1" "$RESET"
  printf '%s  %s 个阶段 · 约 %s 分钟%s\n\n' \
    "$DIM" "$TOTAL_STAGES" "$TOTAL_MINUTES" "$RESET"
  printf '%s  你操作浏览器；本 wizard 会精确告诉你做什么，并\n' "$DIM"
  printf '  捕获你复制回来的值。随时 Ctrl-C 停止，稍后重跑\n'
  printf '  ——已保存的值会记住。%s\n' "$RESET"
  pause "准备好开始了吗？"
}

# stage "Name" <minutes> — 清屏，宣布阶段，并显示进度与剩余时间。清屏只留当前步骤。
stage() {
  _clear
  _STAGE_INDEX=$((_STAGE_INDEX + 1))
  local remaining=$((TOTAL_MINUTES - _MINUTES_ELAPSED))
  (( remaining < 0 )) && remaining=0
  _MINUTES_ELAPSED=$((_MINUTES_ELAPSED + ${2:-0}))
  printf '\n%s%s▸ 阶段 %s/%s · %s%s  %s（约剩 %s 分钟）%s\n' \
    "$BOLD" "$BLUE" "$_STAGE_INDEX" "$TOTAL_STAGES" "$1" "$RESET" "$DIM" "$remaining" "$RESET"
}

# say "..." — 普通说明行。
say()  { printf '  %s\n' "$1"; }
# step "..." — 人类在浏览器中采取的、带编号感的动作。
step() { printf '  %s•%s %s\n' "$BLUE" "$RESET" "$1"; }
note() { printf '  %s%s%s\n' "$DIM" "$1" "$RESET"; }
warn() { printf '  %s⚠ %s%s\n' "$YELLOW" "$1" "$RESET"; }

# open_url URL — 在人类浏览器中打开，跨平台含 WSL。
open_url() {
  local url="$1"
  printf '  %s↗ 正在打开%s %s\n' "$GREEN" "$RESET" "$url"
  { if   command -v wslview     >/dev/null 2>&1; then wslview "$url"
    elif command -v explorer.exe >/dev/null 2>&1; then explorer.exe "$url"
    elif command -v xdg-open    >/dev/null 2>&1; then xdg-open "$url"
    elif command -v open        >/dev/null 2>&1; then open "$url"
    else warn "无法打开浏览器 — 请手动访问：$url"; fi
  } >/dev/null 2>&1 || warn "无法打开浏览器 — 请手动访问：$url"
}

# pause "msg" — 等待人类确认手动部分已完成。
pause() {
  printf '  %s%s%s ' "$DIM" "${1:-按 Enter 继续}" "$RESET"
  read -r _ || true
}

# confirm "question" — y/N 门禁；yes 时返回成功。
confirm() {
  local reply=""
  printf '  %s? %s [y/N] ' "$YELLOW" "$1"
  read -r reply || true
  [[ "$reply" =~ ^[Yy] ]]
}

# _existing KEY — ENV_FILE 中 KEY 的当前值（若有）。
_existing() {
  [[ -f "$ENV_FILE" ]] || return 1
  local line; line=$(grep -E "^${1}=" "$ENV_FILE" | tail -n1) || return 1
  printf '%s' "${line#*=}"
}

# ask KEY "Prompt" — 把值读入 $KEY。重跑时提供已有 .env 值作默认（Enter 保留）。可见输入（非 secret）。
ask() {
  local key="$1" prompt="$2" current input
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s[Enter 保留当前值]%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -r input || true
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

# ask_secret KEY "Prompt" — 与 ask 相同，但输入隐藏。
ask_secret() {
  local key="$1" prompt="$2" current input
  current=$(_existing "$key" || true)
  if [[ -n "$current" ]]; then
    printf '  %s%s%s %s[Enter 保留当前值]%s ' "$BOLD" "$prompt" "$RESET" "$DIM" "$RESET"
  else
    printf '  %s%s%s ' "$BOLD" "$prompt" "$RESET"
  fi
  read -rs input || true
  printf '\n'
  [[ -z "$input" && -n "$current" ]] && input="$current"
  printf -v "$key" '%s' "$input"
}

# write_env KEY VALUE — 向 ENV_FILE upsert KEY=VALUE（可创建；替换已有行）。幂等。
write_env() {
  local key="$1" value="$2" tmp
  touch "$ENV_FILE"
  tmp=$(mktemp)
  grep -vE "^${key}=" "$ENV_FILE" > "$tmp" || true
  printf '%s=%s\n' "$key" "$value" >> "$tmp"
  mv "$tmp" "$ENV_FILE"
  WRITTEN_ENV+=("$key")
  printf '  %s✓ 已写入%s %s → %s\n' "$GREEN" "$RESET" "$key" "$ENV_FILE"
}

# set_secret NAME VALUE — 通过 gh 设置 GitHub Actions repo secret。gh 不可用或未认证时回退警告并记录。
set_secret() {
  local name="$1" value="$2"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if printf '%s' "$value" | gh secret set "$name" >/dev/null 2>&1; then
      WRITTEN_SECRET+=("$name")
      printf '  %s✓ 已设置%s GitHub secret %s\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("GitHub secret $name（请手动设置：gh secret set $name）")
  warn "已跳过 GitHub secret $name — gh 未就绪；请稍后设置"
}

# set_var NAME VALUE — 设置 GitHub Actions repo variable（非 secret）。
set_var() {
  local name="$1" value="$2"
  if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
    if gh variable set "$name" --body "$value" >/dev/null 2>&1; then
      printf '  %s✓ 已设置%s GitHub variable %s\n' "$GREEN" "$RESET" "$name"
      return
    fi
  fi
  SKIPPED+=("GitHub variable $name")
  warn "已跳过 GitHub variable $name — gh 未就绪；请稍后设置"
}

# finish — 清屏，然后给出已配置内容的收尾摘要。
finish() {
  _clear
  printf '\n%s%s  ✓ 设置完成%s\n' "$BOLD" "$GREEN" "$RESET"
  (( ${#WRITTEN_ENV[@]} ))    && note "已向 $ENV_FILE 写入 ${#WRITTEN_ENV[@]} 个值：${WRITTEN_ENV[*]}"
  (( ${#WRITTEN_SECRET[@]} )) && note "已设置 ${#WRITTEN_SECRET[@]} 个 GitHub secret：${WRITTEN_SECRET[*]}"
  if (( ${#SKIPPED[@]} )); then
    printf '\n'; warn "仍需手动完成："
    for s in "${SKIPPED[@]}"; do note "  - $s"; done
  fi
  printf '\n'
}

# ──────────────────────────────────────────────────────────────────────────
# STAGES — 编写本节。人类每走一步对应一个 stage()。
# 替换下面的示例。把两个 totals 设成与你写的 stages 一致。
# ──────────────────────────────────────────────────────────────────────────

TOTAL_STAGES=1
TOTAL_MINUTES=5

banner "Stripe 设置"

# ── 示例 stage：替换成你的真实步骤 ───────────────────────────
stage "Stripe — API keys" 5
say "我们会获取 Stripe test keys，并存到本地开发与 CI。"
open_url "https://dashboard.stripe.com/test/apikeys"
step "在 API keys 页面复制 Publishable key（以 pk_test_ 开头）。"
ask STRIPE_PUBLISHABLE_KEY "粘贴 publishable key："
step "在 Secret key 行点击 'Reveal test key'，然后复制。"
ask_secret STRIPE_SECRET_KEY "粘贴 secret key："
write_env STRIPE_PUBLISHABLE_KEY "$STRIPE_PUBLISHABLE_KEY"
write_env STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"
set_secret STRIPE_SECRET_KEY "$STRIPE_SECRET_KEY"   # CI 需要这一项
# ──────────────────────────────────────────────────────────────────────────

finish
