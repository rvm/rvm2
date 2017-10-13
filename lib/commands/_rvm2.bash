#!/usr/bin/env bash

# @param $1 subcommand name to check
# @param $2 variable to save the command to execute
# return 0 on success, 1 on failure
function is_rvm2_subcommand()
{
  [[ -n "${1:-}" ]] && eval "[[ -z \"\${${2}:-}\" ]]" || return 1

  if \type "rvm2-${1:-}" >/dev/null 2>&1
  then eval "$2=\"rvm2-$1\""

  elif [[ -x "$RVM2_PATH/bin/rvm2-${1:-}" ]]
  then eval "$2=\"$RVM2_PATH/bin/rvm2-$1\""

  else return 1
  fi
}

function rvm2()
{
  is_valid_rvm2_path "${RVM2_PATH:-}" || {
    echo "RVM2 Can not find installation path, try setting 'RVM2_PATH' and try again" >&2
    return 1
  }

  \typeset __rvm2_command
  __rvm2_command=""
  \typeset -a __rvm2_flags
  __rvm2_flags=()

  while (( $# ))
  do
    is_rvm2_subcommand "${1:-}" "__rvm2_command" || __rvm2_flags+=( "$1" )
    shift
  done

  if
    [[ -n "${__rvm2_command:-}" ]]
  then
    "${__rvm2_command:-}" "${__rvm2_flags[@]}" || return $?
  else
    echo "RVM2 can not find command for '${__rvm2_flags[*]}'." >&2
    return 1
  fi
  return 0
}
