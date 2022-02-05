# shellcheck shell=bash disable=SC2059

function :define () {
  IFS=$'\n' read -r -d '' "$@" || true
}

function :readline () {
  IFS= read -r "$@"
}

function :printf () {
  printf -- "$1" "${@:2}"
}

function :vprintf () {
  printf -v "$1" -- "$2" "${@:3}"
}

function :print () {
  :printf '%s' "$@"
}

function :println () {
  :printf '%s\n' "$@"
}

function :sub () {
  :println "${1/"$2"/"$3"}"
}

function :gsub () {
  :println "${1//"$2"/"$3"}"
}

function :split () {
  local separator="$1" string="$2"
  local -i limit="${3:-"0"}"

  local -a pieces=("$string")

  if [[ "${separator:+"x"}" ]]
  then
    while [[ ! $limit -gt 0 || ${#pieces[@]} -lt $limit ]] && [[ "${pieces[-1]}" == *"$separator"* ]]
    do
      local new="${pieces[-1]#*"$separator"}"

      pieces[-1]="${pieces[-1]%%"$separator"*}"

      pieces+=("$new")
    done
  else
    if ! [[ $limit -le ${#string} && $limit -gt 0 ]]
    then limit=${#string}
    fi

    while [[ ! $limit -gt 0 || ${#pieces[@]} -lt $limit ]]
    do
      local new="${pieces[-1]:1}"

      pieces[-1]="${pieces[-1]:0:1}"

      pieces+=("$new")
    done
  fi

  :println "${pieces[@]}"
}

function :join () {
  :gsub "$(:println "${@:2}")" $'\n' "$1"
}

function :in () {
  local needle="$1"
  shift

  while [[ $# -gt 0 ]]
  do
    if [[ "$1" == "$needle" ]]
    then return 0
    fi
    shift
  done

  return 1
}

function :log () {
  :println "$@" 1>&2
}

function :die () {
  :log "$@"
  exit 1
}
