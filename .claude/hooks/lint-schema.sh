#!/usr/bin/env bash
# PostToolUse hook: lint nextflow_schema.json after edits.
set -euo pipefail

FILE_PATH=$(echo "$CLAUDE_TOOL_INPUT" | jq -r '.file_path // empty' 2>/dev/null)
[ -z "$FILE_PATH" ] && exit 0

echo "$FILE_PATH" | grep -q 'nextflow_schema.json' || exit 0

# Find pipeline root (directory containing the schema)
SCHEMA_DIR=$(dirname "$FILE_PATH")
nf-core pipelines schema lint --dir "$SCHEMA_DIR" 2>&1
