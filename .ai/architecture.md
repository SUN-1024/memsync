# Architecture

## Stack

- **Markdown** (CommonMark / GitHub-flavored).
- **Git** for versioning.
- **GitHub** for hosting and (optional) template-repo distribution.

There is no runtime, no build step, no test runner. The "stack" is a convention
plus the agent harnesses that respect it.

## Repository layout

```
memsync/
├── .ai/
│   ├── README.md              # Convention explainer + read order
│   ├── project.md             # Purpose, stakeholders, scope, non-goals
│   ├── architecture.md        # This file
│   ├── definition-of-done.md  # What "done" means
│   ├── review-checklist.md    # PR review rubric
│   ├── memory.md              # Durable shared knowledge
│   └── handoff.md             # Rolling state of latest task
├── CLAUDE.md                  # Claude Code adapter (@-imports into .ai/)
├── AGENTS.md                  # Codex / generic adapter (explicit read order)
├── README.md                  # English entry-point for humans
├── README.zh.md               # Simplified Chinese entry-point for humans
├── LICENSE                    # MIT
└── .gitignore                 # Editor / OS noise only
```

## Components

### `.ai/` — shared project memory

The seven files in `.ai/` are read by every agent at session start. They are
the single source of truth; nothing in the root files duplicates their content.

### `CLAUDE.md` — Claude Code adapter

Pure `@./path` imports, in the read order defined by `.ai/README.md`. Claude
Code resolves these imports natively and inlines the content into the system
prompt.

### `AGENTS.md` — Codex / generic adapter

A short instruction file that names each `.ai/` file in the read order and
states the post-task update rule (update `handoff.md` before declaring done;
update `memory.md` when a stable fact emerges). It does not rely on `@`-import
syntax because agents other than Claude Code may not support it.

### `README.md` / `README.zh.md` — human entry points

For the human reader (browsing the repo on GitHub or locally). The Chinese
version mirrors the English one and links back to it; both files include a
language switcher at the top.

## Data flow

```
session starts
   │
   ├── Claude Code  ─► reads CLAUDE.md  ─► resolves @-imports ─► loads .ai/*
   │
   └── Codex / other ─► reads AGENTS.md ─► follows read-order list ─► loads .ai/*
                                                                          │
                              agent does work in the repo  ◄───────────────┘
                                       │
                              before declaring done:
                                  update .ai/handoff.md
                                  update .ai/memory.md if stable knowledge emerged
```

## Dependencies

None at runtime. The repository is plain markdown, intended to be consumed by
agent harnesses (Claude Code, Codex, etc.) rather than executed.

## Entry points

- For agents: `CLAUDE.md` (Claude Code) or `AGENTS.md` (Codex / generic).
- For humans: `README.md` (English) or `README.zh.md` (中文).

## Visible design decisions

1. **Two adapter files, not a symlink.** `AGENTS.md` is a real file because
   Claude Code's `@`-import syntax and Codex's reading conventions are not
   identical, and symlinks behave inconsistently across OSes and shallow clones.
2. **`.ai/` as the only source of truth.** Adapters never duplicate content;
   they only point to it. This guarantees the two tools see the same text.
3. **`handoff.md` is rolling, `memory.md` is stable.** Splitting state from
   knowledge keeps the long-lived file from filling up with task chatter.
4. **English inside `.ai/`.** Any agent should be able to read it. The Chinese
   README is for humans only and is not part of the agent context.
5. **No tooling lock-in.** No required CLI, lint config, or generator. Anyone
   can read or edit the repo with a plain text editor.
