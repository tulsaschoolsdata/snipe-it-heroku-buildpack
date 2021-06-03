#!/usr/bin/env bash

export_env_dir() {
  env_dir=$1
  acceptlist_regex=${2:-''}
  denylist_regex=${3:-'^(PATH|GIT_DIR|CPATH|CPPATH|LD_PRELOAD|LIBRARY_PATH)$'}
  if [ -d "$env_dir" ]; then
    for e in $(ls $env_dir); do
      echo "$e" | grep -E "$acceptlist_regex" | grep -qvE "$denylist_regex" &&
      export "$e=$(cat $env_dir/$e)"
      :
    done
  fi
}

indent() {
  sed 's/^/    /'
}

echo_error() {
  >&2 echo "$1"
}

exit_error() {
  echo_error "Error: $2"
  exit $1
}

boolean() {
  case "$1" in
    t* | T* | '1' )
      true
    ;;
    f* | F* | '0' )
      false
    ;;
    *)
      [ -n "$1" ]
    ;;
  esac
}
