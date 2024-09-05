#! /usr/bin/env bash
# Copyright 2024 Raphael Thomazella. All rights reserved.
# Use of this source code is governed by the BSD-3-Clause
# license that can be found in the LICENSE file and online
# at https://opensource.org/license/BSD-3-clause.
#
# check that commit messages and PR title are conventional commits

set -euo pipefail
shopt -s globstar
trap 'err $LINENO' ERR

##########################
### vars and functions ###
##########################

CONVENTIONAL_COMMITS_URL="See https://www.conventionalcommits.org/en/v1.0.0/"

# Description: Parses a git log and checks if the commits are conventional
# Globals    : CONFIG_PATH (lib.sh)
# Args       : 1=git log
# STDOUT     : Problems found
# Example    : lint_commits "$log"
lint_commits() {
  local log="$1" problems="" out

  while read -r commit; do
    out="$(commitlint --config="$CONFIG_PATH" <<<"$commit" || true)"

    if [ "$out" ]; then
      problems+=("$out")
    fi
  done <<<"$log"

  printf %s "${problems[*]}"
}

# Description: Validates user input
# Globals    : BASE_REF, VERSION (github workflow)
# Sideeffects: Might install commitlint, might mutate BASE_REF
# Example    : validate_input "$@"
validate() {
  if [ ! "${BASE_REF:-}" ]; then
    BASE_REF=main
  fi

  if ! command -v commitlint >/dev/null; then
    npm install --global @commitlint/cli@"$VERSION" >/dev/null
  fi
}

# Description: Check if PR title is a conventional commit
# Globals    : PR_TITLE (github workflow), CONFIG_PATH (lib.sh), CONVENTIONAL_COMMITS_URL (script)
# STDOUT     : Messages
# STDERR     : Might print errors and logs
# Returns    : 1 if fail
# Example    : validate_input "$@"
lint_title() {
  if [ ! "${PR_TITLE:-}" ]; then
    return
  fi

  log $LINENO "$PR_TITLE"

  if ! commitlint --config="$CONFIG_PATH" <<<"$PR_TITLE"; then
    err $LINENO "PR title must be a conventional commit, got: $PR_TITLE"
    err $LINENO "$CONVENTIONAL_COMMITS_URL"
    return 1
  fi

  msgln PR title ok
}

# Description: Check if commit messages are conventional commits
# Globals    : BASE_REF (github workflow), CONVENTIONAL_COMMITS_URL (script)
# STDOUT     : Diagnostic report
# STDERR     : Might print errors and logs
# Returns    : 1 if fail
# Example    : lint_log
lint_log() {
  local revision=refs/remotes/origin/"$BASE_REF"..HEAD total_commits bad_commits git_log issues

  log $LINENO git log "$revision"

  git_log=$(git log --format=%s "$revision" --)

  if [ ! "$git_log" ]; then
    log $LINENO empty git log
    return
  fi

  log $LINENO "$git_log"

  issues=$(lint_commits "$git_log")

  if [ ! "$issues" ]; then
    msgln "commits ok"
    return
  fi

  total_commits=$(wc -l <<<"$git_log")
  bad_commits=$(grep -Eie input -c <<<"$issues")

  command cat <<-EOF
commits:
"$git_log"

linter\ output:

"$issues"

"Commit messages not formatted properly: $bad_commits out of $total_commits commits"
"$CONVENTIONAL_COMMITS_URL"
"To fix all, try 'git rebase -i $revision', change bad commits to 'reword', fix messages and 'git push --force'"
EOF

  return 1

}

##############
### script ###
##############

if [ ! "${LIB_LOADED:-}" ]; then
  echo -e "INFO  ($0:$LINENO) BASH_ENV=${BASH_ENV:-}" >&2
  echo -e "FATAL ($0:$LINENO) lib.sh not found. use 'export BASH_ENV=<lib.sh location>' or 'BASH_ENV=<lib.sh location> $0'" >&2
  exit 1
fi

validate
lint_title
lint_log
