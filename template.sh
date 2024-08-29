#! /usr/bin/env bash
# Copyright 2024 Raphael Thomazella. All rights reserved.
# Use of this source code is governed by the BSD-3-Clause
# license that can be found in the LICENSE file and online
# at https://opensource.org/license/BSD-3-clause.
#
# template for bash scripts

set -euo pipefail
shopt -s globstar
source "$PWD/lib.sh"
trap 'err $LINENO' ERR

##########################
### vars and functions ###
##########################

# Description: Print script usage
# Globals    :
# Args       :
# STDOUT     : Help message
# STDERR     :
# Returns    :
# Sideeffects:
# Example    : usage
usage() {
  command cat <<-EOF
Usage:
Template

$0 template
EOF
}

# Description: Validates user input
# Globals    :
# Args       : $@
# STDOUT     :
# STDERR     : Might print errors
# Returns    :
# Sideeffects:
# Example    : validate_input "$@"
validate_input() {
  true
}

##############
### script ###
##############

if requested_help "$*"; then
  usage
  exit 1
fi

validate_input "$@"
