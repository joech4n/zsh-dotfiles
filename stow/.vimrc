" vim:fdm=marker

" Section: Options {{{1
" ---------------------

" Fix Vundle on fish shell
if $SHELL =~ 'bin/fish' | set shell=/bin/sh | endif

" Custom undo/backup/swap directories
if !isdirectory(expand('~/.vim.private/undo/', 1))
  silent call mkdir(expand('~/.vim.private/undo', 1), 'p')
endif
if !isdirectory(expand('~/.vim.private/backup/', 1))
  silent call mkdir(expand('~/.vim.private/backup', 1), 'p')
endif
if !isdirectory(expand('~/.vim.private/swap/', 1))
  silent call mkdir(expand('~/.vim.private/swap', 1), 'p')
endif

" Turn on persistent undo per: http://github.com/mikewadsten/dotfiles/
if has('persistent_undo')
  set undodir=~/.vim.private/undo
  set undofile
  set undolevels=1000
  set undoreload=10000
endif

" Use backups per: http://stackoverflow.com/a/15317146
set backup
set writebackup
set backupdir=~/.vim.private/backup//

" Use a specified swap folder per: http://stackoverflow.com/a/15317146
set directory=~/.vim.private/swap//

" Enable colors on Solaris
if $OSTYPE =~ "solaris"
  set term=xtermc
endif

" General
set autochdir           " set working directory to file in buffer
set autoindent
set autowrite
set backspace=2         " allow backspace beyond insertion point
set backspace=indent,eol,start
set cmdheight=2         " for long file names
set display=lastline
set fileformats=unix,dos,mac
if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading\ --smart-case
  if &grepformat !~# '%c'
    set grepformat^=%f:%l:%c:%m
  endif
endif
set hlsearch            " ...as well as highlight it...
if has("eval")
  let &highlight = substitute(&highlight,'NonText','SpecialKey','g')
endif
set ic                  " ignore case
set incsearch           " ...as it is typed
set hlsearch            " highlight matches on screen
set laststatus=2        " always show status line
if (&termencoding ==# 'utf-8' || &encoding ==# 'utf-8') && version >= 700
  let &listchars = "tab:\u21e5\u00b7,trail:\u2423,extends:\u21c9,precedes:\u21c7,nbsp:\u26ad"
  let &fillchars = "vert:\u259a,fold:\u00b7"
else
  set listchars=tab:>\ ,trail:-,extends:>,precedes:<
endif
set mouse=nvi
set mousemodel=popup
set nocompatible        " disable vi compatibility
set pastetoggle=<F2>    " don't alter my pasting
set relativenumber      " relative line numbers
set report=0            " always report line changes to file
set scrolloff=1         " Always show one line below or above cursor for context
set shortmess=I         " Don't show the startup message
set showcmd             " Show commands being typed
set showmatch           " Highlight matching brace when typing second one
set sidescrolloff=5
set smartcase           " Ignore case when doing a search...
set statusline=%<%f%h%m%r%w%y%=%l/%L,%c\ %P\ \|\ %n " custom status line
"set timeoutlen=1200    " A little bit more time for macros
set ttimeoutlen=10      " Make Esc work faster
set vb t_vb=            " Turn off system beep
set wrap

" Splits
set splitbelow          " Open to bottom first
set splitright          " Open to right first

" Tabs
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" Section: GVim {{{2
" ---------------------

if has('gui_running')   " from http://ethanschoonover.com/solarized/vim-colors-solarized
  cabbrev q <C-r>=(getcmdtype()==':' && getcmdpos()==1 ? 'close' : 'q')<CR>
  set background=light
  if !has('nvim')
    set guifont=Menlo:h16
  endif
  "set clipboard=unnamed " share clipboard with OSX
  if exists('+macmeta')
    set macmeta
  endif
else
  set background=dark
endif

if !has("gui_running") && $DISPLAY == '' || !has("gui")
  set mouse=
endif

if has("dos16") || has("dos32") || has("win32") || has("win64")
  if $PATH =~? 'cygwin' && ! exists("g:no_cygwin_shell")
    set shell=bash
    set shellpipe=2>&1\|tee
    set shellslash
  endif
elseif has("mac")
endif

" Section: Custom Keybindings {{{1
" ---------------------

" downsides to <space> as leader, it is used to toggle folds by default?
let mapleader=" "

" Use space instead of : to save pinkies
"noremap <Space> :

" use :wq! instead
nnoremap ZZ <Nop>
nnoremap <C-s> :update<CR>

" avoid <Esc>
inoremap jj <Esc>`^
inoremap <C-c> <Esc>`^
" Not sure if it's a bad idea to remap <Esc>
"inoremap <Esc> <Esc>`^
noremap  <F1>   <Esc>
noremap! <F1>   <Esc>

" quick write
"inoremap zne <Esc>:update<CR>`^i
inoremap zne <Esc>:update<CR>
nnoremap zne <Esc>:update<CR>
nnoremap <Leader>fs <Esc>:update<CR>
nnoremap <Leader>bs <Esc>:update<CR>

" call actions from other modes
inoremap <M-o>      <C-o>o
inoremap <M-O>      <C-o>O
inoremap <M-h>      <Left>
inoremap <M-i>      <C-o>^
inoremap <M-a>      <C-o>$
noremap! <C-j>      <Down>
noremap! <C-k><C-k> <Up>

nnoremap Y  y$
nnoremap vv <C-V>$

nnoremap gs :%s/
xnoremap gs :s/

" expands %% to current file's directory in command-line mode
cnoremap %% <C-r>=fnameescape(expand('%:h')).'/'<CR>
cnoremap <C-o>      <Up>

" [S]plit line (sister to [J]oin lines)
" cc still substitutes the line like S would
nnoremap <Leader>S i<CR><Esc>^mwgk:silent! s/\v +$//<CR>:noh<CR>

" visually select the last paste or change
" from https://vim.fandom.com/wiki/Selecting_your_pasted_text
nnoremap <expr> gp '`[' . strpart(getregtype(), 0, 1) . '`]'

" Unhighlight the last search pattern on Enter
"nnoremap <silent><CR> :noh<return><CR>

" Format paragraph to textwidth
nnoremap <Leader>f <Esc>gq}<CR>

