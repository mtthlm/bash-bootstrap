# shellcheck shell=bash disable=SC2059

function :printf () {
  printf -- "$1" "${@:2}"
}

function :vprintf () {
  printf -v "$1" -- "$2" "${@:3}"
}

function :printfln () {
  :printf "${1}\n" "${@:2}"
}

function :vprintfln () {
  :vprintf "$1" "${2}\n" "${@:3}"
}

function :print () {
  :printf '%s' "$@"
}

function :vprint () {
  :vprintf "$1" '%s' "${@:2}"
}

function :println () {
  :printfln '%s' "$@"
}

function :vprintln () {
  :vprintfln "$1" '%s' "${@:2}"
}

function :define () {
  IFS=$'\n' read -r -d '' "$1" || true
}

function :definef () {
  :define REPLY
  :vprintf "$1" "$2" "$REPLY"
}

function :readline () {
  IFS= read -r "$1" || [[ "${!1:+"x"}" ]]
}

function :readlinef () {
  :readline REPLY || return $?
  :vprintf "$1" "$2" "$REPLY"
}

function :replace () {
  :println "${1/"$2"/"$3"}"
}

function :replace:all () {
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
  :replace:all "$(:println "${@:2}")" $'\n' "$1"
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
