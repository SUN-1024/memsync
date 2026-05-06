# Architecture

## Stack

- **Bash** (3.2+) for the CLI script.
- **Markdown** (CommonMark / GitHub-flavored) for the scaffold and docs.
- **Git** for versioning.
- **GitHub** for hosting, releases, and Actions.
- **Homebrew** as the primary distribution channel.

There is no compiler, no language runtime, no build step, and no test
framework beyond plain Bash assertions.

## Repository layout

```
memsync/
├── .ai/                          # memsync's own project memory
│   ├── README.md
│   ├── project.md
│   ├── architecture.md           # this file
│   ├── definition-of-done.md
│   ├── review-checklist.md
│   ├── memory.md
│   └── handoff.md
├── .github/
│   └── workflows/
│       └── release.yml           # GitHub Actions release workflow
├── bin/
│   └── memsync                   # Bash CLI (chmod +x)
├── templates/                    # source for `memsync init`
│   ├── .ai/
│   │   ├── README.md
│   │   ├── project.md
│   │   ├── architecture.md
│   │   ├── definition-of-done.md
│   │   ├── review-checklist.md
│   │   ├── memory.md
│   │   └── handoff.md
│   ├── CLAUDE.md
│   └── AGENTS.md
├── tests/
│   └── test_memsync.sh           # integration tests
├── homebrew/
│   └── memsync.rb                # Homebrew formula (reference copy)
├── AGENTS.md                     # Codex-style adapter
├── CLAUDE.md                     # Claude Code-style adapter
├── README.md                     # English entry point
├── README.zh.md                  # Simplified Chinese entry point
├── LICENSE                       # MIT
└── .gitignore
```

## Components

### `bin/memsync` — the CLI

A single Bash script. Subcommands:

- `init [--force] [--target DIR]` — copies every file in `templates/` into
  the target directory. Skips existing files unless `--force` is given.
- `check [PATH]` — verifies that the target directory contains all nine
  scaffold files and that none are empty.
- `--help` / `--version` — usage and version output.

The script discovers its template directory by resolving `BASH_SOURCE[0]`
(following symlinks) and looking at `../templates`. The Homebrew formula
patches that path at install time so it points at
`#{share}/memsync/templates`.

### `templates/` — the scaffold source

Contains the seven generic `.ai/` markdown files plus the two root adapters
(`CLAUDE.md`, `AGENTS.md`). These files are what `memsync init` writes into a
target repo. They use tool-neutral language and never contain `TODO`/`TBD`.

### `.ai/` — memsync's own project memory

Same seven files, but populated with facts about memsync itself. The repo
follows the convention it ships, so `memsync check .` passes inside the repo.

### `homebrew/memsync.rb` — distribution formula

A reference copy of the Homebrew formula. The canonical version lives in the
`SUN-1024/homebrew-memsync` tap repository; this copy exists so reviewers can
see the formula in the same diff as the changes to `bin/memsync`.

### `tests/test_memsync.sh` — integration tests

Bash assertions exercising every subcommand: `--version`, `--help`, `init`
into a temp dir, `init` again for idempotency, `check` on a populated dir,
`check` on an empty dir.

### `.github/workflows/release.yml` — release automation

Triggered by pushing a `v*.*.*` tag. Creates a GitHub release from the tag
and prints the SHA256 of the source tarball so the maintainer can update the
Homebrew formula.

## Data flow

```
maintainer:                                      end user:
  edit code/templates                              brew install memsync
  → run `bash tests/test_memsync.sh`               → memsync init in their repo
  → tag v1.X.Y                                       → templates/ copied into .ai/
  → GitHub Action publishes release                  → CLAUDE.md + AGENTS.md
  → update homebrew tap with new SHA256              → AI agent at session start
  → user `brew upgrade memsync`                        reads .ai/* in fixed order
                                                     → updates handoff.md before
                                                       reporting "done"
```

## Dependencies

None at runtime, beyond Bash 3.2+ and POSIX utilities (`cp`, `mkdir`,
`readlink`, `find`). No language runtime, no package manager, no compiled
artifacts.

## Entry points

- For end users: the `memsync` command after install, or `bash bin/memsync`
  from a clone.
- For agents working on this repo: `CLAUDE.md` (Claude Code) or `AGENTS.md`
  (Codex / generic).
- For human readers: `README.md` (English) or `README.zh.md` (中文).

## Visible design decisions

1. **Bash, not Python or Go.** Keeps the install path trivial (no runtime
   dependency), survives on every Mac and Linux without setup, and matches
   the size of the problem.
2. **`.ai/` is meta, `templates/` is the scaffold.** memsync's own `.ai/`
   describes memsync itself; the generic scaffold lives in `templates/` and
   is what users actually receive.
3. **Skip-by-default `init`.** Existing files are reported as *skipped*, not
   silently overwritten. `--force` is opt-in and documented.
4. **Homebrew via inreplace, not env vars.** The formula rewrites the
   `TEMPLATE_DIR` line at install time; the script remains a plain file
   without runtime configuration.
5. **Two real adapter files, not a symlink.** Different agents read
   different files; symlinks behave inconsistently across OSes and shallow
   clones.
6. **English inside `.ai/`.** Any agent should be able to read it. The
   Chinese README is for humans and is not part of the agent context.
7. **No tooling lock-in.** No required CLI lint config or generator. Anyone
   can read or edit the repo with a plain text editor.