" Print modeline
inoremap <C-x>^ <C-r>=substitute(&commentstring,' \=%s\>'," -*- ".&ft." -*- vim:set ft=".&ft." ".(&et?"et":"noet")." sw=".&sw." sts=".&sts.':','')<CR>

if exists(":nohls")
  nnoremap <silent> <C-l> :nohls<CR><C-l>
endif

" Invert background
command! -bar Invert :let &background = (&background=="light"?"dark":"light")

" Transpose words
nnoremap <silent> gw    "_yiw:s/\(\%#\w\+\)\(\_W\+\)\(\w\+\)/\3\2\1/<CR><C-o><C-l>

"
" tabs
"
nnoremap <Leader>ti :tabnext<CR>
nnoremap <Leader>th :tabprev<CR>
nnoremap <Leader>tn :tabnew<CR>

"
" buffers
"
set hidden

" To open a new empty buffer
nnoremap <Leader>bn :enew<CR>
nnoremap <Leader>nb :enew<CR>
" Move to the next buffer
nnoremap <Leader>i :bnext<CR>
" Move to the previous buffer
nnoremap <Leader>h :bprevious<CR>
" Close the current buffer and move to the previous one. This replicates the idea of closing a tab
nnoremap <Leader>bk :bp <BAR> bd #<CR>
" delete (close) buffer
nnoremap <Leader>bdd :bd<CR>
nnoremap <Leader>b!! :bd<CR>
nnoremap <Leader>bd! :bd!<CR> " force
nnoremap Q :bdelete<CR>
nnoremap <C-q> :bd!<CR>       " force

" last active buffer
nnoremap <BS> :b#<CR>
nnoremap <C-h> :b#<CR>

" buffer switching/splitting
nnoremap <Leader>bb :Buffers<CR>
nnoremap <Leader>sh :ls<CR>:sbuffer<Space>
nnoremap <Leader>sv :ls<CR>:vertical sbuffer<Space>

"
" windows
"
nnoremap <C-n> <C-w>j
nnoremap <C-e> <C-w>k
nnoremap <Leader>wc <C-w>c

" Blank line above
nnoremap <Leader>O O<Esc>
" Blank line below
nnoremap <Leader>o o<Esc>

" Duplicate line, comment original using vim-commentary
nmap <Leader>n yyPgccj<Esc> " deliberate recursive map (nmap) to use vim-commentary

