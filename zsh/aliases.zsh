# zsh aliases

# fasd
fasd_cache="$HOME/.fasd-init-zsh"
if [ "$(command -v fasd)" -nt "$fasd_cache" -o ! -s "$fasd_cache" ]; then
  fasd --init auto >| "$fasd_cache"
fi
source "$fasd_cache"
unset fasd_cache

# fasd & fzf change directory - jump using to frecent dirs (from `fasd`) if
# given argument, else filter frecent dirs using `fzf`
# unalias first, because fasd sets this by default
unalias z; alias z='fasd_fzf_cd_smart'

# like z, but requires arg to filter initial frecent directories to present
unalias zz; alias zz='fasd_fzf_cd_filtered'

# utility fasd functions similar to fasd's f, usually used to pipe into other
# commands
alias fz='fasd_fzf_dir'
alias ff='fasd_fzf_file'

alias e='fasd_fzf_edit_smart' # quick edit
alias ee='fasd_fzf_edit_filtered'
alias ef='fzf_edit_open_from_cwd'
alias fre='fasd_fzf_edit'
alias f.e='fzf_edit_open_from_cwd'
isdarwin && alias o='a -e open' # quick opening files in OSX
alias fv='fzf_view'

# cd. - fuzzy cd into subdirectory (non-recursive) within current directory
alias cd.='cd $(find . -maxdepth 1 -type d |fzf)'
alias fcd='fzf_cd'
alias fcda='fzf_cd_all'
alias fcdf='fzf_cd_file'
alias fcdp='fzf_cd_parent'

alias envf='env |fzf'
alias cmdf='echo ${(k)commands} ${(k)aliases} ${(k)functions} |tr " " "\n" |fzf'
alias whichf='which $(cmdf)'

alias ..='cd ..'
alias ...='cd ../../'
alias ....='cd ../../../'
alias .....='cd ../../../../'
alias ......='cd ../../../../../'

alias ax="chmod a+x"
alias bail='tail -f $@ |bat --paging=never -l log'
alias calc='bc <<<'
isdarwin && alias clitxt='curl -sF "upfile=@-" https://clitxt.com |tee /dev/tty | pbcopy'
alias ch='fzf_chrome_history'
alias copylastoutput="fc -e -|pbcopy && echo Copied output of last command to clipboard"
alias count='sort | uniq -c | sort -rn'
alias cpath='python -c "import os; import sys; print(os.path.realpath(sys.argv[1]))"'

