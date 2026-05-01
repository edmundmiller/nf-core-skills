# nf-core-skills

Agent Skills for [nf-core](https://nf-co.re) — Nextflow pipelines, modules, subworkflows, and the nf-core toolchain.

These skills follow the [Agent Skills specification](https://agentskills.io/specification) so they can be used by any skills-compatible agent, including Claude Code, Codex CLI, OpenCode, and Cursor.

> Will eventually live at `nf-core/skills`.

## Installation

### Claude Code

```
/plugin marketplace add nf-core/skills
/plugin install nf-core@nf-core-skills
```

### Codex CLI

Copy the `skills/` directory into your Codex skills path (typically `~/.codex/skills`).

### OpenCode

Clone the repository into the OpenCode skills directory:

```sh
git clone https://github.com/nf-core/skills.git ~/.opencode/skills/nf-core-skills
```

OpenCode auto-discovers `SKILL.md` files under `~/.opencode/skills/`.

### Cursor

Place the repository contents under `.cursor/skills/` in your project (or globally where Cursor reads skills from).

### Manual

Drop the `skills/` directory contents into any agent harness that follows the [Agent Skills specification](https://agentskills.io/specification).

## Skills

| Skill | Description |
|-------|-------------|
| [nf-core-pipeline](skills/nf-core-pipeline) | Create and modify [nf-core pipelines](https://nf-co.re/docs/contributing/pipelines) following community standards |
| [nf-core-lint](skills/nf-core-lint) | Run and interpret `nf-core pipelines lint` to validate pipeline compliance |

## Development

This repo uses [`prek`](https://github.com/j178/prek) to validate skills before commit. Install hooks once:

```sh
prek install
```

See [`prek.toml`](prek.toml) for the configured checks, [`AGENTS.md`](AGENTS.md) for the agent-facing map, and [`docs/ARCHITECTURE.md`](docs/ARCHITECTURE.md) for the layout.

The design follows [OpenAI's harness engineering principles](https://openai.com/index/harness-engineering/): a small `AGENTS.md` table of contents, mechanical enforcement of repo structure, and progressive disclosure of detail.

## License

MIT — see [LICENSE](LICENSE).
