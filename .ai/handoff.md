# Handoff — rolling state

Update this file **before** reporting any task as done. Overwrite previous
sections with the latest state; this file is not a changelog.

## Latest task

Enable the GitHub *template repository* flag and document a third adoption
path — paste a self-contained prompt into a fresh Claude Code or Codex
session — alongside the existing GitHub-template and copy-into-repo paths.

## Files changed

- `README.md` — Option A wording updated (template flag is on); new
  Option C added with the full English prompt.
- `README.zh.md` — 方式 A 措辞同步;新增方式 C,附中文提示词。
- `.ai/handoff.md` — this file, rewritten to reflect the latest task.

## Commands run

- `gh repo edit SUN-1024/memsync --template`
- `gh repo view --json isTemplate,url -q ...` (verification)
- `git add README.md README.zh.md .ai/handoff.md`
- `git commit -m "docs: add prompt-based adoption path; mark repo as GitHub template"`
- `git push`

## Checks performed

- `gh repo view --json isTemplate` returned `isTemplate=true`.
- Both READMEs were re-read end to end after editing; Option A / 方式 A
  wording and Option C / 方式 C bodies stay in sync between languages.
- Read order in `CLAUDE.md` and `AGENTS.md` was not touched and remains
  in sync.
- `git status` clean after the new commit.

## Current state

- Repository is **public** *and* marked as a **template repository** at
  `https://github.com/SUN-1024/memsync`.
- README documents three adoption paths:
  - **A.** Click *Use this template* on GitHub.
  - **B.** Clone and copy `.ai/`, `CLAUDE.md`, `AGENTS.md` into an existing
    repo.
  - **C.** Paste a self-contained prompt into a fresh Claude Code / Codex
    session and let the agent generate the scaffold from the target repo.

## Unresolved unknowns

- The Option C prompt was authored to be tool-agnostic; it has not yet
  been re-tested against a Codex session in this repository. Behaviour with
  Codex is expected to match Claude Code because the prompt does not rely
  on `@`-imports or any Claude-specific feature, but this assumption is
  not yet validated.

## Next safe action

For a downstream consumer:

1. Pick one of the three adoption paths in `README.md` / `README.zh.md`.
2. After applying it, edit `.ai/project.md` and `.ai/architecture.md` to
   describe the target project honestly, and replace the *Required
   commands* section of `.ai/definition-of-done.md`.
3. Reset `.ai/handoff.md` so it describes the adoption itself as the
   latest task.

For this scaffold repository:

- Optionally add a CHANGELOG once a second meaningful change lands; until
  then, `handoff.md` plus `git log` are sufficient.
