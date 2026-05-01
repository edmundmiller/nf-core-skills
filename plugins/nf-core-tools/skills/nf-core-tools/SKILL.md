---
name: nf-core-tools
description: Run shared nf-core lint and policy checks via `prek run <hook-id>` or full `prek run --all-files` in this repo.
license: MIT
metadata:
  author: nf-core
  version: "0.1.0"
---

# nf-core tools

## When to use

- Need deterministic lint/policy checks across Codex, Claude, Cursor.
- Need to run one specific hook fast.
- Need strict nf-core guardrails for Nextflow edits.

## Commands

```sh
prek run --all-files
prek run guard-nfcore-modules --all-files
prek run lint-schema --all-files
prek run check-param-drift --all-files
prek run lint-local-module --all-files
prek run check-nftest-exists --all-files
prek run check-changelog --all-files
```

## Notes

- `lint-schema` and `lint-local-module` require `nf-core` CLI installed.
- Hooks fail hard on violations (non-zero exit).
