#!/usr/bin/env bash
# PostToolUse hook: warn when a new .nf file has no corresponding .nf.test.
set -euo pipefail

FILE_PATH=$(echo "$CLAUDE_TOOL_INPUT" | jq -r '.file_path // empty' 2>/dev/null)
[ -z "$FILE_PATH" ] && exit 0

# Only check .nf files in testable locations
echo "$FILE_PATH" | grep -qE '\.(nf)$' || exit 0
echo "$FILE_PATH" | grep -qE '(modules/local|subworkflows/local|workflows)/' || exit 0

# Check for sibling .nf.test
NF_TEST="${FILE_PATH%.nf}.nf.test"
DIR=$(dirname "$FILE_PATH")
BASENAME=$(basename "$FILE_PATH" .nf)

# Also check tests/ subdirectory pattern
if [ ! -f "$NF_TEST" ] && [ ! -f "$DIR/tests/${BASENAME}.nf.test" ] && [ ! -f "$DIR/tests/main.nf.test" ]; then
  echo "WARNING: No nf-test found for $FILE_PATH"
  echo "Expected one of:"
  echo "  - $NF_TEST"
  echo "  - $DIR/tests/${BASENAME}.nf.test"
  echo "  - $DIR/tests/main.nf.test"
  echo "nf-core requires nf-test coverage for all workflows, subworkflows, and local modules."
fi
