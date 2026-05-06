# Review Checklist

Use this list when reviewing any pull request against this repository. Drop
items that do not apply to the project; add items that do.

## Correctness

- [ ] The diff implements what the PR description says it does.
- [ ] Edge cases (empty input, errors, concurrency) are handled or documented.
- [ ] No regressions in adjacent behavior.

## Tests

- [ ] New behavior is covered by tests at the right level.
- [ ] Existing tests still pass locally.
- [ ] Flaky or skipped tests are explained in the PR description.

## Typing / static analysis

- [ ] Typechecker passes (if configured).
- [ ] No new `any` / `unknown` / dynamic escapes without justification.

## Lint / format

- [ ] Linter passes.
- [ ] Formatter has been run.

## Security

- [ ] No secrets, API keys, tokens, or private hostnames committed.
- [ ] New dependencies are vetted; lockfile is updated.
- [ ] Auth / permission changes are called out explicitly in the PR description.
- [ ] User input that crosses a trust boundary is validated and/or escaped.

## Performance

- [ ] No obvious N+1 queries, unbounded loops, or hot-path regressions.
- [ ] New external calls have timeouts, retries, and back-pressure where
      appropriate.

## Documentation

- [ ] User-visible changes are reflected in the README and other docs.
- [ ] `.ai/handoff.md` was updated for this change.
- [ ] If stable knowledge emerged, `.ai/memory.md` was updated.

## Compatibility

- [ ] Public API / config / CLI changes are flagged in the PR description with
      a migration note.
- [ ] No symlinks or platform-specific paths added without a clear reason.

## Deployment risk

- [ ] Migrations, feature flags, or rollout steps are documented.
- [ ] Rollback path is described or trivially obvious.

## Final pass

- [ ] PR title and description match the actual change.
- [ ] A reviewer can follow `.ai/handoff.md` and reproduce the state described.
