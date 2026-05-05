# memsync

> **Languages:** **English** · [简体中文](./README.zh.md)

A drop-in markdown scaffold that gives **Claude Code** and **Codex** (and any
agent that respects `AGENTS.md` / `CLAUDE.md`) a single, version-controlled
shared memory for a project. Stop the two tools from drifting into separate
mental models of the same repo.

## What this is

Seven small markdown files in `.ai/` plus two thin root adapters:

```
.ai/
  README.md              # convention + read order
  project.md             # purpose, stakeholders, scope, non-goals
  architecture.md        # stack, layout, components, decisions
  definition-of-done.md  # what "done" means in this repo
  review-checklist.md    # PR review rubric
  memory.md              # durable shared knowledge
  handoff.md             # rolling state of the latest task
CLAUDE.md                # Claude Code adapter — @./path imports
AGENTS.md                # Codex / generic adapter — explicit read list
```

`CLAUDE.md` and `AGENTS.md` never duplicate content; they only point into
`.ai/`. Every agent sees the same files in the same order.

## Why

- **Claude Code** reads `CLAUDE.md` and resolves `@./path` imports natively.
- **Codex** (and several other agents) read `AGENTS.md` as plain instructions.
- Without a shared layout, the two tools drift: one knows about a decision
  the other does not, and you spend cycles reconciling them by hand.

This repo encodes the smallest convention that lets both tools share one
project memory without locking you into a particular language, framework,
or harness.

## Quick start

### Option A — use as a GitHub template

1. On the repo page, click **Use this template** → *Create a new repository*.
2. Clone your copy.
3. Edit `.ai/project.md` and `.ai/architecture.md` to describe your real
   project.
4. Replace the *Required commands* section of `.ai/definition-of-done.md`
   with your project's real build / test / lint commands.
5. Reset `.ai/handoff.md` so it describes the adoption itself as the latest
   task.

### Option B — copy into an existing repo

```bash
git clone https://github.com/SUN-1024/memsync scaffold
cp -r scaffold/.ai ./
cp scaffold/CLAUDE.md scaffold/AGENTS.md ./
rm -rf scaffold
```

Then edit the files as in Option A.

### Option C — paste a prompt at the start of a session

If you would rather have an agent read your repo and generate the scaffold
from scratch (instead of cloning a static copy), paste the following prompt
into a fresh Claude Code or Codex session in the target repository:

```text
Initialize this repository for shared-memory dual-agent development across
Claude Code and Codex.

1. Inspect the repo first: READMEs, package manifests, source tree, configs,
   scripts, tests, CI, Docker / deploy files, docs, and any existing AI
   instruction files. Only write facts that are supported by the repository —
   no placeholders, no "TODO", no invented purpose / commands / architecture.

2. Create `.ai/` with seven files, each populated from the real repo state:
   - `README.md`             explains the convention; agents read these files
                             in order before any work and update `handoff.md`
                             before reporting done.
   - `project.md`            purpose, stakeholders, scope, constraints,
                             runtime, deploy targets, external services,
                             non-goals.
   - `architecture.md`       stack, repo layout, components, data flow,
                             dependencies, entry points, visible decisions.
   - `definition-of-done.md` real build / test / lint / typecheck / format
                             commands; if a command is not defined, say so
                             in one sentence rather than inventing one.
   - `review-checklist.md`   practical PR checklist (correctness, tests,
                             typing, lint, security, perf, docs, compat,
                             deployment risk).
   - `memory.md`             durable shared knowledge, conventions,
                             constraints, recurring pitfalls.
   - `handoff.md`            latest task, files changed, commands run, checks
                             performed, current state, unresolved unknowns,
                             next safe action.

3. Create thin root adapters:
   - `CLAUDE.md` containing only `@./.ai/<file>` imports for the seven files
     above, in the read order defined by `.ai/README.md`.
   - `AGENTS.md` listing the same seven files in the same order as a numbered
     reading list, plus the rule: "After future implementation, debugging,
     refactor, review, documentation, setup, dependency, config, or test
     tasks, update `.ai/handoff.md` before reporting done; update
     `.ai/memory.md` when stable knowledge emerges."

4. Verify: list the created files and run `git status`. Run any safe existing
   checks only if they are already configured in the repo.

5. Final response: summarize files created/updated, key facts inferred,
   unknowns, and checks run.
```

The agent does the inspection and writing; you only review the result.

## How agents read this repo

```
session starts
  Claude Code  ─► CLAUDE.md  ─► @-imports resolve  ─► loads .ai/* in order
  Codex / other ─► AGENTS.md ─► follows the numbered list ─► loads .ai/* in order

agent does work
  before reporting "done":
    update .ai/handoff.md   (always)
    update .ai/memory.md    (when a stable fact emerges)
```

The read order is fixed:
`README.md → project.md → architecture.md → definition-of-done.md → review-checklist.md → memory.md → handoff.md`.

## Update rule (the only rule that matters at runtime)

After **any** implementation, debugging, refactor, review, documentation,
setup, dependency, config, or test-related task, update `.ai/handoff.md`
**before** declaring the task done. If you discovered something durable about
the project, append it to `.ai/memory.md` (or the most relevant `.ai/` file)
in the same change.

Never write `TODO` / `TBD` / placeholder text into `.ai/`. If a fact is
genuinely undefined, write one clear sentence saying so.

## What this is *not*

- Not a runtime, library, CLI, or language-specific framework.
- Not a hook system or `settings.json` generator (those belong to the
  consuming project).
- Not opinionated about which agent is "primary" — both adapters are equal.

## License

[MIT](./LICENSE)