edownload() {
    if [ $# -ne 2 ];
    then
        echo -e "Wrong arguments specified. Usage example:\nedownload https://transfer.sh/nPIxk/test.txt /tmp/test"
        return 1
    fi
    curl $1| gpg -dio- > $2
}
alias e2u=epoch2utc
alias eme='emacsclient -n'  # open in (e)xisting frame
alias emn='emacsclient -cq' # open in (n)ew frame
alias epoch='date +%s'

epoch2utc() { perl -e "print scalar(localtime($1)) . ' UTC'" } # Usage: epoch2utc 1395249613

etransfer() {
  cat $1|gpg -ac -o-|curl --progress-bar -X PUT --upload-file "-" https://transfer.sh/test.txt |tee
}

# fuzzy find clipboard Alfred history (sort by timestamp in sqlite, then don't sort in fzf)
isdarwin && alias fclip='sqlite3 -header -csv ~/Library/Application\ Support/Alfred\ 3/Databases/clipboard.alfdb "select item from clipboard order by ts desc" |fzf |pbcopy'

# https://brettterpstra.com/2019/08/29/shell-tricks-a-random-selection/#faster-command-history-substitutions
fix() {
	local cmd=$(fc -ln -1|sed -e 's/^ +//'|sed -e "s/$1/$2/")
    local choice
    read -q "choice?Run \`$cmd\`? (Y/n)"
    echo
    if [[ "$choice" != "Y" ]]; then
      echo "aborting"
      return
    fi
	eval $cmd
}


# Git aliases from zprezto: https://github.com/sorin-ionescu/prezto/blob/master/modules/git/alias.zsh

# Log
zstyle -s ':prezto:module:git:log:medium' format '_git_log_medium_format' \
  || _git_log_medium_format='%C(bold)Commit:%C(reset) %C(green)%H%C(red)%d%n%C(bold)Author:%C(reset) %C(cyan)%an <%ae>%n%C(bold)Date:%C(reset)   %C(blue)%ai (%ar)%C(reset)%n%+B'
zstyle -s ':prezto:module:git:log:oneline' format '_git_log_oneline_format' \
  || _git_log_oneline_format='%C(green)%h%C(reset) %s%C(red)%d%C(reset)%n'
zstyle -s ':prezto:module:git:log:brief' format '_git_log_brief_format' \
  || _git_log_brief_format='%C(green)%h%C(reset) %s%n%C(blue)(%ar by %an)%C(red)%d%C(reset)%n'
# Commit (c)
alias gcm='git commit --message'
# Index (i)
alias gia='git add'
alias gid='git diff --no-ext-diff --cached'
alias giD='git diff --no-ext-diff --cached --word-diff'
# Log (l)
alias gl='git log --topo-order --pretty=format:"${_git_log_medium_format}"'
alias gls='git log --topo-order --stat --pretty=format:"${_git_log_medium_format}"'
alias gld='git log --topo-order --stat --patch --full-diff --pretty=format:"${_git_log_medium_format}"'
alias glo='git log --topo-order --pretty=format:"${_git_log_oneline_format}"'
alias glg='git log --topo-order --all --graph --pretty=format:"${_git_log_oneline_format}"'
alias glb='git log --topo-order --pretty=format:"${_git_log_brief_format}"'
alias glc='git shortlog --summary --numbered'
# Working Copy (w)
alias gwd='git diff --no-ext-diff'
alias gwD='git diff --no-ext-diff --word-diff'
alias gws='git status --short'
alias gwS='git status'

# From https://gist.github.com/vlymar/4e43dbeae70ff71f861d
# fuzzy multi-select modified file
gfmod() {
  git ls-files $(git rev-parse --show-toplevel) -m | fzf -m
}
# stage files multi-selected modified files
gfadd() {
  git add $(gfmod)
}

gfdiff() {
  git diff $(gfmod)
}

# fshow (originally) - git commit browser
gfshow() {
  git log --graph --color=always \
      --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
  fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
      --bind "ctrl-m:execute:
                (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

alias glog="git log --graph --pretty=format:'%Cred%h%Creset %an: %s - %Creset %C(yellow)%d%Creset %Cgreen(%cr)%Creset' --abbrev-commit --date=relative"
alias github="open \`git remote -v | grep github.com | grep fetch | head -1 | field 2 | sed 's/git:/http:/g'\`"
alias js='jekyll serve --limit_posts 10 -w'
alias krbcurl='curl --negotiate -u :'
listcert() { openssl s_client -showcerts -connect $1:443 </dev/null 2>/dev/null | openssl x509 -inform PEM -text } # Usage: listcert google.com
alias lscert=listcert
alias les=bat
alias mt='truecrypt ~/Dropbox/random.things /media/truecrypt1'
alias msgviewer='java -jar ~/Dropbox/Thumbdrive/PortableApps/MSGViewer-1.9/MSGViewer.jar'
alias myip='curl -s checkip.amazonaws.com'
# Pipe my public key to my clipboard.
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy | echo '=> Public key copied to pasteboard.'"
isdarwin && alias ql='qlmanage -p "$@" >& /dev/null'
alias reload!='. ~/.zshrc && echo reloaded .zshrc'
alias rge=ripgrep_fzf_edit_vim
alias rs='screen -RD'
alias sl='ls'
isdarwin && alias ss="open /System/Library/Frameworks/ScreenSaver.framework/Versions/A/Resources/ScreenSaverEngine.app" # Start ScreenSaver. This will lock the screen if locking is enabled.

# sum numbers
alias sum-numbers="awk '{ sum += \$1 } END { print sum }'"

transfer() { # transfer.sh function from https://gist.github.com/nl5887/a511f172d3fb3cd0e42d#gistcomment-2093683
    # check arguments
    if [ $# -ne 1 ];
    then
        echo -e "Wrong arguments specified. Usage:\ntransfer /tmp/test.md\ncat /tmp/test.md | transfer test.md"
        return 1
    fi

    # get temporary filename, output is written to this file so show progress can be showed
    tmpfile="$( mktemp -t transferXXX )"

    # upload stdin or file
    file="$1"

    if tty -s;
    then
        basefile="$( basename "$file" | sed -e 's/[^a-zA-Z0-9._-]/-/g' )"

        if [ ! -e $file ];
        then
            echo "File $file doesn't exists."
            return 1
        fi

        if [ -d $file ];
        then
            # zip directory and transfer
            zipfile="$( mktemp -t transferXXX.zip )"
            cd "$(dirname "$file")" && zip -r -q - "$(basename "$file")" >> "$zipfile"
            curl --progress-bar --upload-file "$zipfile" "https://transfer.sh/$basefile.zip" >> "$tmpfile"
            rm -f $zipfile
        else
            # transfer file
            curl --progress-bar --upload-file "$file" "https://transfer.sh/$basefile" >> "$tmpfile"
        fi
    else
        # transfer pipe
        curl --progress-bar --upload-file "-" "https://transfer.sh/$file" >> "$tmpfile"
    fi

    # cat output link
    cat "$tmpfile"
    echo

    # cleanup
    rm -f "$tmpfile"
}

# tm - create new tmux session, or switch to existing one. Works from within tmux too. (@bag-man)
# `tm` will allow you to select your tmux session via fzf.
# `tm irc` will attach to the irc session (if it exists), else it will create it.
tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf --exit-0) &&  tmux $change -t "$session" || echo "No sessions found."
}

alias tpaste='tmux save-buffer -'
isdarwin && alias trimw="pbpaste |sed -e 's/[[[:space:]]\r\n]//g' |pbcopy" # Trim all whitespace
alias tpcalc='perl -ne "push @t,1*\$1 if(/(\d+)/); END{@t=sort{\$a<=>\$b}@t; map{printf qq(TP%.1f %d\n),100*\$_,@t[int(scalar(@t))*\$_]}(.5,.9,.99,.999) }"'
alias ud='cd ~/dotfiles && git pull; cd -'
alias updoom='cd ~/.emacs.d && git pull && ~/.emacs.d/bin/doom -y upgrade && ~/.emacs.d/bin/doom -y a; cd -'
# cd up the directory tree to a directory
upto() {
    [ -z "$1" ] && return
    local upto=$1
    cd "${PWD/\/$upto\/*//$upto}"
}

alias utc='date -u'

alias vless='vim -Ru ~/.dotfiles/vim/vimrc.basic.symlink -'
alias vi='vim'
if check_com -c vimr ; then
  vimr () { # from https://github.com/grml/grml-etc-core/blob/master/etc/zsh/zshrc#L3130
    VIM_PLEASE_SET_TITLE='yes' command vimr ${VIM_OPTIONS} "$@"
  }
fi
alias worddiff='git diff --word-diff=color'
