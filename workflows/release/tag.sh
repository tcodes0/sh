#! /usr/bin/env bash
# Copyright 2024 Raphael Thomazella. All rights reserved.
# Use of this source code is governed by the BSD-3-Clause
# license that can be found in the LICENSE file and online
# at https://opensource.org/license/BSD-3-clause.
#
# parses changelog and pushes tags the newest release

set -euo pipefail
shopt -s globstar
trap 'err $LINENO' ERR

##########################
### vars and functions ###
##########################

# Description: Exit the script if main head is doesn't match a release commit
# Globals    : CHANGELOG_FILE, TAGS_FILE, DRY_RUN (github workflow)
# STDERR     : Logs
# Sideeffects: Might exit the script with success or failure
# Example    : validate
validate() {
  local main_head release_re="^chore:[[:blank:]]+release"

  if [ "${DRY_RUN:-}" == "true" ]; then
    DRY_RUN="echo"
  else
    DRY_RUN=""
  fi

  if [ ! "${CHANGELOG_FILE:-}" ]; then
    fatal $LINENO "missing CHANGELOG_FILE env variable"
  fi

  if [ ! "${TAGS_FILE:-}" ]; then
    fatal $LINENO "missing TAGS_FILE env variable"
  fi

  while read -r commit_line; do
    main_head="$commit_line"
    # meant to only run once
    # fix for SIGPIPE errors arrising from piping git log into head -1
    break
    # format: just commit body
  done < <(git log --pretty=format:%B)

  if ! [[ $main_head =~ $release_re ]]; then
    log $LINENO "main head not a release commit: $main_head"
    exit 0
  fi
}

# Description: Parses tags from TAGS_FILE
# Globals    : TAGS_FILE (github workflow)
# STDOUT     : Parsed tags
# Returns    : Parsed tags
# Example    : tags="$(parse_tags)"
parse_tags() {
  local tags=() line

  while read -r line; do
    if [[ "$line" =~ ^# ]]; then
      # skip doc lines
      continue
    fi

    tags+=("$line")
  done <"$TAGS_FILE"

  printf %s "${tags[*]}"
}

# Description: Validates input as git tags
# Args       : Words separated by spaces
# STDOUT     : Help message
# STDERR     : Might log errors
# Sideeffects: Might exit with 1
# Example    : validate_tags foo/v1.1.1. bar/v1.2.3
validate_tags() {
  local tags=("$@")

  if [ ${#tags[@]} == 0 ]; then
    fatal $LINENO "no tags found"
  fi

  for tag in "${tags[@]}"; do
    if git rev-parse --verify "$tag" >/dev/null 2>&1; then
      fatal $LINENO "tag already exists: $tag"
    fi
  done
}

# Description: Creates and pushes git tags
# Globals    : DRY_RUN (github workflow)
# Args       : words separated by spaces
# STDOUT     : Prints each tag created, plus git output
# STDERR     : Git might output
# Sideeffects: Pushes git tags
# Example    : tag_and_push v1.1.1. foo/v1.2.3
tag_and_push() {
  for tag in "$@"; do
    msgln "$tag"
    $DRY_RUN git tag "$tag" HEAD
  done

  $DRY_RUN git push origin --tags
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

parsed_tags="$(parse_tags)"
# shellcheck disable=SC2068 # intentional splitting
validate_tags ${parsed_tags[@]}
# shellcheck disable=SC2068 # intentional splitting
tag_and_push ${parsed_tags[@]}
