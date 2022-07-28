function {
  local file="${ZDOTDIR:-$HOME}/.zprezto/runcoms/zlogin"
  [[ -s ${file} ]] && source ${file}
}
