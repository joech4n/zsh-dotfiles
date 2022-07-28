function {
  local file="${ZDOTDIR:-$HOME}/.zprezto/runcoms/zshenv"
  [[ -s ${file} ]] && source ${file}
}
