# Fzf - A command-line fuzzy finder written in Go -  https://github.com/junegunn/fzf#using-homebrew-or-linuxbrew
xsource /usr/share/doc/fzf/examples/{completion,key-bindings}.zsh
# OSX
if (( $+commands[brew] )); then
  xsource $(brew --prefix)/var/homebrew/linked/fzf/shell/{completion,key-bindings}.zsh
fi

export FZF_DEFAULT_OPTS="--height 90% --reverse --inline-info --cycle \
    --color hl:reverse,hl+:reverse \
    --exact \
    --preview-window down:3:hidden:wrap --preview 'echo {}' \
    --bind 'ctrl-a:select-all+accept,ctrl-y:execute(echo {+} | pbcopy),?:toggle-preview'"
# auto select if only 1 result, exit if no results
export FZF_CTRL_T_OPTS="--select-1 --exit-0 \
    --preview-window 'right:60%' \
    --preview '[[ \$(file --mime {}) =~ binary ]] && echo Binary: {} || (bat --style=full --color=always {} || cat {}) 2>/dev/null | head -300'"
export FZF_ALT_C_OPTS="--select-1 --exit-0"

# Prefer the following (in order) over find, if available
# - fd (https://github.com/sharkdp/fd)
# - rg (https://github.com/BurntSushi/ripgrep)
if ((${+FZF_FORCE_DEFAULT_SEARCH})); then
  # nop - i.e. use default file search, probably `find`
  # can set in ~/.zshrc.pre, which gets sourced by grml config
elif (( $+commands[fd] )); then
  # Setting fd as the default source for fzf
  FD_OPTS="--hidden --follow --exclude .git"
  export FZF_DEFAULT_COMMAND="fd --type file $FD_OPTS"
  export FZF_ALT_C_COMMAND="fd --type d $FD_OPTS"

  # Use fd for listing path candidates.
  # - The first argument to the function ($1) is the base path to start traversal
  # - See the source code (completion.{bash,zsh}) for the details.
  _fzf_compgen_path() {
    fd --hidden --follow --exclude ".git" . "$1"
  }

  # Use fd to generate the list for directory completion
  _fzf_compgen_dir() {
    fd --type d --hidden --follow --exclude ".git" . "$1"
  }
elif (( $+commands[rg] )); then
  export FZF_DEFAULT_COMMAND="rg --files --follow --hidden --no-messages"
fi
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