" Insert timestamps
inoremap <silent> <C-g><C-t> <C-r>=repeat(complete(col('.'),map(["%Y-%m-%d %H:%M:%S","%a, %d %b %Y %H:%M:%S %z","%Y %b %d","%d-%b-%y","%a %b %d %T %Z %Y"],'strftime(v:val)')+[localtime()]),0)<CR>

" change textwidth
nnoremap <Leader>tw :set textwidth=

" change tab settings
nnoremap <Leader>2:set shiftwidth=2<CR>:set softtabstop=2<CR>:set tabstop=2<CR>
nnoremap <Leader>4:set shiftwidth=4<CR>:set softtabstop=4<CR>:set tabstop=4<CR>
nnoremap <Leader>8:set shiftwidth=8<CR>:set softtabstop=8<CR>:set tabstop=8<CR>

" Copy paths
if has('win32')
  nmap <Leader>cs :let @*=substitute(expand("%"), "/", "\\", "g")<CR>:echom expand("%:p") "copied to clipboard"<CR>
  nmap <Leader>cl :let @*=substitute(expand("%:p"), "/", "\\", "g")<CR>:echom expand("%:p") "copied to clipboard"<CR>
  " This will copy the path in 8.3 short format, for DOS and Windows 9x
  nmap <Leader>c8 :let @*=substitute(expand("%:p:8"), "/", "\\", "g")<CR>:echom expand("%:p:8") "copied to clipboard"<CR>
elseif has('gui_running') && has('mac')
  nmap <Leader>cs :let @*=expand("%")<CR>:echom expand("%") "copied to clipboard"<CR>
  nmap <Leader>cl :let @*=expand("%:p")<CR>:echom expand("%:p") "copied to clipboard"<CR>
endif

" Other Spacemacs/Doom Emacs bindings
nnoremap <Leader>cw :StripWhitespace<CR>
nnoremap <Leader>qq :q<CR>
nnoremap <Leader>tg :call gitgutter#buffer_toggle()<CR>
" these toggle binds are copied from vim-unimpaired
nnoremap <Leader>tn :setlocal <C-R>=<SNR>45_toggle("relativenumber")<CR><CR>:setlocal <C-R>=<SNR>45_toggle("number")<CR><CR>
nnoremap <Leader>tt :setlocal <C-R>=<SNR>45_toggle("wrap")<CR><CR>
nnoremap <Leader>ww <C-w><C-w>

" Section: Custom Commands {{{1
" ---------------------


" Run this on a word, like "INIT", and you will get:
" ################################################################################
" ##################################### INIT #####################################
" ################################################################################
" per
" https://www.reddit.com/r/vim/comments/4kjgmz/weekly_vim_tips_and_tricks_thread_11/d3fdm37/
" and http://vi.stackexchange.com/a/421/307
nnoremap <Leader>## :center 80<CR>hhv0r#A<Space><Esc>40A#<Esc>d80<Bar>YppVr#kk.

" Quickly edit/reload the vimrc file
nnoremap <Leader>fp :edit $MYVIMRC<CR>
nnoremap <Leader>hR :source $MYVIMRC<CR>

" Auto load .vimrc on write
au! BufWritePost .source vimrc %

" Section: vim-plug scripts (plugins) {{{1
" ---------------------
" Install vim-plug
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if has('nvim')
  if empty(glob('~/.local/share/nvim/site/autoload/plug.vim'))
    silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
else
  if empty(glob('~/.vim/autoload/plug.vim'))
    silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
  endif
endif

if has('nvim')
  call plug#begin('~/.local/share/nvim/plugged')
else
  call plug#begin('~/.vim/plugged')
endif

