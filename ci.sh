#! /usr/bin/env bash
# Copyright 2024 Raphael Thomazella. All rights reserved.
# Use of this source code is governed by the BSD-3-Clause
# license that can be found in the LICENSE file and online
# at https://opensource.org/license/BSD-3-clause.

set -euo pipefail
shopt -s globstar
# shellcheck source=lib.sh
source "$PWD/sh/lib.sh"

### vars and functions ###

start=$(date +%s)
failedJobs=()
passingJobs=()
ciPid=""

usageExit() {
  msgln "Usage: $0 (run main, module_pr and release workflows on pull_request)"
  msgln "Usage: $0 push (same as above, but on push)"
  msgln "Usage: $0 dispatch pizza (run release-pr with inputs module=pizza)"
  exit 1
}

pushJob() {
  local type="$1" job="$2"

  if [ "$type" == "fail" ]; then
    if [[ "${failedJobs[*]}" != *${job}* ]]; then
      failedJobs+=("$job")
    fi
  elif [[ "${passingJobs[*]}" != *${job}* ]]; then
    passingJobs+=("$job")
  fi
}

# $1 logfile
printJobProgress() {
  local success="succeeded" failed="failed" ciLog="$1"
  local regExpJobStatus="\[([^]]+)\].*(succeeded|failed)"

  while read -r line; do
    if [[ ! "$line" =~ $regExpJobStatus ]]; then
      continue
    fi

    local job="${BASH_REMATCH[1]}" status="${BASH_REMATCH[2]}"

    if [ "$status" == "$success" ]; then
      printf "%b %b%s%b\n" "$LIB_COLOR_PASS" "$LIB_FORMAT_DIM" "$job" "$LIB_VISUAL_END"
      pushJob pass "$job"
    else
      printf "%b %b\n" "$LIB_COLOR_FAIL" "$job"
      pushJob fail "$job"
    fi
  done < <(grep -Eie "Job ($success|$failed)" "$ciLog" || true)

  printf %ss\\n $(($(date +%s) - start))
}

# script args
validate() {
  if [ "$(git status -s)" ]; then
    fatal $LINENO "please commit or stash all changes"
  fi

  if ! ping -c 1 1.1.1.1 >/dev/null; then
    fatal $LINENO "please check your internet connection"
  fi
}

prepareLogs() {
  local gitLocalBranch prJson eventJson pushJson releasePrJson
  local event="${1-}" module="${2-}" eventJsonFile ciLog eventType

  gitLocalBranch=$(git branch --show-current)
  prJson="
{
  \"pull_request\": {
    \"title\": \"feat(ci): add PR title to act event\",
    \"head\": {
      \"ref\": \"$gitLocalBranch\"
    },
    \"base\": {
      \"ref\": \"main\"
    }
  },
  \"local\": true
}
"
  pushJson="
{
  \"push\": {
    \"base_ref\": \"refs/heads/main\"
  },
  \"local\": true
}
"
  releasePrJson="
{
  \"inputs\": {
    \"module\": \"$module\"
  },
  \"local\": true
}
"

  case "$event" in
  "push")
    eventJson="$pushJson"
    eventType=push
    ;;
  "dispatch")
    eventJson="$releasePrJson"
    eventType=workflow_dispatch
    ;;
  *)
    eventJson="$prJson"
    eventType=pull_request
    ;;
  esac

  eventJsonFile=$(mktemp /tmp/ci-event-json-XXXXXX)
  ciLog=$(mktemp /tmp/ci-log-json-XXXXXX)

  printf "event json:" >"$ciLog"
  printf %s "$eventJson" >>"$ciLog"
  printf %s "$eventJson" >"$eventJsonFile"
  printf "%s %s %s" "$eventType" "$ciLog" "$eventJsonFile"
}

# $1 logfile
postCi() {
  local failed="" log="$1" minDurationSeconds=5
  msgln

  if [ $(($(date +%s) - start)) -le $minDurationSeconds ]; then
    tail "$log"
    failed=true
  elif [ "${#failedJobs[@]}" != 0 ]; then
    msgln ${#failedJobs[@]} jobs failed \(${#passingJobs[@]} OK\)
    msgln see logs:

    for job in "${failedJobs[@]}"; do
      msgln grep --color=always -Ee \""$job"\" "$log" \| less
    done

    failed=true
  elif [ ${#passingJobs[@]} == 0 ]; then
    grep --color=always -Eie "error" "$log" || true
    msgln "error: no jobs succeeded"
    failed=true
    # look for errors at the end of log, fail if found
  elif tail "$log" | grep --color=always -Eie error; then
    failed=true
  fi

  msgln
  msgln full logs:\\t"$log"

  if [ "$failed" ]; then
    printf "%b" "$LIB_COLOR_FAIL"
  fi
}

### script ###

if requestedHelp "$*"; then
  usageExit
fi

validate "$@"
read -rs type logFile eventJsonFile <<<"$(prepareLogs "$@")"

ciCommand="act"
ciCommandArgs=("$type")
ciCommandArgs+=(-e "$eventJsonFile")
ciCommandArgs+=(-s GITHUB_TOKEN="$(gh auth token)")
ciCommandArgs+=(--container-architecture linux/amd64)

$ciCommand "${ciCommandArgs[@]}" >>"$logFile" 2>&1 || true &
ciPid=$!

printf "\e[H\e[2J" # move 1-1, clear whole screen
msgln "    running ci..."

while ps -p "$ciPid" >/dev/null; do
  printf "\e[H" # move 1-1
  printJobProgress "$logFile"
  sleep 1
done

# catch status of last job that could have been missed by loop
printf "\e[H" # move 1-1
printJobProgress "$logFile"
postCi "$logFile"
