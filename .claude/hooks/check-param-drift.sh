#!/usr/bin/env bash
# PostToolUse hook: warn when nextflow.config params diverge from nextflow_schema.json.
set -euo pipefail

FILE_PATH=$(echo "$CLAUDE_TOOL_INPUT" | jq -r '.file_path // empty' 2>/dev/null)
[ -z "$FILE_PATH" ] && exit 0

echo "$FILE_PATH" | grep -q 'nextflow.config' || exit 0

PIPELINE_DIR=$(dirname "$FILE_PATH")
SCHEMA="$PIPELINE_DIR/nextflow_schema.json"
CONFIG="$FILE_PATH"

[ -f "$SCHEMA" ] || exit 0
[ -f "$CONFIG" ] || exit 0

# Extract params from nextflow.config (top-level params { } block)
CONFIG_PARAMS=$(grep -oP '(?<=params\.)[\w]+' "$CONFIG" | sort -u)

# Extract params from schema definitions.properties keys
SCHEMA_PARAMS=$(jq -r '
  [.definitions // {} | to_entries[].value.properties // {} | keys[]] | sort | unique[]
' "$SCHEMA" 2>/dev/null)

# Find params in config but not in schema
MISSING_IN_SCHEMA=""
for p in $CONFIG_PARAMS; do
  if ! echo "$SCHEMA_PARAMS" | grep -qx "$p"; then
    MISSING_IN_SCHEMA="$MISSING_IN_SCHEMA  - params.$p\n"
  fi
done

if [ -n "$MISSING_IN_SCHEMA" ]; then
  echo "WARNING: These params exist in nextflow.config but not in nextflow_schema.json:"
  echo -e "$MISSING_IN_SCHEMA"
  echo "Run \`nf-core pipelines schema build\` to sync, or add them manually to the schema."
fi
