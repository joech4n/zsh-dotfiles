# -*- mode: sh; -*-
# vim: filetype=zsh
# For interactive shells

# Fix Emacs TRAMP per https://www.emacswiki.org/emacs/TrampMode#toc7
[ $TERM = "dumb" ] && unsetopt zle && PS1='$ ' && return

################################################################################
# Utility functions
################################################################################
autoload -Uz is-at-least

# copied from https://github.com/grml/grml-etc-core/blob/ffe57c8786bf71c015d948eff4253089725b9f8e/etc/zsh/zshrc#L458
# this function checks if a command exists and returns either true
# or false. This avoids using 'which' and 'whence', which will
# avoid problems with aliases for which on certain weird systems. :-)
# Usage: check_com [-c|-g] word
#   -c  only checks for external commands
#   -g  does the usual tests and also checks for global aliases
function check_com () {
    emulate -L zsh
    local -i comonly gatoo
    comonly=0
    gatoo=0

    if [[ $1 == '-c' ]] ; then
        comonly=1
        shift 1
    elif [[ $1 == '-g' ]] ; then
        gatoo=1
        shift 1
    fi

    if (( ${#argv} != 1 )) ; then
        printf 'usage: check_com [-c|-g] <command>\n' >&2
        return 1
    fi

    if (( comonly > 0 )) ; then
        (( ${+commands[$1]}  )) && return 0
        return 1
    fi

    if     (( ${+commands[$1]}    )) \
        || (( ${+functions[$1]}   )) \
        || (( ${+aliases[$1]}     )) \
        || (( ${+reswords[(r)$1]} )) ; then
        return 0
    fi

    if (( gatoo > 0 )) && (( ${+galiases[$1]} )) ; then
        return 0
    fi

    return 1
}

function isdarwin () {
  [[ "$OSTYPE" == darwin* ]]
}

# Check if we can read given files and source those we can.
# copied from https://github.com/grml/grml-etc-core/blob/ffe57c8786bf71c015d948eff4253089725b9f8e/etc/zsh/zshrc#L539
function xsource () {
    if (( ${#argv} < 1 )) ; then
        printf 'usage: xsource FILE(s)...\n' >&2
        return 1
    fi

    while (( ${#argv} > 0 )) ; do
        [[ -r "$1" ]] && source "$1"
        shift
    done
    return 0
}

xsource ${HOME}/.zshrc.pre # source this early, from old grml config
source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" # load zprezto

################################################################################
############################# zgen plugin manager ##############################
################################################################################
# Install zgen, if neccessary
[ -d $HOME/.zgen ] || git clone https://github.com/tarjoilija/zgen.git "${HOME}/.zgen"

# These files will be checked and if a change is detected zgen reset is called.
ZGEN_RESET_ON_CHANGE=(${HOME}/.zshrc)

(( ${+aliases[up]} )) && unalias up # grml alias conflicts with up.zsh plugin
xsource "${HOME}/.zgen/zgen.zsh" # load zgen

# if the init scipt doesn't exist
if ! zgen saved; then
  zgen load djui/alias-tips
  # disable fast-syntax-highlighting until I figure out the `man` delay issue https://www.reddit.com/r/zsh/comments/fkcjfq/catalina_users_out_there_4_second_pause_whenever/fks88gj/
  #zgen load zdharma/fast-syntax-highlighting
  zgen load peterhurford/up.zsh
  zgen load unixorn/warhol.plugin.zsh
  zgen save
fi

################################################################################
# My custom config
################################################################################
HISTSIZE=100000 # The maximum number of events to save in the internal history.
SAVEHIST=100000 # The maximum number of events to save in the history file.

# To allow for ^s to fwd-i-search (opposite of ^r), disable XON/XOFF for interactive shells per https://stackoverflow.com/questions/791765/unable-to-forward-search-bash-history-similarly-as-with-ctrl-r#comment39602061_791800
# [[ $- == *i* ]] && stty -ixon # [[ is not POSIX
case "$-" in; *i*) stty -ixon;; esac # POSIX

################################################################################
## Apps
################################################################################

if (( $+commands[bat] )); then
  batdiff() {
    git diff --name-only --diff-filter=d | xargs bat --diff
  }
  alias cat='bat --paging=never'
  export MANPAGER="sh -c 'col -bx | bat -l man -p'"
fi

# Brew
if (( $+commands[brew] )); then
  # For Cask per https://github.com/caskroom/homebrew-cask/blob/master/USAGE.md
  # --appdir=/my/path changes the path where the symlinks to the applications (above) will be generated. This is commonly used to create the links in the root Applications directory instead of the home Applications directory by specifying --appdir=/Applications. Default is ~/Applications.
  export HOMEBREW_CASK_OPTS="--appdir=/Applications"
fi

# chruby (Intel Mac)
xsource /usr/local/share/chruby/chruby.sh \
  /usr/local/share/chruby/auto.sh
# chruby (M1 Mac)
xsource /opt/homebrew/share/chruby/chruby.sh \
  /usr/local/share/chruby/auto.sh

# diff-so-fancy
if (( $+commands[diff-so-fancy] )); then
  dfs() {
    git diff --color --no-index $1 $2 | diff-so-fancy
  }
fi

# GNU ls colors
if [ -e ~/.dir_colors ]; then
  (( $+commands[dircolors] )) && eval $(dircolors -b ~/.dir_colors)
fi

# For gtags per https://github.com/syl20bnr/spacemacs/tree/master/layers/%2Btags/gtags#install-on-osx-using-homebrew
(( $+commands[pygments] )) && export GTAGSLABEL=pygments

# nvim
(( $+commands[nvim] )) && export NVIM_TUI_ENABLE_TRUE_COLOR=1

xsource ${HOME}/.dotfiles/zsh/aliases.zsh
xsource ${HOME}/.fzf.zsh
xsource ${HOME}/.zshrc.local
xsource ${HOME}/.zshrc.secret # last, for secrets

# Added by Jetski
export PATH="$HOME/.jetski/jetski/bin:$PATH"

# Visual Studio Code shell integration per https://code.visualstudio.com/docs/terminal/shell-integration
[[ "$TERM_PROGRAM" == "vscode" ]] && . "$(code --locate-shell-integration-path zsh)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/chanjoe/.lmstudio/bin"
# End of LM Studio CLI section

