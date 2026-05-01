#!/usr/bin/env bash
# PreToolUse hook: block direct edits to modules/nf-core/ files.
# These are upstream-managed — use `nf-core modules patch <tool>` instead.
set -euo pipefail

FILE_PATH=$(echo "$CLAUDE_TOOL_INPUT" | jq -r '.file_path // .content // empty' 2>/dev/null)
[ -z "$FILE_PATH" ] && exit 0

if echo "$FILE_PATH" | grep -q 'modules/nf-core/'; then
  echo "BLOCK: Do not edit modules/nf-core/ directly — these are upstream-managed."
  echo "Use \`nf-core modules patch <tool>\` to create a patch file instead."
  exit 2
fi