" general
Plug 'alok/notational-fzf-vim', { 'on':  'NV' }
Plug 'bogado/file-line'
Plug 'elzr/vim-json'
Plug 'fcpg/vim-osc52' " copy from vim into system clipboard via terminal control char
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim' " depends on fzf_plugin_dir
"Plug 'junegunn/vim-peekaboo' " see contents of registers (incompatible with
"some version of YouCompleteMe)
Plug 'junegunn/vim-pseudocl' " required for vim-fnr
Plug 'mhinz/vim-signify' " another git gutter
Plug 'mtth/scratch.vim'
Plug 'tpope/vim-eunuch' " UNIX shell commands
Plug 'tpope/vim-fugitive' " git in VIM
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-sleuth' " autodetect and apply indent settings
Plug 'tpope/vim-unimpaired' " toggle bindings
Plug 'tpope/vim-vinegar' " improved netrw

" visuals
Plug 'morhetz/gruvbox'
Plug 'flazz/vim-colorschemes'
Plug 'itchyny/lightline.vim'
Plug 'machakann/vim-highlightedyank' " highlight yanks
Plug 'nathanaelkane/vim-indent-guides'
Plug 'ntpeters/vim-better-whitespace' " highlight trailing whitespace

" find/replace
Plug 'junegunn/vim-fnr' " depends on vim-pseudocl, find and replace without regex
Plug 'junegunn/vim-slash' " clear highlight after search, improved star search"
Plug 'markonm/traces.vim' " substitution previews
Plug 'nelstrom/vim-visual-star-search'
Plug 'tpope/vim-abolish'

" editing
Plug 'junegunn/vim-easy-align'
Plug 'terryma/vim-expand-region'
Plug 'tommcdo/vim-exchange'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-jdaddy' " json editing and pretty printing
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'vim-scripts/ReplaceWithRegister'

" obj and motions
Plug 'bkad/CamelCaseMotion'
Plug 'jeetsukumaran/vim-indentwise' " move by indentation levels
Plug 'junegunn/vim-after-object'
Plug 'justinmk/vim-sneak'
Plug 'kana/vim-textobj-line'
Plug 'kana/vim-textobj-user' " required for mattn/vim-textobj-url
Plug 'mattn/vim-textobj-url' " depends on kana/vim-textobj-user
Plug 'michaeljsmith/vim-indent-object'

" Load plugins from another file
" https://github.com/junegunn/vim-plug/issues/300#issuecomment-149173517
if !empty(glob("$HOME/.vim-plug.local"))
  source $HOME/.vim-plug.local
endif

" Initialize plugin system
call plug#end()

" End vim-plug Scripts-------------------------

" Section: Plugin configs {{{2
" ---------------------

" fzf
"
" Search and execute vim mappings
nmap <Leader><tab> <plug>(fzf-maps-n)
xmap <Leader><tab> <plug>(fzf-maps-x)
omap <Leader><tab> <plug>(fzf-maps-o)

" Insert mode completion
imap <c-x><c-k> <plug>(fzf-complete-word)
imap <c-x><c-f> <plug>(fzf-complete-path)
imap <c-x><c-j> <plug>(fzf-complete-file)
imap <c-x><c-l> <plug>(fzf-complete-line)

" Custom fzf mappings, inspired from
" https://github.com/zenbro/dotfiles/blob/d3f4bd3136aab297191c062345dfc680abb1efac/.nvimrc#L225-L233
nnoremap <silent> <Leader><Leader>  :Files<CR>
nnoremap <silent> <Leader>.         :Find<CR>
nnoremap <silent> <Leader>fr        :History<CR>
nnoremap <silent> <Leader>'         :History:<CR>  " :Command history'
nnoremap <silent> <Leader>;         :History:<CR>
nnoremap <silent> <Leader>//        :History/<CR>
nnoremap <silent> <Leader>:         :Commands<CR>
nnoremap <silent> <Leader>hf        :Commands<CR>
nnoremap <silent> <Leader>ll        :Lines<CR>
nnoremap <silent> <Leader>lb        :BLines<CR>
nnoremap <silent> <Leader>/d        :execute 'Rg ' . input('Rg/')<CR>
nnoremap <silent> <Leader>hk        :Maps<CR>

" custom rg command
command! -bang -nargs=* Find call fzf#vim#grep('rg --column --line-number --no-heading --fixed-strings --smart-case --max-columns=150 --max-columns-preview --no-ignore --hidden --follow --glob "!.git/*" --color "always" '.shellescape(<q-args>), 1, <bang>0)

"
" notational-fzf-vim
"
nnoremap <silent> <c-s> :NV<CR>
let g:nv_search_paths = ['~/Google Drive/Notational Velocity', '~/Dropbox/Notational Velocity']
let g:nv_use_short_pathnames = 1


"
" Sneak
"
let g:sneak#streak = 1
let g:sneak#s_next = 1
let g:sneak#use_ic_scs = 1
" one-character sneak
map f <Plug>Sneak_f
map F <Plug>Sneak_F
map t <Plug>Sneak_t
map T <Plug>Sneak_T

" Theme not accessible until Bundle command is run per
" https://github.com/gmarik/Vundle.vim/issues/119#issuecomment-3089931
colorscheme gruvbox

"
" vim-expand-region
"
" Extend the global default
if !has('nvim')
  call expand_region#custom_text_objects({
    \ 'a]' :1,
    \ 'ab' :1,
    \ 'aB' :1,
    \ 'ii' :0,
    \ 'ai' :0,
    \ })
