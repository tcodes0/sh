#! /usr/bin/env bash
# Copyright 2024 Raphael Thomazella. All rights reserved.
# Use of this source code is governed by the BSD-3-Clause
# license that can be found in the LICENSE file and online
# at https://opensource.org/license/BSD-3-clause.
#
# check that commit messages and PR title are conventional commits

set -euo pipefail
shopt -s globstar nullglob
trap 'err $LINENO' ERR

##########################
### vars and functions ###
##########################

CONVENTIONAL_COMMITS_URL="See https://www.conventionalcommits.org/en/v1.0.0/"

# Description: Validates user input
# Globals    : BASE_REF (github workflow)
# Sideeffects: Might exit the script with an error, might mutate BASE_REF
# Example    : validate_input "$@"
validate() {
  if [ ! "${BASE_REF:-}" ]; then
    BASE_REF=main
  fi

  if ! command -v commitlint >/dev/null; then
    fatal $LINENO "commitlint not found"
  fi

  if ! command -v cspell >/dev/null; then
    fatal $LINENO "cspell not found"
  fi
}

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
    fatal $LINENO "PR title must be a conventional commit, got: $PR_TITLE. See $CONVENTIONAL_COMMITS_URL"
  fi

  msgln PR title ok
}

# Description: Check if commit messages are conventional commits
# Globals    : BASE_REF (github workflow), CONVENTIONAL_COMMITS_URL (script)
# Args       : 1=git log
# STDOUT     : Ok message
# STDERR     : Might print errors and logs
# Sideeffects: Might exit the script with an error
# Example    : lint_log "$git_log"
lint_log() {
  local revision="refs/remotes/origin/${BASE_REF}..HEAD" total_commits bad_commits git_log="$1" issues

  log $LINENO git log "$revision"

  if [ ! "$git_log" ]; then
    log $LINENO empty git log
    return
  fi

  log $LINENO "$git_log"

  issues=$(lint_commits "$git_log")

  if [ ! "$issues" ]; then
    msgln "conventional commits ok"
    return
  fi

  total_commits=$(wc -l <<<"$git_log")
  bad_commits=$(grep -Eie input -c <<<"$issues")

  fatal $LINENO "
commits:
$git_log

linter\ output:

$issues

Commit messages not formatted properly: $bad_commits out of $total_commits commits
$CONVENTIONAL_COMMITS_URL
To fix all, try 'git rebase -i $revision', change bad commits to 'reword', fix messages and 'git push --force'
"
}

# Description: Check if commit messages are spelled properly
# Args       : 1=git log
# STDOUT     : Ok message
# STDERR     : Might print errors and logs
# Sideeffects: Might exit the script with an error
# Example    : spellcheck_log "$git_log"
spellcheck_log() {
  # shellcheck disable=SC2155
  local log="$1" issues=$(cspell stdin <<<"$git_log")

  if [ ! "$issues" ]; then
    msgln "spellcheck commits ok"
    return
  fi

  fatal $LINENO "
commits:
$git_log

linter\ output:

$issues

To fix all, try 'git rebase -i $revision', change bad commits to 'reword', fix messages and 'git push --force'
"
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

git_log=$(git log --format=%s "$revision" --)

lint_log "$git_log"
spellcheck_log "$git_log"
