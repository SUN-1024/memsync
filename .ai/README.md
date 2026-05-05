# `.ai/` — Shared Project Memory

This directory is the **single source of truth** that both Claude Code and Codex
(and any other agent that respects `AGENTS.md` / `CLAUDE.md`) read at the start
of a session. The goal is simple: stop the two tools from drifting into separate
mental models of the same repository.

## Read order

Agents should load these files in this exact order, every session:

1. `README.md` (this file) — explains the convention itself.
2. `project.md` — purpose, stakeholders, scope, non-goals.
3. `architecture.md` — stack, repo layout, components, decisions.
4. `definition-of-done.md` — what counts as "done" in this repo.
5. `review-checklist.md` — the punch list reviewers run through.
6. `memory.md` — durable, slow-changing project knowledge.
7. `handoff.md` — rolling state of the most recent task.

The two root adapters (`CLAUDE.md` and `AGENTS.md`) both point into this
directory; do not duplicate content into them.

## Write rules

- **After every implementation, debug, refactor, review, docs, setup,
  dependency, config, or test task**, update `handoff.md` *before* reporting the
  task as done. `handoff.md` is the live state file.
- When you discover something **stable** about the project (a convention, a
  constraint, a recurring pitfall), append it to `memory.md` or to the most
  relevant `.ai/` file. Keep entries concise.
- When the project's purpose, stack, or architecture changes, update
  `project.md` and/or `architecture.md` directly.
- Never write `TODO`, `TBD`, or placeholder text into `.ai/`. If a fact is not
  defined in the repository, write one clear sentence saying so.

## Why this exists

Claude Code natively imports files via `@./path` syntax in `CLAUDE.md`. Codex
and several other agents look for `AGENTS.md` and read it as plain instructions.
By putting the actual content in `.ai/` and keeping the root files thin, both
tools end up reading the same authoritative documents in the same order.
