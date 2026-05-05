# Handoff — rolling state

Update this file **before** reporting any task as done. Overwrite previous
sections with the latest state; this file is not a changelog.

## Latest task

Initial scaffold of `memsync`: create the `.ai/`
shared-memory layout, the `CLAUDE.md` and `AGENTS.md` adapters, bilingual
READMEs, MIT license, and `.gitignore`; commit; publish to GitHub as a public
repository.

## Files changed

- `.ai/README.md` — new
- `.ai/project.md` — new
- `.ai/architecture.md` — new
- `.ai/definition-of-done.md` — new
- `.ai/review-checklist.md` — new
- `.ai/memory.md` — new
- `.ai/handoff.md` — new (this file)
- `CLAUDE.md` — new
- `AGENTS.md` — new
- `README.md` — new (English)
- `README.zh.md` — new (Simplified Chinese)
- `LICENSE` — new (MIT)
- `.gitignore` — new

## Commands run

- `mkdir -p ~/projects/memsync/.ai`
- `git init -b main`
- `git add .`
- `git commit -m "chore: initial scaffold for claude+codex shared memory"`
- `gh repo create SUN-1024/memsync --public --source . --push`

## Checks performed

- File presence verified for every file listed above.
- `CLAUDE.md` and `AGENTS.md` reviewed manually to confirm they list the
  seven `.ai/` files in the same order.
- `README.md` and `README.zh.md` cross-linked in their headers.
- `git status` clean after the initial commit.
- `gh repo view --web` (or the URL printed by `gh repo create`) confirms the
  repo is public on GitHub.

## Current state

- Repository initialised, committed, and pushed to
  `https://github.com/SUN-1024/memsync` as a public
  repository on the `main` branch.
- No CI, no tests, no build pipeline — by design (markdown-only scaffold).

## Unresolved unknowns

- None at the scaffold level. Adopting projects will need to fill in their
  own commands inside `.ai/definition-of-done.md` and adjust
  `.ai/architecture.md` to match their stack.

## Next safe action

For a downstream consumer:

1. Copy `.ai/`, `CLAUDE.md`, and `AGENTS.md` into the target repository.
2. Edit `.ai/project.md` and `.ai/architecture.md` to describe the target
   project honestly.
3. Replace the "Required commands" section of `.ai/definition-of-done.md`
   with the project's real commands.
4. Reset `.ai/handoff.md` to describe the adoption itself as the latest task.

For this scaffold repository:

- Optionally mark the GitHub repo as a **template repository** in its settings
  so others can click "Use this template".
