#! /usr/bin/env bash
# Copyright 2024 Raphael Thomazella. All rights reserved.
# Use of this source code is governed by the BSD-3-Clause
# license that can be found in the LICENSE file and online
# at https://opensource.org/license/BSD-3-clause.
#
# wrapper around changelog tool.
# Args: 1=url 2=title 3=prefix

set -euo pipefail
shopt -s globstar nullglob
trap 'err $LINENO' ERR

##########################
### vars and functions ###
##########################

# Description: Validates user input
# Globals    : CHANGELOG_FILE (github workflow)
# Returns    : 1 if fail
# Example    : validate
validate() {
  if [ ! "${CHANGELOG_FILE-}" ]; then
    err $LINENO "missing CHANGELOG_FILE env variable"
    return 1
  fi

  if [ ! -f "$CHANGELOG_FILE" ]; then
    err $LINENO "$CHANGELOG_FILE" not found
    return 1
  fi
}

# Description: Calls changelog tool and updates CHANGELOG_FILE
# Globals    : CHANGELOG_FILE, TAGS_FILE (github workflow)
# Args       : 1=url 2=title 3=prefixes
# STDERR     : Might print errors
# Returns    : 1 if fail
# Sideeffects: Updates CHANGELOG_FILE
# Example    : update_changelog pizza
update_changelog() {
  local url=$1 title=${2:-} prefixes=${3:-} changes changelog flags=()

  changelog=$(cat "$CHANGELOG_FILE")
  flags+=(-title "$title")
  flags+=(-tagprefixes "$prefixes")
  flags+=(-url "$url")
  flags+=(-tagsfile "${TAGS_FILE:-}")

  changes=$(t0changelog "${flags[@]}")
  if [ ! "$changes" ]; then
    err $LINENO "empty changes"
    return 1
  fi

  printf %s "$changes" >"$CHANGELOG_FILE"
  printf "\n\n" >>"$CHANGELOG_FILE"
  printf %s "$changelog" >>"$CHANGELOG_FILE"
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
update_changelog "$@"
