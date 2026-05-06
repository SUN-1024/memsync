# Memory — durable shared knowledge

Stable, slow-changing facts that any agent should know after reading this
once. Add an entry when a discovery would have saved you time on the previous
task. Remove entries that go stale.

## Repository nature

- The repository is both the CLI tool *and* the convention it ships:
  the same `.ai/` files an adopting project would receive live at the root,
  populated with facts about memsync itself.
- The CLI is a single Bash script. There is no compiler or build step;
  changing behavior means editing `bin/memsync` directly.

## Adapter conventions

- `CLAUDE.md` MUST stay thin: only `@./path` imports plus, optionally, a few
  lines of agent-specific instruction. No prose duplicated from `.ai/`.
- `AGENTS.md` MUST list the seven `.ai/` files in the read order defined in
  `.ai/README.md`, and MUST restate the post-task update rule. Agents that
  read `AGENTS.md` typically do not resolve `@`-imports, so the list is
  explicit.
- `CLAUDE.md` and `AGENTS.md` exist in **two places**: at the repo root
  (memsync's own adapters) and under `templates/` (what `memsync init` writes
  for users). Both sets must always be in sync with each other and with
  `bin/memsync`'s `SCAFFOLD_FILES` array.

## CLI conventions

- `bin/memsync init` is **safe by default** — it skips existing files. Only
  `--force` overwrites. Never change this default without a release note.
- `bin/memsync` resolves its template directory relative to its own location
  (following symlinks). The Homebrew formula rewrites the resolved path at
  install time; do not rely on environment variables for template lookup.
- Version is hard-coded at the top of `bin/memsync` as `VERSION="X.Y.Z"`.
  Bumping the version means editing both `bin/memsync` and
  `homebrew/memsync.rb` in the same commit.

## Update protocol

- Update `.ai/handoff.md` **before** reporting any task as done, even small
  ones. The user relies on it as the live status file.
- Only put truly durable knowledge in this file. Task-specific notes belong
  in `handoff.md`; they get overwritten each task.

## Distribution

- The Homebrew tap repository is `SUN-1024/homebrew-memsync`.
- The formula at `homebrew/memsync.rb` in this repo is a reference copy; the
  canonical version lives in the tap.
- Releases are triggered by pushing a `v*.*.*` tag. The action attaches the
  source tarball and prints its SHA256 so the formula can be updated.

## Branding

- memsync is **tool-neutral**. No single AI coding agent (Claude Code,
  Codex, Cursor, etc.) is named as a contributor, author, maintainer, or
  project identity. Listed agents are compatibility targets only.
- When adding new agent names, list them as compatibility references, not
  as authors.

## Language

- All `.ai/` content is written in English so any agent can parse it.
- Human-facing READMEs are bilingual: `README.md` (English) and
  `README.zh.md` (Simplified Chinese). Keep them in sync per change.

## Cross-platform

- Do not introduce symlinks inside the repo. `AGENTS.md` is a real file, not
  a link to `CLAUDE.md`. Reasons: Windows clones, shallow clones, and some
  CI runners handle symlinks inconsistently.
- Bash version target is **3.2** (macOS default). Avoid Bash 4+ syntax such
  as associative arrays.

## Common pitfalls

- Do not add a hook configuration (`.claude/settings.json`, Cursor rules,
  etc.) here. Hooks belong to the consuming project and depend on its
  language and tooling.
- Do not rename `.ai/` to something else — both adapters point at it by
  name. A rename is a breaking change for every downstream consumer.
- Do not add Chinese text inside `.ai/`. It bloats the agent context for
  English-speaking agents and the bilingual coverage already lives in the
  human-facing READMEs.
