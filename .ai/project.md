# Project

## Purpose

`memsync` is a **bootstrap scaffold** — a small set of
markdown files that any new (or existing) repository can drop in to give Claude
Code and Codex a shared, version-controlled project memory.

It exists because:

- Claude Code reads `CLAUDE.md` and supports `@path` imports.
- Codex and several other agents read `AGENTS.md` as plain instructions.
- Without a shared layout, the two tools drift: one knows about a decision the
  other does not, and the human has to reconcile them.

This repo is the convention itself. Cloning or copying it into a project gives
you the structure; filling in the files makes it yours.

## Users / stakeholders

- **Engineers running both Claude Code and Codex** on the same repo — the
  primary audience.
- **Engineers running any single agent** that respects `AGENTS.md` or
  `CLAUDE.md` — still benefits from the structure, even if only one adapter is
  used.
- **Reviewers** of agent-authored PRs — `review-checklist.md` and
  `definition-of-done.md` give them a stable rubric.

## Scope

- Documentation and convention files only (`.ai/`, `CLAUDE.md`, `AGENTS.md`,
  `README*.md`, `LICENSE`, `.gitignore`).
- Read-order rules and update rules for agents.
- Bilingual entry-point README (English + Simplified Chinese).

## Non-goals

- Not a runtime, library, CLI, or language-specific framework.
- Not a hook system or settings file generator (Claude Code's `settings.json`
  hooks live elsewhere; this template does not configure them).
- Not opinionated about which agent is "primary" — both adapters are equal.
- Not a replacement for repo-specific docs like `CONTRIBUTING.md` or ADRs;
  it is the *agent-facing* layer that complements them.

## Constraints

- Markdown only. No executable code, no build pipeline.
- Tool-agnostic wording inside `.ai/` so any agent can read it.
- `CLAUDE.md` uses Claude's `@./path` import syntax; `AGENTS.md` uses an
  explicit ordered list because not every agent supports `@`-imports.
- Cross-platform: avoid symlinks; keep `CLAUDE.md` and `AGENTS.md` as real
  files so Windows and shallow clones work.

## Runtime assumptions

None. Files are static markdown read by the agent harness.

## Deploy targets

Not applicable — this repository is published as a GitHub template/source. There
is no service to deploy.

## External services

- GitHub (hosting, releases).
- Optional: any agent harness that reads `CLAUDE.md` or `AGENTS.md`.
