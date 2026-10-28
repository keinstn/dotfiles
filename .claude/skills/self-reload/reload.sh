#!/usr/bin/env bash
set -euo pipefail
dir="${CLAUDE_SELF_RELOAD_DIR:-$HOME/.cache/claude-self-reload}"
: "${CLAUDE_PID:?CLAUDE_PID not set; aborting}"
: "${CLAUDE_CODE_SESSION_ID:?CLAUDE_CODE_SESSION_ID not set; aborting}"
shell_pid=$(ps -o ppid= -p "$CLAUDE_PID" | tr -d ' ')
[ -n "$shell_pid" ] || { echo "cannot find parent of $CLAUDE_PID; aborting" >&2; exit 1; }
if ! ps -o comm= -p "$shell_pid" | grep -q fish; then
  echo "parent of claude is not fish; not killing. Resume manually: claude --resume $CLAUDE_CODE_SESSION_ID" >&2
  exit 1
fi
mkdir -p "$dir"
printf '%s\n' "$CLAUDE_CODE_SESSION_ID" > "$dir/$shell_pid"
echo "Reloading session $CLAUDE_CODE_SESSION_ID (manual: claude --resume $CLAUDE_CODE_SESSION_ID)"
kill "$CLAUDE_PID" || { rm -f "$dir/$shell_pid"; exit 1; }
