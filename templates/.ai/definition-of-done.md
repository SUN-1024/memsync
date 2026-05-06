# Definition of Done

A change is **done** when every item below is satisfied. Adapt this list to the
project's real toolchain — replace each example command with the one this
repository actually uses, and remove any line that does not apply.

## Required commands

Replace these placeholders with the project's real commands. If a step is not
configured, write a single sentence saying so rather than leaving an example.

- **Build**: `make build` (or the project's equivalent).
- **Test**: `make test` (or `npm test`, `pytest`, `go test ./...`, etc.).
- **Lint**: `make lint` (or the project's equivalent).
- **Typecheck**: `make typecheck` (or `tsc --noEmit`, `mypy`, etc.).
- **Format**: `make fmt` (or the project's equivalent).

## A change is "done" when

1. The change compiles, lints, type-checks, formats, and tests pass locally.
2. New behavior is covered by tests at the appropriate level (unit /
   integration / end-to-end).
3. User-visible changes are reflected in the README and any user-facing docs.
4. `.ai/handoff.md` was updated *before* the task was reported as done.
5. If stable knowledge emerged during the task, `.ai/memory.md` (or the most
   relevant `.ai/` file) was updated in the same change.
6. No secrets, tokens, or private hostnames were committed.

## Review expectations

- Reviewers can run the commands above without extra setup.
- The diff matches what the PR description says it does — no unrelated churn.
- Migrations, feature flags, or rollout steps are documented in the PR
  description when they exist.

## Verification

State here how you verify the change end-to-end. Examples:

- Run the test suite locally and in CI.
- Hit the relevant endpoint with `curl` and confirm the response.
- Open the affected page in a browser and walk through the user flow.

If verification is purely manual, list the exact steps a reviewer should
follow.