endif

"
" vim-highlightedyank
"
if !exists('##TextYankPost')
  map y <Plug>(highlightedyank)
endif
let g:highlightedyank_highlight_duration = 200

"
" vim-json
"
let g:vim_json_syntax_conceal = 0

"
" vim-osc52
"
xmap <Leader>yy y:call SendViaOSC52(getreg('"'))<cr>

"
" vim-signify
"
let g:signify_vcs_list = [ 'git', 'perforce', 'hg' ]
" fix SignColumn color per
" https://github.com/mhinz/vim-signify/blob/ac23bd95d5fe0c7a7bf4a331e9d37eb72697c46e/doc/signify.txt#L602
autocmd ColorScheme *
  \ highlight SignColumn ctermbg=NONE cterm=NONE guibg=NONE gui=NONE

" Section: AutoCommands {{{1
" ---------------------

" Move help to right, resize 80
if has('autocmd')
  function! ILikeHelpToTheRight()
    if !exists('w:help_is_moved') || w:help_is_moved != "right"
      wincmd L
      vertical resize 80
      let w:help_is_moved = "right"
    endif
  endfunction

  augroup HelpPages
    autocmd FileType help nested call ILikeHelpToTheRight()
  augroup END
endif

augroup Misc
  autocmd!

  autocmd FileType netrw call s:scratch_maps()
  " from https://github.com/tpope/vim-vinegar/issues/13#issuecomment-72407746
  autocmd FileType netrw setl bufhidden=wipe
  autocmd FocusLost   * silent! wall
augroup END

" Section: Deprecated {{{1
" ---------------------

" Not sure why I have this... research later
" :nnoremap <Leader>s :let @x=@" \| let @"=@a \| let @a=@b \| let @b=@x<CR>

" Timestamps
" map ,t <Esc>o# Created: TIME<Esc>ASTAMP by foolishbrilliance<CR># Last Modified: TIME<Esc>ASTAMP by foolishbrilliance<Esc>

"
" EasyMotion
"
"let g:EasyMotion_do_mapping = 0 " Disable default mappings
"
"" Bi-directional find motion
"" Jump to anywhere you want with minimal keystrokes, with just one key binding.
"" `s{char}{label}`
"nmap s <Plug>(easymotion-s2)
"nmap t <Plug>(easymotion-t2)
"
"" `s{char}{char}{label}`
"" Need one more keystroke, but on average, it may be more comfortable.
""nmap s <Plug>(easymotion-s2)
"
"" Turn on case sensitive feature
"let g:EasyMotion_smartcase = 1
"
"" JK motions: Line motions
"map <Leader>j <Plug>(easymotion-j)
"map <Leader>k <Plug>(easymotion-k)

" command! -bar -nargs=1 -complete=file E :exe "edit ".substitute(<q-args>,'\(.*\):\(\d\+\):\=$','+\2 \1','')
" command! -bar -nargs=? -bang Scratch :silent enew<bang>|set buftype=nofile bufhidden=hide noswapfile buflisted filetype=<args> modifiable
" function! s:scratch_maps() abort
"   nnoremap <silent> <buffer> == :Scratch<CR>
"   nnoremap <silent> <buffer> =" :Scratch<Bar>put<Bar>1delete _<Bar>filetype detect<CR>
"   nnoremap <silent> <buffer> =* :Scratch<Bar>put *<Bar>1delete _<Bar>filetype detect<CR>
"   nnoremap          <buffer> =f :Scratch<Bar>setfiletype<Space>
" endfunction

" " Automatically set paste mode in Vim when pasting in insert mode per
" " https://coderwall.com/p/if9mda/automatically-set-paste-mode-in-vim-when-pasting-in-insert-mode
" let &t_SI .= "\<Esc>[?2004h"
" let &t_EI .= "\<Esc>[?2004l"
" inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()
" function! XTermPasteBegin()
"     set pastetoggle=<Esc>[201~
"     set paste
"     return ""
" endfunction

if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
