#!/usr/bin/env bash
# Stop hook: remind to update CHANGELOG.md if user-visible files changed.
set -euo pipefail

# Check if we're in a git repo with a CHANGELOG.md
[ -f CHANGELOG.md ] || exit 0

# Get changed files (staged + unstaged)
CHANGED=$(git diff --name-only HEAD 2>/dev/null || git diff --name-only 2>/dev/null || true)
[ -z "$CHANGED" ] && exit 0

# Check if user-visible files were modified
HAS_VISIBLE_CHANGES=$(echo "$CHANGED" | grep -cE '(workflows/|modules/local/|subworkflows/local/|nextflow\.config|nextflow_schema\.json|conf/|assets/)' || true)
[ "$HAS_VISIBLE_CHANGES" -eq 0 ] && exit 0

# Check if CHANGELOG was also updated
if ! echo "$CHANGED" | grep -q 'CHANGELOG.md'; then
  echo "WARNING: User-visible files were changed but CHANGELOG.md was not updated."
  echo "nf-core requires a CHANGELOG entry under ## [Unreleased] for every user-visible change."
fi
