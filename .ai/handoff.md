# Handoff — rolling state

Update this file **before** reporting any task as done. Overwrite previous
sections with the latest state; this file is not a changelog.

## Latest task

Add agent-specific instructions to all three root adapters to prevent project
knowledge from being stored in agent-private memory systems (e.g. Claude Code's
`~/.claude/projects/.../memory/`). The adapters now route durable project
knowledge to `.ai/memory.md` (or the most relevant `.ai/` file) so it remains
readable by every agent working on the repository.

## Files changed

- `CLAUDE.md` — added agent-specific instruction block after imports.
- `opencode.md` — added identical agent-specific instruction block.
- `AGENTS.md` — added no-private-memory rule to the update rule section.
- `templates/CLAUDE.md` — synced with root `CLAUDE.md`.
- `templates/opencode.md` — synced with root `opencode.md`.
- `templates/AGENTS.md` — synced with root `AGENTS.md`.
- `.ai/README.md` — added no-private-memory rule to write rules.
- `templates/.ai/README.md` — synced with root `.ai/README.md`.
- `.ai/memory.md` — recorded agent-private memory as a common pitfall.
- `.ai/handoff.md` — this file.

## Commands run

- `bash -n bin/repomemo` → PASS.
- `bash -n tests/test_repomemo.sh` → PASS.
- `bash bin/repomemo --version` → PASS, `repomemo 1.1.0`.
- `bash bin/repomemo --help` → PASS.
- `bash tests/test_repomemo.sh` → PASS, 11 passed and 0 failed.
- `bash bin/repomemo check .` → PASS, 10 files.
- `bash bin/repomemo check --strict .` → PASS, 10 files + all strict checks.

## Checks performed

- `extract_at_imports` still correctly parses `@./path` imports despite new
  text after the import block.
- `check_files_match` confirms CLAUDE.md and opencode.md remain byte-identical,
  and that all root adapters match their template copies.
- Integration tests confirm `init` + `check --strict` still work end-to-end
  with the new adapter content.

## Current state

All three root adapters now contain explicit instructions to write project
knowledge to `.ai/` files instead of agent-private memory systems. The
`check --strict` invariant is maintained: CLAUDE.md and opencode.md are still
byte-identical, and all adapters match their templates.

## Unresolved unknowns

The instruction is advisory — it will be in every agent's context, but whether
each agent fully suppresses its built-in private memory behavior depends on
that agent's implementation. The instruction sets clear intent; actual
compliance is per-agent.

## Next safe action

Decide whether to bump the version for this change (it modifies the scaffold
that `repomemo init` writes). If so, update `VERSION`, `homebrew/repomemo.rb`,
`package.json`, and `tests/test_repomemo.sh` together, then tag a release.
