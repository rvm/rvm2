#!/usr/bin/env bash

rvm2_version_sort()
{
  \command \awk -F'[.-]' -v OFS=. '{                   # split on "." and "-", merge back with "."
    original=$0                                        # save original to preserve it before the line is changed
    for (n=1; n<10; n++) {                             # iterate through max 9 components of version
      $n=tolower($n)                                   # ignore case for sorting
      if ($n == "")                 $n="0"             # treat non existing parts as 0
      if ($n ~ /^p[0-9]/)           $n=substr($n, 2)   # old ruby -p notation
      if ($n ~ /^[0-9](rc|b)/)      $n=substr($n, 1, 1)". "substr($n, 2)   # old jruby 0RC1 notation
      if (n == 1 && $n ~ /^[0-9]/)  $n="zzz."$n        # first group must be a string
      if (n > 1 && $n ~ /^[a-z]/)   $n=" "$n           # names go before numbers thanks to space
    }
    print $0"\t"original                               # print the transformed version and original separated by \t
                                                       # so we can extract original after sorting
  }'  \
  | LC_ALL=C \sort -t. -k 1,1d -k 2,2n -k 3,3n -k 4,4n -k 5,5n -k 6,6n -k 7,7n -k 8,8n -k 9,9n \
  | \awk -F'\t' '{print $2}'
}

function rvm2-use()
{
  [[ -n "${1:-}" ]] || {
    echo "RVM2 Specify a ruby to use." >&2
    return 1
  }

  typeset \rvm2_ruby
  rvm2_ruby="$(\command \ls -1  ~/.rvm/environments/ | rvm2_version_sort | \command \grep "$1" 2>/dev/null | head -n 1 )"
  [[ -n "$rvm2_ruby" ]] || {
    echo "RVM2 Can not find ruby '$1'." >&2
    return 2
  }

  source ~/.rvm/environments/"$rvm2_ruby"
}
