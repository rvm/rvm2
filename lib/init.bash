#!/usr/bin/env bash

function is_valid_rvm2_path() [[
  -n "${1:-}" && -d "$1" && -d "$1/lib" &&
  -f "$1/lib/init.bash" && -s "$1/lib/init.bash" && -r "$1/lib/init.bash"
]]

function find_rvm2_path()
{
  \typeset __rvm_path
  for __rvm_path in "${BASH_SOURCE%/lib/init.bash}" "/usr/local/rvm" "${HOME}/.rvm"
  do
    if
      is_valid_rvm2_path "$__rvm_path"
    then
      export RVM2_PATH="$__rvm_path"
      return 0
    fi
  done
  return 1
}

function rvm2_load()
{
  \typeset __rvm2_file
  for __rvm2_file in "${RVM2_PATH:-}"/lib/"$1"/*.bash
  do
    if [[ -f "$__rvm2_file" && -s "$__rvm2_file" ]]
    then source "$__rvm2_file"
    fi
  done
}

is_valid_rvm2_path "${RVM2_PATH:-}" || find_rvm2_path || {
  echo "RVM2 Can not find installation path, try setting 'RVM2_PATH' and try again" >&2
}

rvm2_load commands
