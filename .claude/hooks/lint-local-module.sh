#!/usr/bin/env bash
# PostToolUse hook: lint local modules after edits.
set -euo pipefail

FILE_PATH=$(echo "$CLAUDE_TOOL_INPUT" | jq -r '.file_path // empty' 2>/dev/null)
[ -z "$FILE_PATH" ] && exit 0

echo "$FILE_PATH" | grep -q 'modules/local/' || exit 0

# Extract module name from path: .../modules/local/<module>/...
MODULE=$(echo "$FILE_PATH" | sed -n 's|.*/modules/local/\([^/]*\).*|\1|p')
[ -z "$MODULE" ] && exit 0

# Find pipeline root (walk up to find nextflow.config)
DIR=$(dirname "$FILE_PATH")
while [ "$DIR" != "/" ]; do
  [ -f "$DIR/nextflow.config" ] && break
  DIR=$(dirname "$DIR")
done
[ -f "$DIR/nextflow.config" ] || exit 0

nf-core modules lint --local "$MODULE" --dir "$DIR" 2>&1
