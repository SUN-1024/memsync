# Memory — durable shared knowledge

Stable, slow-changing facts that any agent should know after reading this
once. Add an entry when a discovery would have saved you time on the previous
task. Remove entries that go stale.

## Repository nature

- The repository is both the CLI tool *and* the convention it ships:
  the same `.ai/` files an adopting project would receive live at the root,
  populated with facts about repomemo itself.
- The CLI is a single Bash script. There is no compiler or build step;
  changing behavior means editing `bin/repomemo` directly.

## Adapter conventions

- `CLAUDE.md` and `opencode.md` MUST stay thin: only `@./path` imports plus,
  optionally, a few lines of agent-specific instruction. No prose duplicated
  from `.ai/`.
- `AGENTS.md` MUST list the seven `.ai/` files in the read order defined in
  `.ai/README.md`, and MUST restate the post-task update rule. Agents that
  read `AGENTS.md` typically do not resolve `@`-imports, so the list is
  explicit.
- `CLAUDE.md`, `AGENTS.md`, and `opencode.md` exist in **two places**: at the
  repo root (repomemo's own adapters) and under `templates/` (what `repomemo
  init` writes for users). All three sets must always be in sync with each
  other and with `bin/repomemo`'s `SCAFFOLD_FILES` array.

## CLI conventions

- `bin/repomemo init` is **safe by default** — it skips existing files. Only
  `--force` overwrites. Never change this default without a release note.
- `bin/repomemo check --strict` verifies adapter read order and content drift,
  and in the repomemo source repo also verifies that `templates/` matches the
  runtime `SCAFFOLD_FILES` list.
- `bin/repomemo` resolves its template directory relative to its own location
  (following symlinks). The Homebrew formula rewrites the resolved path at
  install time; do not rely on environment variables for template lookup.
- Version is hard-coded at the top of `bin/repomemo` as `VERSION="X.Y.Z"`.
  Bumping the version means editing `bin/repomemo`, `homebrew/repomemo.rb`,
  and `package.json` together (see *Distribution* below for details).

## Update protocol

- Update `.ai/handoff.md` **before** reporting any task as done, even small
  ones. The user relies on it as the live status file.
- Only put truly durable knowledge in this file. Task-specific notes belong
  in `handoff.md`; they get overwritten each task.

## Distribution

- The Homebrew tap repository is `SUN-1024/homebrew-repomemo`.
- The formula at `homebrew/repomemo.rb` in this repo is a reference copy; the
  canonical version lives in the tap.
- Releases are triggered by pushing a `v*.*.*` tag. The action attaches the
  source tarball and prints its SHA256 so the formula can be updated.
- The npm package name is **`repomemo`**. When publishing, update the
  `version` field in `package.json` in lockstep with `bin/repomemo` and
  `homebrew/repomemo.rb`.
- The curl installer is `install.sh` at the repo root. It is served via
  `https://raw.githubusercontent.com/SUN-1024/repomemo/main/install.sh`,
  so any change must keep `set -euo pipefail` semantics safe and must keep
  honoring `REPOMEMO_VERSION` and `REPOMEMO_PREFIX`.
- Bumping a version is a five-file change: `bin/repomemo` (`VERSION=`),
  `homebrew/repomemo.rb` (`version`, `url`, `sha256`), `package.json`
  (`version`), plus the `EXPECTED_VERSION` in `tests/test_repomemo.sh`, and
  a new git tag. `install.sh` reads the latest tag at runtime, so it does
  not need an edit.

## Branding

- repomemo is **tool-neutral**. No single AI coding agent (Claude Code,
  Codex, Cursor, etc.) is named as a contributor, author, maintainer, or
  project identity. Listed agents are compatibility targets only.
- When adding new agent names, list them as compatibility references, not
  as authors.

## Language

- All `.ai/` content is written in English so any agent can parse it.
- Human-facing READMEs are bilingual: `README.md` (English) and
  `README.zh.md` (Simplified Chinese). Keep them in sync per change.

## Cross-platform

- Do not introduce symlinks inside the repo. `CLAUDE.md`, `AGENTS.md`, and
  `opencode.md` are real files. Reasons: Windows clones, shallow clones, and
  some CI runners handle symlinks inconsistently.
- Bash version target is **3.2** (macOS default). Avoid Bash 4+ syntax such
  as associative arrays.

## Common pitfalls

- Do not add a hook configuration (`.claude/settings.json`, Cursor rules,
  etc.) here. Hooks belong to the consuming project and depend on its
  language and tooling.
- Do not rename `.ai/` to something else — all three adapters point at it by
  name. A rename is a breaking change for every downstream consumer.
- Do not add Chinese text inside `.ai/`. It bloats the agent context for
  English-speaking agents and the bilingual coverage already lives in the
  human-facing READMEs.
