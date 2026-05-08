#!/usr/bin/env bash
# tests/test_repomemo.sh — integration tests for bin/repomemo.
#
# Runs without any harness: plain Bash assertions against a temporary
# working directory. Exits 0 when every test passes, 1 otherwise.

set -u

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MEMSYNC="$ROOT/bin/repomemo"
EXPECTED_VERSION="1.0.0"

PASS=0
FAIL=0
FAILED_TESTS=()

# Per-test scratch directory; reset before each test.
WORK=""

setup() {
  WORK="$(mktemp -d -t repomemo-test.XXXXXX)"
}

teardown() {
  if [ -n "$WORK" ] && [ -d "$WORK" ]; then
    rm -rf "$WORK"
  fi
  WORK=""
}

run_test() {
  local name="$1"
  shift
  setup
  if "$@"; then
    echo "PASS  $name"
    PASS=$((PASS + 1))
  else
    echo "FAIL  $name"
    FAIL=$((FAIL + 1))
    FAILED_TESTS+=("$name")
  fi
  teardown
}

# Assertion helpers — each prints a useful message on failure and returns 1.
assert_eq() {
  local actual="$1" expected="$2" label="$3"
  if [ "$actual" != "$expected" ]; then
    echo "  $label: expected '$expected', got '$actual'" >&2
    return 1
  fi
}

assert_contains() {
  local haystack="$1" needle="$2" label="$3"
  if ! printf '%s' "$haystack" | grep -q -- "$needle"; then
    echo "  $label: expected output to contain '$needle'" >&2
    echo "  output was:" >&2
    echo "$haystack" | sed 's/^/    /' >&2
    return 1
  fi
}

assert_file_nonempty() {
  local path="$1"
  if [ ! -f "$path" ]; then
    echo "  expected file to exist: $path" >&2
    return 1
  fi
  if [ ! -s "$path" ]; then
    echo "  file exists but is empty: $path" >&2
    return 1
  fi
}

EXPECTED_FILES=(
  ".ai/README.md"
  ".ai/project.md"
  ".ai/architecture.md"
  ".ai/definition-of-done.md"
  ".ai/review-checklist.md"
  ".ai/memory.md"
  ".ai/handoff.md"
  "CLAUDE.md"
  "AGENTS.md"
)

# 1. --version exits 0 and prints the expected version line.
test_version() {
  local out rc
  out="$(bash "$MEMSYNC" --version 2>&1)"
  rc=$?
  assert_eq "$rc" "0" "exit code" || return 1
  assert_eq "$out" "repomemo ${EXPECTED_VERSION}" "version output" || return 1
}

# 2. --help exits 0 and mentions the public commands and options.
test_help() {
  local out rc
  out="$(bash "$MEMSYNC" --help 2>&1)"
  rc=$?
  assert_eq "$rc" "0" "exit code" || return 1
  assert_contains "$out" "USAGE" "help banner"   || return 1
  assert_contains "$out" "init"   "help mentions init"  || return 1
  assert_contains "$out" "check"  "help mentions check" || return 1
  assert_contains "$out" "--force" "help mentions --force" || return 1
}

# 3. init creates every scaffold file in a clean target directory.
test_init_creates_all_files() {
  local out rc
  out="$(bash "$MEMSYNC" init --target "$WORK" 2>&1)"
  rc=$?
  assert_eq "$rc" "0" "exit code" || { echo "$out" | sed 's/^/    /' >&2; return 1; }
  for rel in "${EXPECTED_FILES[@]}"; do
    assert_file_nonempty "$WORK/$rel" || return 1
  done
  assert_contains "$out" "9 created" "summary line" || return 1
}

# 4. init is idempotent: a second run reports everything as skipped and
#    leaves files untouched.
test_init_idempotent() {
  bash "$MEMSYNC" init --target "$WORK" >/dev/null 2>&1 \
    || { echo "  initial init failed" >&2; return 1; }

  # Capture mtimes before the second run.
  local before_sums
  before_sums="$(cd "$WORK" && shasum "${EXPECTED_FILES[@]}")" \
    || { echo "  could not hash initialized files" >&2; return 1; }

  local out rc
  out="$(bash "$MEMSYNC" init --target "$WORK" 2>&1)"
  rc=$?
  assert_eq "$rc" "0" "exit code" || return 1
  assert_contains "$out" "0 created" "no new files" || return 1
  assert_contains "$out" "9 skipped" "all skipped"  || return 1

  local after_sums
  after_sums="$(cd "$WORK" && shasum "${EXPECTED_FILES[@]}")"
  assert_eq "$after_sums" "$before_sums" "file contents unchanged" || return 1
}

# 5. --force on a populated dir overwrites, and reports as overwritten.
test_init_force_overwrites() {
  bash "$MEMSYNC" init --target "$WORK" >/dev/null 2>&1 || return 1

  # Mutate one of the files so we can detect the overwrite.
  echo "MUTATED" > "$WORK/.ai/handoff.md"

  local out rc
  out="$(bash "$MEMSYNC" init --target "$WORK" --force 2>&1)"
  rc=$?
  assert_eq "$rc" "0" "exit code" || return 1
  assert_contains "$out" "9 overwritten" "all overwritten" || return 1

  if grep -q "MUTATED" "$WORK/.ai/handoff.md"; then
    echo "  expected --force to replace mutated content, but it remains" >&2
    return 1
  fi
}

# 6. check passes on a freshly initialized directory.
test_check_passes_after_init() {
  bash "$MEMSYNC" init --target "$WORK" >/dev/null 2>&1 || return 1
  local out rc
  out="$(bash "$MEMSYNC" check "$WORK" 2>&1)"
  rc=$?
  assert_eq "$rc" "0" "exit code" || { echo "$out" | sed 's/^/    /' >&2; return 1; }
  assert_contains "$out" "repomemo check: OK" "OK summary" || return 1
  if printf '%s' "$out" | grep -q "^FAIL"; then
    echo "  unexpected FAIL line in output" >&2
    return 1
  fi
}

# 7. check fails on an empty directory and exits non-zero.
test_check_fails_on_empty() {
  local out rc
  out="$(bash "$MEMSYNC" check "$WORK" 2>&1)"
  rc=$?
  if [ "$rc" -eq 0 ]; then
    echo "  expected non-zero exit, got 0" >&2
    return 1
  fi
  assert_contains "$out" "missing" "reports missing files" || return 1
  assert_contains "$out" "repomemo check:" "summary line"   || return 1
}

# 8. repomemo passes its own check (the repo follows the convention it ships).
test_self_check() {
  local out rc
  out="$(bash "$MEMSYNC" check "$ROOT" 2>&1)"
  rc=$?
  assert_eq "$rc" "0" "exit code on self-check" \
    || { echo "$out" | sed 's/^/    /' >&2; return 1; }
}

echo "running repomemo integration tests against $MEMSYNC"
echo

run_test "repomemo --version"                       test_version
run_test "repomemo --help"                          test_help
run_test "repomemo init creates the full scaffold"  test_init_creates_all_files
run_test "repomemo init is idempotent"              test_init_idempotent
run_test "repomemo init --force overwrites"         test_init_force_overwrites
run_test "repomemo check passes after init"         test_check_passes_after_init
run_test "repomemo check fails on empty dir"        test_check_fails_on_empty
run_test "repomemo passes its own check"            test_self_check

echo
echo "summary: ${PASS} passed, ${FAIL} failed"
if [ "$FAIL" -ne 0 ]; then
  echo "failed tests:"
  for name in "${FAILED_TESTS[@]}"; do
    echo "  - $name"
  done
  exit 1
fi
exit 0
