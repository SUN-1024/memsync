# memsync

> **Languages:** **English** · [简体中文](./README.zh.md)

A small CLI that drops a shared, version-controlled **AI project memory** into
any repository. Run `memsync init` and any AI coding agent that respects
either the `CLAUDE.md` or `AGENTS.md` convention will read the same project
facts, in the same order, every session.

```bash
memsync init      # scaffold .ai/, CLAUDE.md, AGENTS.md in the current repo
memsync check     # validate the scaffold is complete and non-empty
```

memsync is **tool-neutral**. It is not authored by, owned by, or specific to
any single AI agent. The list of supported / compatible agents (Claude Code,
Codex, Cursor, and any other tool that reads `CLAUDE.md` or `AGENTS.md`) is
not the same as the list of project contributors.

## What it generates

```
.ai/
  README.md              # convention + read order
  project.md             # purpose, stakeholders, scope, non-goals
  architecture.md        # stack, layout, components, decisions
  definition-of-done.md  # what "done" means in this repo
  review-checklist.md    # PR review rubric
  memory.md              # durable shared knowledge
  handoff.md             # rolling state of the latest task
CLAUDE.md                # adapter for agents that resolve @./path imports
AGENTS.md                # adapter for agents that read a numbered file list
```

`CLAUDE.md` and `AGENTS.md` never duplicate content; they only point into
`.ai/`. Every agent sees the same files in the same order.

## Why

Different AI coding agents read different instruction files at session start.
Without a shared layout, two agents in the same repo drift: one knows about
a decision the other does not, and a human spends time reconciling them.

memsync encodes the smallest convention that gives every supported agent
a single source of truth, without locking the project into a particular
language, framework, or harness.

## Install

### Homebrew (recommended)

```bash
brew tap SUN-1024/memsync
brew install memsync
```

The tap repository is `SUN-1024/homebrew-memsync`; the formula is mirrored
inside this repo at `homebrew/memsync.rb` for reference.

### From source

```bash
git clone https://github.com/SUN-1024/memsync.git
cd memsync
ln -s "$PWD/bin/memsync" /usr/local/bin/memsync   # or any directory on $PATH
```

### Without installing

```bash
git clone https://github.com/SUN-1024/memsync.git
./memsync/bin/memsync --help
```

## Usage

```bash
memsync init                    # initialize in the current directory
memsync init --target ./my-app  # initialize in a different directory
memsync init --force            # overwrite existing files (dangerous)
memsync check                   # validate the current directory
memsync check ./my-app          # validate another path
memsync --version
memsync --help
```

`memsync init` is **safe by default**: existing files are reported as
*skipped*, never overwritten silently. Pass `--force` only when you know you
want to replace the current scaffold.

After running `init`, edit the generated `.ai/project.md` and
`.ai/architecture.md` so they describe your real project, then commit
everything.

## How agents read the generated files

```
session starts
  agent that reads CLAUDE.md  ─► resolves @./path imports ─► loads .ai/* in order
  agent that reads AGENTS.md  ─► follows the numbered list ─► loads .ai/* in order

agent does work
  before reporting "done":
    update .ai/handoff.md   (always)
    update .ai/memory.md    (when a stable fact emerges)
```

The read order is fixed:
`README.md → project.md → architecture.md → definition-of-done.md → review-checklist.md → memory.md → handoff.md`.

## The only runtime rule

After **any** implementation, debugging, refactor, review, documentation,
setup, dependency, config, or test-related task, agents update
`.ai/handoff.md` **before** declaring the task done. Stable knowledge
discovered during the task is appended to `.ai/memory.md` (or the most
relevant `.ai/` file) in the same change.

`.ai/` files never contain `TODO` / `TBD` / placeholder text. If a fact is
genuinely undefined for a project, the file says so in one clear sentence.

## Without installing the CLI: paste-a-prompt path

If you would rather have an agent read your repo and generate the scaffold
from scratch (instead of using the CLI), paste the following prompt into a
fresh session of any AI coding agent in the target repository:

```text
Initialize this repository for shared AI project memory across any agent
that reads CLAUDE.md or AGENTS.md.

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

## Supported AI coding agents

memsync ships with two adapters because different agents read different
instruction files at session start:

- `CLAUDE.md` — used by agents that natively resolve `@./path` imports.
- `AGENTS.md` — used by agents that read an explicit numbered file list.

Listed agents are **compatible**, not contributors. memsync does not ship as
a plugin to any of them, and they did not author this repository.

## Development

memsync is a single Bash script plus a `templates/` directory.

```bash
# run tests
bash tests/test_memsync.sh

# run the CLI directly from the repo without installing
bash bin/memsync --help

# memsync should pass its own check on this repository
bash bin/memsync check .
```

### Releases

1. Update `VERSION` in `bin/memsync` and the `version` / `url` lines in
   `homebrew/memsync.rb`.
2. Tag the commit: `git tag v1.0.0 && git push --tags`. The release workflow
   in `.github/workflows/release.yml` creates a GitHub release from the tag
   and prints the SHA256 of the source tarball.
3. Copy the SHA256 into `homebrew/memsync.rb` and push the formula to
   `SUN-1024/homebrew-memsync` so `brew install memsync` picks it up.

## What this is *not*

- Not a runtime, library, language-specific framework, or hook system.
- Not a `settings.json` generator (those live in the consuming project).
- Not opinionated about which AI agent is "primary" — every supported
  adapter is equal.

## License

[MIT](./LICENSE)
