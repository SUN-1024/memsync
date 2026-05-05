# Memory — durable shared knowledge

Stable, slow-changing facts that any agent should know after reading this
once. Add an entry when a discovery would have saved you time on the previous
task. Remove entries that go stale.

## Repository nature

- This repo ships **no executable code**. Every file is markdown, plain text,
  or a license. Do not propose adding build tooling unless the user explicitly
  asks for it.
- The repository **is** the convention it documents — the same files an
  adopting project would copy. Examples in `architecture.md` therefore describe
  this repo's own layout.

## Adapter conventions

- `CLAUDE.md` MUST stay thin: only `@./path` imports plus, optionally, a few
  lines of Claude-Code-specific instruction. No prose duplicated from `.ai/`.
- `AGENTS.md` MUST list the seven `.ai/` files in the read order defined in
  `.ai/README.md`, and MUST restate the post-task update rule. Codex does not
  resolve `@`-imports, so the list must be explicit.
- The two adapters' file lists must always be in sync. When you change one,
  change the other in the same commit.

## Update protocol

- Update `.ai/handoff.md` **before** reporting any task as done — even
  small ones. The user relies on it as the live status file.
- Only put truly durable knowledge in this file. Task-specific notes belong
  in `handoff.md`; they get overwritten each task.

## Language

- All `.ai/` content is written in English so any agent can parse it.
- Human-facing READMEs are bilingual: `README.md` (English) and
  `README.zh.md` (Simplified Chinese). Keep them in sync per change.

## Cross-platform

- Do not introduce symlinks. `AGENTS.md` is a real file, not a link to
  `CLAUDE.md`. Reasons: Windows clones, shallow clones, and some CI runners
  handle symlinks inconsistently.

## Common pitfalls

- Do not add a hook configuration (`.claude/settings.json` etc.) here. Hooks
  belong to the consuming project and depend on its language and tooling.
- Do not rename `.ai/` to something else — both adapters point at it by
  name. A rename is a breaking change for every downstream consumer.
- Do not add Chinese text inside `.ai/`. It bloats the agent context for
  English-speaking agents and the bilingual coverage already lives in the
  human-facing READMEs.
