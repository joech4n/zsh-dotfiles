function {
  local file="${ZDOTDIR:-$HOME}/.zprezto/runcoms/zlogout"
  [[ -s ${file} ]] && source ${file}
}
