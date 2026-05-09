# Architecture

## Stack

- **Bash** (3.2+) for the CLI script.
- **Markdown** (CommonMark / GitHub-flavored) for the scaffold and docs.
- **Git** for versioning.
- **GitHub** for hosting, releases, and Actions.
- **Homebrew**, **curl-pipe-bash**, and **npm** as parallel distribution
  channels. All three install the same `repomemo` binary.

There is no compiler, no language runtime, no build step, and no test
framework beyond plain Bash assertions.

## Repository layout

```
repomemo/
├── .ai/                          # repomemo's own project memory
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
│   └── repomemo                   # Bash CLI (chmod +x)
├── templates/                    # source for `repomemo init`
│   ├── .ai/
│   │   ├── README.md
│   │   ├── project.md
│   │   ├── architecture.md
│   │   ├── definition-of-done.md
│   │   ├── review-checklist.md
│   │   ├── memory.md
│   │   └── handoff.md
│   ├── CLAUDE.md
│   ├── AGENTS.md
│   └── opencode.md
├── tests/
│   └── test_repomemo.sh           # integration tests
├── homebrew/
│   └── repomemo.rb                # Homebrew formula (reference copy)
├── install.sh                    # curl one-liner installer
├── package.json                  # npm wrapper (package name: repomemo)
├── AGENTS.md                     # Codex-style adapter
├── CLAUDE.md                     # Claude Code-style adapter
├── opencode.md                   # OpenCode-style adapter
├── README.md                     # English entry point
├── README.zh.md                  # Simplified Chinese entry point
├── LICENSE                       # MIT
└── .gitignore
```

## Components

### `bin/repomemo` — the CLI

A single Bash script. Subcommands:

- `init [--force] [--target DIR]` — copies every file in `templates/` into
  the target directory. Skips existing files unless `--force` is given.
- `check [PATH]` — verifies that the target directory contains all nine
  scaffold files and that none are empty.
- `--help` / `--version` — usage and version output.

The script discovers its template directory by resolving `BASH_SOURCE[0]`
(following symlinks) and looking at `../templates`. The Homebrew formula
patches that path at install time so it points at
`#{share}/repomemo/templates`.

### `templates/` — the scaffold source

Contains the seven generic `.ai/` markdown files plus the three root adapters
(`CLAUDE.md`, `AGENTS.md`, `opencode.md`). These files are what `repomemo init`
writes into a target repo. They use tool-neutral language and never contain
`TODO`/`TBD`.

### `.ai/` — repomemo's own project memory

Same seven files, but populated with facts about repomemo itself. The repo
follows the convention it ships, so `repomemo check .` passes inside the repo.

### `homebrew/repomemo.rb` — distribution formula

A reference copy of the Homebrew formula. The canonical version lives in the
`SUN-1024/homebrew-repomemo` tap repository; this copy exists so reviewers can
see the formula in the same diff as the changes to `bin/repomemo`.

### `install.sh` — curl-pipe-bash installer

A standalone Bash installer hosted at the repo root and intended to be run
via `curl -fsSL .../install.sh | bash`. It downloads the release tarball
from GitHub, copies `bin/repomemo` to `$PREFIX/bin/repomemo`, copies
`templates/` to `$PREFIX/share/repomemo/templates`, and rewrites
`TEMPLATE_DIR` in the installed script with `awk` so it points at the
share directory. Honors `REPOMEMO_VERSION` (default: latest release) and
`REPOMEMO_PREFIX` (default: `/usr/local`) and falls back to `sudo` only if
the prefix is not writable.

### `package.json` — npm wrapper

Publishes the same Bash CLI to the npm registry as `repomemo`. Bash 3.2+
remains a runtime requirement; the package only adds another distribution
surface, not a Node implementation.

### `tests/test_repomemo.sh` — integration tests

Bash assertions exercising every subcommand: `--version`, `--help`, `init`
into a temp dir, `init` again for idempotency, `check` on a populated dir,
`check` on an empty dir.

### `.github/workflows/release.yml` — release automation

Triggered by pushing a `v*.*.*` tag. Creates a GitHub release from the tag
and prints the SHA256 of the source tarball so the maintainer can update the
Homebrew formula.

## Data flow

```
maintainer:                                      end user (any of):
  edit code/templates                              brew install repomemo
  → run `bash tests/test_repomemo.sh`               curl … install.sh | bash
  → tag v1.X.Y                                     npm install -g repomemo
  → GitHub Action publishes release                  → repomemo init in their repo
  → update homebrew tap with new SHA256                → templates/ copied into .ai/
  → user `brew upgrade repomemo`                          → CLAUDE.md + AGENTS.md + opencode.md
                                                       → AI agent at session start
                                                         reads .ai/* in fixed order
                                                       → updates handoff.md before
                                                         reporting "done"
```

## Dependencies

None at runtime, beyond Bash 3.2+ and POSIX utilities (`cp`, `mkdir`,
`readlink`, `find`, plus `curl`, `tar`, `awk`, `install` for `install.sh`).
No language runtime, no package manager, no compiled artifacts. The npm
package wraps the same Bash binary; it does not add a Node dependency.

## Entry points

- For end users: the `repomemo` command after install, or `bash bin/repomemo`
  from a clone.
- For agents working on this repo: `CLAUDE.md` (Claude Code) or `AGENTS.md`
  (Codex / generic).
- For human readers: `README.md` (English) or `README.zh.md` (中文).

## Visible design decisions

1. **Bash, not Python or Go.** Keeps the install path trivial (no runtime
   dependency), survives on every Mac and Linux without setup, and matches
   the size of the problem.
2. **`.ai/` is meta, `templates/` is the scaffold.** repomemo's own `.ai/`
   describes repomemo itself; the generic scaffold lives in `templates/` and
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
