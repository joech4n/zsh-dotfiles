# Start with zprezto's zprofile.
function {
  local file="${ZDOTDIR:-$HOME}/.zprezto/runcoms/zprofile"
  [[ -s ${file} ]] && source ${file}
}

export EDITOR='vi'
export VISUAL="$EDITOR"

# (N) causes assignment not to fail if dir doesn't exist.
path=(
  $HOME/{,s}bin{,.private,.linux}(N)
  $HOME/{.dotfiles,.fzf}/bin(N)
  $HOME/.cargo/bin(N)
  $HOME/.local/bin(N)
  $path
)

# GPG: You should always add the following lines to your .bashrc or whatever initialization file is used for all shell invocations. Per https://www.gnupg.org/documentation/manuals/gnupg/Invoking-GPG_002dAGENT.html
export GPG_TTY=$(tty)

export RIPGREP_CONFIG_PATH=$HOME/.ripgreprc

[[ -r ~/.zprofile.local ]] && source ~/.zprofile.local
