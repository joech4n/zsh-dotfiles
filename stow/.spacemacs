;; -*- mode: emacs-lisp -*-
;; This file is loaded by Spacemacs at startup.
;; It must be stored in your home directory.

(defun dotspacemacs/layers ()
  "Configuration Layers declaration.
You should not put any user code in this function besides modifying the variable
values."
  (setq-default
   ;; Base distribution to use. This is a layer contained in the directory
   ;; `+distribution'. For now available distributions are `spacemacs-base'
   ;; or `spacemacs'. (default 'spacemacs)
   dotspacemacs-distribution 'spacemacs
   ;; Lazy installation of layers (i.e. layers are installed only when a file
   ;; with a supported type is opened). Possible values are `all', `unused'
   ;; and `nil'. `unused' will lazy install only unused layers (i.e. layers
   ;; not listed in variable `dotspacemacs-configuration-layers'), `all' will
   ;; lazy install any layer that support lazy installation even the layers
   ;; listed in `dotspacemacs-configuration-layers'. `nil' disable the lazy
   ;; installation feature and you have to explicitly list a layer in the
   ;; variable `dotspacemacs-configuration-layers' to install it.
   ;; (default 'unused)
   dotspacemacs-enable-lazy-installation 'unused
   ;; If non-nil then Spacemacs will ask for confirmation before installing
   ;; a layer lazily. (default t)
   dotspacemacs-ask-for-lazy-installation t
   ;; If non-nil layers with lazy install support are lazy installed.
   ;; List of additional paths where to look for configuration layers.
   ;; Paths must have a trailing slash (i.e. `~/.mycontribs/')
   dotspacemacs-configuration-layer-path '()
   ;; List of configuration layers to load.
   dotspacemacs-configuration-layers
   '(
     ;; Languages
     emacs-lisp
     javascript
     html
     (markdown :variables markdown-live-preview-engine 'vmd)
     python
     ruby
     yaml
     ;; ----------------------------------------------------------------
     ;; Example of useful layers you may want to use right away.
     ;; Uncomment some layer names and press <SPC f e R> (Vim style) or
     ;; <M-m f e R> (Emacs style) to install them.
     ;; ----------------------------------------------------------------
     auto-completion
     ;; better-defaults
     chrome
     deft
     emoji
     evil-snipe
     fzf
     git
     (ivy :variables
          ;; Enable ivy-rich per
          ;; http://develop.spacemacs.org/layers/+completion/ivy/README.html#advanced-buffer-information
          ;; Note that ivy-rich has been reported to be very slow on macOS. This
          ;; feature is disabled by default.
          ivy-enable-advanced-buffer-information nil) ;; Note to self: Disabled as it's too slow with TRAMP
     (org :variables
          org-enable-reveal-js-support t
          org-enable-github-support t)
     ;; (shell :variables
     ;;        shell-default-height 30
     ;;        shell-default-position 'bottom)
     shell
     spell-checking
     syntax-checking
     themes-megapack
     theming
     (version-control :variables
                      version-control-diff-tool 'git-gutter ;; git-gutter and diff-hl
                                                            ;; both work with TRAMP
                                                            ;; git-gutter+ does not
                      version-control-diff-side 'left)
     vinegar
     )
   ;; List of additional packages that will be installed without being
   ;; wrapped in a layer. If you need some configuration for these
   ;; packages, then consider creating a layer. You can also put the
   ;; configuration in `dotspacemacs/user-config'.
   dotspacemacs-additional-packages '(color-theme-sanityinc-solarized
                                      color-theme-solarized
                                      dtrt-indent
                                      language-detection
                                      persistent-scratch)
   ;; A list of packages that cannot be updated.
   dotspacemacs-frozen-packages '()
   ;; A list of packages that will not be installed and loaded.
   dotspacemacs-excluded-packages
   '(
     org-projectile ;; https://github.com/syl20bnr/spacemacs/issues/9374#issuecomment-325238803
     )
   ;; Defines the behaviour of Spacemacs when installing packages.
   ;; Possible values are `used-only', `used-but-keep-unused' and `all'.
   ;; `used-only' installs only explicitly used packages and uninstall any
   ;; unused packages as well as their unused dependencies.
   ;; `used-but-keep-unused' installs only the used packages but won't uninstall
   ;; them if they become unused. `all' installs *all* packages supported by
   ;; Spacemacs and never uninstall them. (default is `used-only')
   dotspacemacs-install-packages 'used-only))

(defun dotspacemacs/init ()
  "Initialization function.
This function is called at the very startup of Spacemacs initialization
before layers configuration.
You should not put any user code in there besides modifying the variable
values."
  ;; This setq-default sexp is an exhaustive list of all the supported
  ;; spacemacs settings.
  (setq-default
   ;; If non nil ELPA repositories are contacted via HTTPS whenever it's
   ;; possible. Set it to nil if you have no way to use HTTPS in your
   ;; environment, otherwise it is strongly recommended to let it set to t.
   ;; This variable has no effect if Emacs is launched with the parameter
   ;; `--insecure' which forces the value of this variable to nil.
   ;; (default t)
   dotspacemacs-elpa-https t
   ;; Maximum allowed time in seconds to contact an ELPA repository.
   dotspacemacs-elpa-timeout 5
   ;; If non nil then spacemacs will check for updates at startup
   ;; when the current branch is not `develop'. Note that checking for
   ;; new versions works via git commands, thus it calls GitHub services
   ;; whenever you start Emacs. (default nil)
   dotspacemacs-check-for-update t
   ;; If non-nil, a form that evaluates to a package directory. For example, to
   ;; use different package directories for different Emacs versions, set this
   ;; to `emacs-version'.
   dotspacemacs-elpa-subdirectory nil
   ;; One of `vim', `emacs' or `hybrid'.
   ;; `hybrid' is like `vim' except that `insert state' is replaced by the
   ;; `hybrid state' with `emacs' key bindings. The value can also be a list
   ;; with `:variables' keyword (similar to layers). Check the editing styles
   ;; section of the documentation for details on available variables.
   ;; (default 'vim)
   dotspacemacs-editing-style 'vim
   ;; If non nil output loading progress in `*Messages*' buffer. (default nil)
   dotspacemacs-verbose-loading nil
   ;; Specify the startup banner. Default value is `official', it displays
   ;; the official spacemacs logo. An integer value is the index of text
   ;; banner, `random' chooses a random text banner in `core/banners'
   ;; directory. A string value must be a path to an image format supported
   ;; by your Emacs build.
   ;; If the value is nil then no banner is displayed. (default 'official)
   dotspacemacs-startup-banner nil
   ;; List of items to show in startup buffer or an association list of
   ;; the form `(list-type . list-size)`. If nil then it is disabled.
   ;; Possible values for list-type are:
   ;; `recents' `bookmarks' `projects' `agenda' `todos'."
   ;; List sizes may be nil, in which case
   ;; `spacemacs-buffer-startup-lists-length' takes effect.
   dotspacemacs-startup-lists '((recents . 5)
                                (projects . 7))
   ;; True if the home buffer should respond to resize events.
   dotspacemacs-startup-buffer-responsive t
   ;; Default major mode of the scratch buffer (default `text-mode')
   dotspacemacs-scratch-mode 'org-mode
   ;; List of themes, the first of the list is loaded when spacemacs starts.
   ;; Press <SPC> T n to cycle to the next theme in the list (works great
   ;; with 2 themes variants, one dark and one light)
   dotspacemacs-themes '(spacemacs-dark
                         spacemacs-light
                         )

   ;; Set the theme for the Spaceline. Supported themes are `spacemacs',
   ;; `all-the-icons', `custom', `vim-powerline' and `vanilla'. The first three
   ;; are spaceline themes. `vanilla' is default Emacs mode-line. `custom' is a
   ;; user defined themes, refer to the DOCUMENTATION.org for more info on how
   ;; to create your own spaceline theme. Value can be a symbol or list with\
   ;; additional properties.
   ;; (default '(spacemacs :separator wave :separator-scale 1.5))
   dotspacemacs-mode-line-theme '(spacemacs :separator wave :separator-scale 1.0)

   ;; If non-nil the cursor color matches the state color in GUI Emacs.
   ;; (default t)
   dotspacemacs-colorize-cursor-according-to-state t
   ;; Default font, or prioritized list of fonts. `powerline-scale' allows to
   ;; quickly tweak the mode-line size to make separators look not too crappy.
   dotspacemacs-default-font '(("Source Code Pro"
                                :size 18
                                :weight normal
                                :width normal
                                :powerline-scale 1.0)
                               ("Consolas"
                                :size 16
                                :weight normal
                                :width normal
                                :powerline-scale 1.0))
   ;; The leader key
   dotspacemacs-leader-key "SPC"
   ;; The key used for Emacs commands (M-x) (after pressing on the leader key).
   ;; (default "SPC")
   dotspacemacs-emacs-command-key "SPC"
   ;; The key used for Vim Ex commands (default ":")
   dotspacemacs-ex-command-key ":"
   ;; The leader key accessible in `emacs state' and `insert state'
   ;; (default "M-m")
   dotspacemacs-emacs-leader-key "M-m"
   ;; Major mode leader key is a shortcut key which is the equivalent of
   ;; pressing `<leader> m`. Set it to `nil` to disable it. (default ",")
   dotspacemacs-major-mode-leader-key ","
   ;; Major mode leader key accessible in `emacs state' and `insert state'.
   ;; (default "C-M-m")
   dotspacemacs-major-mode-emacs-leader-key "C-M-m"
   ;; These variables control whether separate commands are bound in the GUI to
   ;; the key pairs C-i, TAB and C-m, RET.
   ;; Setting it to a non-nil value, allows for separate commands under <C-i>
   ;; and TAB or <C-m> and RET.
   ;; In the terminal, these pairs are generally indistinguishable, so this only
   ;; works in the GUI. (default nil)
   dotspacemacs-distinguish-gui-tab t
   ;; If non nil `Y' is remapped to `y$' in Evil states. (default nil)
   dotspacemacs-remap-Y-to-y$ t
   ;; If non-nil, the shift mappings `<' and `>' retain visual state if used
   ;; there. (default t)
   dotspacemacs-retain-visual-state-on-shift t
   ;; If non-nil, J and K move lines up and down when in visual mode.
   ;; (default nil)
   dotspacemacs-visual-line-move-text nil
   ;; If non nil, inverse the meaning of `g' in `:substitute' Evil ex-command.
   ;; (default nil)
   dotspacemacs-ex-substitute-global nil
   ;; Name of the default layout (default "Default")
   dotspacemacs-default-layout-name "Default"
   ;; If non nil the default layout name is displayed in the mode-line.
   ;; (default nil)
   dotspacemacs-display-default-layout nil
   ;; If non nil then the last auto saved layouts are resume automatically upon
   ;; start. (default nil)
   dotspacemacs-auto-resume-layouts nil
   ;; Size (in MB) above which spacemacs will prompt to open the large file
   ;; literally to avoid performance issues. Opening a file literally means that
   ;; no major mode or minor modes are active. (default is 1)
   dotspacemacs-large-file-size 1
   ;; Location where to auto-save files. Possible values are `original' to
   ;; auto-save the file in-place, `cache' to auto-save the file to another
   ;; file stored in the cache directory and `nil' to disable auto-saving.
   ;; (default 'cache)
   dotspacemacs-auto-save-file-location 'cache
   ;; Maximum number of rollback slots to keep in the cache. (default 5)
   dotspacemacs-max-rollback-slots 5
   ;; If non nil, `helm' will try to minimize the space it uses. (default nil)
   dotspacemacs-helm-resize nil
   ;; if non nil, the helm header is hidden when there is only one source.
   ;; (default nil)
   dotspacemacs-helm-no-header nil
   ;; define the position to display `helm', options are `bottom', `top',
   ;; `left', or `right'. (default 'bottom)
   dotspacemacs-helm-position 'bottom
   ;; Controls fuzzy matching in helm. If set to `always', force fuzzy matching
   ;; in all non-asynchronous sources. If set to `source', preserve individual
   ;; source settings. Else, disable fuzzy matching in all sources.
   ;; (default 'always)
   dotspacemacs-helm-use-fuzzy 'always
   ;; If non nil the paste micro-state is enabled. When enabled pressing `p`
   ;; several times cycle between the kill ring content. (default nil)
   dotspacemacs-enable-paste-transient-state nil
   ;; Which-key delay in seconds. The which-key buffer is the popup listing
   ;; the commands bound to the current keystroke sequence. (default 0.4)
   dotspacemacs-which-key-delay 0.4
   ;; Which-key frame position. Possible values are `right', `bottom' and
   ;; `right-then-bottom'. right-then-bottom tries to display the frame to the
   ;; right; if there is insufficient space it displays it at the bottom.
   ;; (default 'bottom)
   dotspacemacs-which-key-position 'bottom
   ;; If non nil a progress bar is displayed when spacemacs is loading. This
   ;; may increase the boot time on some systems and emacs builds, set it to
   ;; nil to boost the loading time. (default t)
   dotspacemacs-loading-progress-bar t
   ;; If non nil the frame is fullscreen when Emacs starts up. (default nil)
   ;; (Emacs 24.4+ only)
   dotspacemacs-fullscreen-at-startup nil
   ;; If non nil `spacemacs/toggle-fullscreen' will not use native fullscreen.
   ;; Use to disable fullscreen animations in OSX. (default nil)
   dotspacemacs-fullscreen-use-non-native nil
   ;; If non nil the frame is maximized when Emacs starts up.
   ;; Takes effect only if `dotspacemacs-fullscreen-at-startup' is nil.
   ;; (default nil) (Emacs 24.4+ only)
   dotspacemacs-maximized-at-startup nil
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's active or selected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-active-transparency 90
   ;; A value from the range (0..100), in increasing opacity, which describes
   ;; the transparency level of a frame when it's inactive or deselected.
   ;; Transparency can be toggled through `toggle-transparency'. (default 90)
   dotspacemacs-inactive-transparency 90
   ;; If non nil show the titles of transient states. (default t)
   dotspacemacs-show-transient-state-title t
   ;; If non nil show the color guide hint for transient state keys. (default t)
   dotspacemacs-show-transient-state-color-guide t
   ;; If non nil unicode symbols are displayed in the mode line. (default t)
   dotspacemacs-mode-line-unicode-symbols t
   ;; If non nil smooth scrolling (native-scrolling) is enabled. Smooth
   ;; scrolling overrides the default behavior of Emacs which recenters point
   ;; when it reaches the top or bottom of the screen. (default t)
   dotspacemacs-smooth-scrolling t
   ;; Control line numbers activation.
   ;; If set to `t' or `relative' line numbers are turned on in all `prog-mode' and
   ;; `text-mode' derivatives. If set to `relative', line numbers are relative.
   ;; This variable can also be set to a property list for finer control:
   ;; '(:relative nil
   ;;   :disabled-for-modes dired-mode
   ;;                       doc-view-mode
   ;;                       markdown-mode
   ;;                       org-mode
   ;;                       pdf-view-mode
   ;;                       text-mode
   ;;   :size-limit-kb 1000)
   ;; (default nil)
   dotspacemacs-line-numbers 'relative
   ;; Code folding method. Possible values are `evil' and `origami'.
   ;; (default 'evil)
   dotspacemacs-folding-method 'evil
   ;; If non-nil smartparens-strict-mode will be enabled in programming modes.
   ;; (default nil)
   dotspacemacs-smartparens-strict-mode nil
   ;; If non-nil pressing the closing parenthesis `)' key in insert mode passes
   ;; over any automatically added closing parenthesis, bracket, quote, etc…
   ;; This can be temporary disabled by pressing `C-q' before `)'. (default nil)
   dotspacemacs-smart-closing-parenthesis nil
   ;; Select a scope to highlight delimiters. Possible values are `any',
   ;; `current', `all' or `nil'. Default is `all' (highlight any scope and
   ;; emphasis the current one). (default 'all)
   dotspacemacs-highlight-delimiters 'all
   ;; If non nil, advise quit functions to keep server open when quitting.
   ;; (default nil)
   dotspacemacs-persistent-server t
   ;; List of search tool executable names. Spacemacs uses the first installed
   ;; tool of the list. Supported tools are `ag', `pt', `ack' and `grep'.
   ;; (default '("ag" "pt" "ack" "grep"))
   dotspacemacs-search-tools '("rg" "ag" "pt" "ack" "grep")
   ;; The default package repository used if no explicit repository has been
   ;; specified with an installed package.
   ;; Not used for now. (default nil)
   dotspacemacs-default-package-repository nil
   ;; Delete whitespace while saving buffer. Possible values are `all'
   ;; to aggressively delete empty line and long sequences of whitespace,
   ;; `trailing' to delete only the whitespace at end of lines, `changed'to
   ;; delete only whitespace for changed lines or `nil' to disable cleanup.
   ;; (default nil)
   dotspacemacs-whitespace-cleanup 'changed
   ))

(defun dotspacemacs/user-init ()
  "Initialization function for user code.
It is called immediately after `dotspacemacs/init', before layer configuration
executes.
 This function is mostly useful for variables that need to be set
before packages are loaded. If you are unsure, you should try in setting them in
`dotspacemacs/user-config' first."
  (setq tramp-use-ssh-controlmaster-options nil)
  ;; Theme Customizations per http://philipdaniels.com/blog/2017/02/spacemacs---configuring-the-solarized-theme/
  ;; (setq theming-modifications
  ;;     '((sanityinc-solarized-dark
  ;;        ;; Provide a sort of "on-off" modeline whereby the current buffer has a nice
  ;;        ;; bright blue background, and all the others are in cream.
  ;;        ;; TODO: Change to use variables here. However, got error:
  ;;        ;; (Spacemacs) Error in dotspacemacs/user-config: Wrong type argument: stringp, pd-blue
  ;;        (mode-line :foreground "#e9e2cb" :background "#2075c7" :inverse-video nil)
  ;;        (powerline-active1 :foreground "#e9e2cb" :background "#2075c7" :inverse-video nil)
  ;;        (powerline-active2 :foreground "#e9e2cb" :background "#2075c7" :inverse-video nil)
  ;;        (mode-line-inactive :foreground "#2075c7" :background "#e9e2cb" :inverse-video nil)
  ;;        (powerline-inactive1 :foreground "#2075c7" :background "#e9e2cb" :inverse-video nil)
  ;;        (powerline-inactive2 :foreground "#2075c7" :background "#e9e2cb" :inverse-video nil)

  ;;        ;; Make a really prominent helm selection line.
  ;;        ;;(helm-selection :foreground "white" :background "" :inverse-video nil)
  ;;        ;; See comment above about dotspacemacs-colorize-cursor-according-to-state.
  ;;        ;;(cursor :background "#b58900")
  ;;      )))
  )

(defun dotspacemacs/user-config ()
  "Configuration function for user code.
This function is called at the very end of Spacemacs initialization after
layers configuration.
This is the place where most of your configurations should be done. Unless it is
explicitly specified that a variable should be set before a package is loaded,
you should place your code here."

  ;; set defaults
  (setq-default
   deft-directory "~/Dropbox/Notes"
   deft-extensions '("md" "org" "txt")
   dotspacemacs-use-spacelpa t
   evil-escape-key-sequence ";y"
   evil-escape-key-sequence "y;"
   evil-magic 'very-magic       ;; very magic by default
   evil-shift-round nil
   evil-want-fine-undo t        ;; more granular undo increments per https://emacs.stackexchange.com/a/24948
   split-width-threshold 100    ;; split windows if the window's max width <100
   fill-column 80
   find-file-visit-truename t   ;; follow symlinks
   indent-tabs-mode nil         ;; only use spaces
   ivy-initial-inputs-alist nil ;; remove default '^' per https://github.com/abo-abo/swiper/issues/975
   ns-pop-up-frames nil         ;; reuse frames
   )

  (unless (display-graphic-p) ;; if run in terminal
    (progn
      ;; fix solarized theme in terminal per https://github.com/syl20bnr/spacemacs/issues/1269#issuecomment-198309213
      ;; (set-terminal-parameter nil 'background-mode 'dark)
      ;; (set-frame-parameter nil 'background-mode 'dark)
      ;; (spacemacs/load-theme 'zenburn)

      ;; make it easier to copy and paste in terminal mode
      (xterm-mouse-mode -1) ;; disable mouse mode
      (setq term-suppress-hard-newline t) ;; disable newlines
      (set-display-table-slot standard-display-table 'wrap ?\b) ;; disable wrap character
      )
    )
  (add-to-list 'default-frame-alist '(font . "Source Code Pro-18"))

  ;; Start persistent server
  (require 'server) (unless (server-running-p) (server-start))

  ;; Disable visual select to system clipboard per https://github.com/syl20bnr/spacemacs/blob/master/doc/FAQ.org#prevent-the-visual-selection-overriding-my-system-clipboard
  (fset 'evil-visual-update-x-selection 'ignore)

  ;; Separate system clipboard from default yank register per https://github.com/syl20bnr/spacemacs/issues/5750#issuecomment-281480406
  ;; unintended side effect (bug?): will make SPC fyy not show filename in the minibuffer. It must rely on clipboard
  (setq-default x-select-enable-clipboard 't)
  (define-key evil-visual-state-map (kbd "s-c") (kbd "\"+y"))
  (define-key evil-insert-state-map  (kbd "s-v") (kbd "+"))
  (define-key evil-ex-completion-map (kbd "s-v") (kbd "+"))
  (define-key evil-ex-search-keymap  (kbd "s-v") (kbd "+"))

  ;; run in all text buffers
  (add-hook 'text-mode-hook #'(lambda ()
                                ;; Word wrap in all text modes per https://www.reddit.com/r/emacs/comments/43vfl1/enable_wordwrap_in_orgmode/czmaj7n/
                                (toggle-word-wrap)
                                (spacemacs/toggle-truncate-lines-off)
                                ))

  ;; run in all source buffers
  (add-hook 'prog-mode-hook #'(lambda ()
                                (dtrt-indent-mode)
                                (dtrt-indent-adapt)
                                (diminish 'dtrt-indent-mode "Ⓘ")
                                (spacemacs/toggle-truncate-lines-on)
                                (turn-on-fci-mode)
                                ))

  ;; Fix shell path in TRAMP for some remote servers from https://github.com/bbatsov/projectile/issues/921#issuecomment-161491231
  (defun my/shell-set-hook ()
    (when (file-remote-p (buffer-file-name))
      (let ((vec (tramp-dissect-file-name (buffer-file-name))))
          (setq-local shell-file-name "/bin/bash"))))
  (add-hook 'find-file-hook #'my/shell-set-hook)

  (global-company-mode t) ;; enable autocomplete in all buffers
  (diminish 'mmm-mode "Ṁ")
  (evilnc-default-hotkeys) ;; setup evil-nerd-commenter

  ;; Overwrite `deft-current-files` for the `deft-buffer-setup` and limit it to 30 entries: https://github.com/jrblevin/deft/issues/43#issuecomment-350198825
  (defun anks-deft-limiting-fn (orig-fun &rest args)
    (let
        ((deft-current-files (-take 30 deft-current-files)))
      (apply orig-fun args)))
  (advice-add 'deft-buffer-setup :around #'anks-deft-limiting-fn)

  ;; Default mode
  (add-to-list 'auto-mode-alist '("\\.txt\\'" . markdown-mode)) ;; in .txt files
  (add-to-list 'auto-mode-alist '("\\.xml\\'" . xml-mode)) ;; in .xml files
  (setq-default major-mode 'markdown-mode)                      ;; for all buffers

  ;; Org config
  (with-eval-after-load 'org

    ;; General
    (setq org-directory "~/WorkDocs/Notational Data")
    (setq org-default-notes-file (concat org-directory "/notes.org"))
    (setq org-footnote-auto-adjust t) ;; sort and renumber footnotes after every insert/delete

    ;; SPC o and SPC m o are reserved for the user. Setting key bindings behind these is guaranteed to never conflict with Spacemacs default key bindings.
    (spacemacs/set-leader-keys "oc" 'org-capture)
    (spacemacs/set-leader-keys "oh" 'org-toggle-heading)
    (spacemacs/set-leader-keys "on" 'org-footnote-normalize)

    ;; Capture templates
    (setq org-capture-templates
          '(("t" "Todo" entry (file+headline org-default-notes-file "Unfiled")
             "* TODO %?\n\tCreated on %U\n  %i\n  %a")
            ("j" "Journal" entry (file+datetree (concat org-directory "/journal.org"))
             "* %?\nEntered on %U\n  %i\n  %a")))

    ;; Todos
    (setq org-todo-keywords
          '((sequence "TODO(t)" "IN-PROGRESS(i)" "WAITING(w)" "|" "DONE(d)")
            (sequence "|" "CANCELED(c)")))
    (setq org-todo-keyword-faces
          '(("TODO" . org-warning) ("CANCELED" . (:foreground "blue" :weight bold))))

    ;; MobileOrg config from http://jonathanchu.is/posts/org-mode-and-mobileorg-installation-and-config/
    (setq org-mobile-inbox-for-pull "~/Dropbox/Apps/MobileOrg/inbox.org")
    (setq org-mobile-directory "~/Dropbox/Apps/MobileOrg")
    (setq org-mobile-files '("~/Dropbox/Notes"))
    ;; MobileOrg sync on idle from https://stackoverflow.com/a/8432149/908640
    (defvar org-mobile-sync-timer nil)
    (defvar org-mobile-sync-idle-secs (* 60 10))
    (defun org-mobile-sync ()
      (interactive)
      (org-mobile-pull)
      (org-mobile-push))
    (defun org-mobile-sync-enable ()
      "enable mobile org idle sync"
      (interactive)
      (setq org-mobile-sync-timer
            (run-with-idle-timer org-mobile-sync-idle-secs t
                                 'org-mobile-sync)));
    (defun org-mobile-sync-disable ()
      "disable mobile org idle sync"
      (interactive)
      (cancel-timer org-mobile-sync-timer))
    (org-mobile-sync-enable)

    ;; Meeting notes with Org per http://orgmode.org/worg/org-tutorials/org-meeting-tasks.html
    (spacemacs/set-leader-keys "oa" 'org-mactions-new-numbered-action)

    (defcustom org-mactions-numbered-action-format "TODO Action #%d "
      "Default structure of the headling of a new action.
    %d will become the number of the action."
      :group 'org-edit-structure
      :type 'string)

    (defcustom org-mactions-change-id-on-copy t
      "Non-nil means make new IDs in copied actions.
If an action copied with the command `org-mactions-collect-todos-in-subtree'
contains an ID, that ID will be replaced with a new one."
      :group 'org-edit-structure
      :type 'string)

    (defun org-mactions-new-numbered-action (&optional inline)
      "Insert a new numbered action, using `org-mactions-numbered-action-format'.
    With prefix argument, insert an inline task."
      (interactive "P")
      (let* ((num (let ((re "\\`#\\([0-9]+\\)\\'"))
                    (1+ (apply 'max 0
                               (mapcar
                                (lambda (e)
                                  (if (string-match re (car e))
                                      (string-to-number (match-string 1 (car e)))
                                    0))
                                (org-get-buffer-tags))))))
             (tag (concat "#" (number-to-string num))))
        (if inline
            (org-inlinetask-insert-task)
          (org-insert-heading 'force))
        (unless (eql (char-before) ?\ ) (insert " "))
        (insert (format org-mactions-numbered-action-format num))
        (org-toggle-tag tag 'on)
        (if (= (point-max) (point-at-bol))
            (save-excursion (goto-char (point-at-eol)) (insert "\n")))
        (unless (eql (char-before) ?\ ) (insert " "))))

    (defun org-mactions-collect-todos-in-subtree ()
      "Collect all TODO items in the current subtree into a flat list."
      (interactive)
      (let ((buf (get-buffer-create "Org TODO Collect"))
            (cnt 0) beg end string s)
        (with-current-buffer buf (erase-buffer) (org-mode))
        (org-map-entries
         (lambda ()
           (setq beg (point) end (org-end-of-subtree t t) cnt (1+ cnt)
                 string (buffer-substring beg end)
                 s 0)
           (when org-mactions-change-id-on-copy
             (while (string-match "^\\([ \t]*:ID:\\)[ \t\n]+\\([^ \t\n]+\\)[ \t]*$"
                                  string s)
               (setq s (match-end 1)
                     string (replace-match (concat "\\1 "
                                                   (save-match-data (org-id-new)))
                                           t nil string))))
           (with-current-buffer buf (org-paste-subtree 1 string)
                                (goto-char (point-max))))
         (format "TODO={%s}" (regexp-opt org-not-done-keywords))
         'tree)
        (if (= cnt 0)
            (message "No TODO items in subtree")
          (message "%d TODO entries copied to kill ring" cnt)
          (prog1 (with-current-buffer buf
                   (kill-new (buffer-string)))
            (kill-buffer buf)))))

    ;; Breadcrumbs in agenda inspired by https://stackoverflow.com/a/22900459/908640
    ;; Only add breadcrumbs to agenda items with "Meetings" as parents. Format: [Meeting]Breadcrumbs
    (setq org-agenda-prefix-format '((agenda . " %i %-12:c%?-12t %(if (member \"Meetings\" (last (org-get-outline-path))) (concat \"[Meeting]\"(org-format-outline-path (butlast (org-get-outline-path))) \" \") (concat))% s")
                                     (timeline . "  % s")
                                     ;; Only add breadcrumbs to todos with "Meetings" as parents. Format: [Breadcrumbs minus "Meetings"]Text
                                     (todo .
                                           " %i %-12:c %(if (member \"Meetings\" (last (org-get-outline-path))) (concat \"[\"(org-format-outline-path (butlast (org-get-outline-path))) \"]\") (concat))")
                                     (tags .
                                           " %i %-12:c %(concat \"[ \"(org-format-outline-path (org-get-outline-path)) \" ]\") ")
                                     (search . " %i %-12:c"))
          )

    ) ;; Org

  ;; persistent scratch
  (persistent-scratch-setup-default)

  ;; Load host-specific config
  (when (file-exists-p "~/.emacs.d/private/local/local.el") (load "~/.emacs.d/private/local/local.el"))

  )

;; Do not write anything past this comment. This is where Emacs will
;; auto-generate custom variable definitions.
(defun dotspacemacs/emacs-custom-settings ()
  "Emacs custom settings.
This is an auto-generated function, do not modify its content directly, use
Emacs customize menu instead.
This function is called at the very end of Spacemacs initialization."
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(org-agenda-files
   (quote
    ("~/WorkDocs/Notational Data/notes.org" "~/Dropbox/org/personal.org")))
 '(package-selected-packages
   (quote
    (kaolin-themes doom-themes doom-modeline magit tern less-css-mode evil-snipe persistent-scratch org-mime deft yaml-mode vmd-mode web-beautify livid-mode skewer-mode simple-httpd json-mode json-snatcher json-reformat js2-refactor yasnippet multiple-cursors js2-mode js-doc coffee-mode yapfify pyvenv pytest pyenv-mode py-isort pip-requirements live-py-mode hy-mode dash-functional cython-mode anaconda-mode pythonic flyspell-correct-ivy flyspell-correct auto-dictionary zonokai-theme zenburn-theme zen-and-art-theme underwater-theme ujelly-theme twilight-theme twilight-bright-theme twilight-anti-bright-theme toxi-theme tao-theme tangotango-theme tango-plus-theme tango-2-theme sunny-day-theme sublime-themes subatomic256-theme subatomic-theme spacegray-theme soothe-theme solarized-theme soft-stone-theme soft-morning-theme soft-charcoal-theme smyx-theme seti-theme reverse-theme railscasts-theme purple-haze-theme professional-theme planet-theme phoenix-dark-pink-theme phoenix-dark-mono-theme organic-green-theme omtose-phellack-theme oldlace-theme occidental-theme obsidian-theme noctilux-theme naquadah-theme mustang-theme monokai-theme monochrome-theme molokai-theme moe-theme minimal-theme material-theme majapahit-theme madhat2r-theme lush-theme light-soap-theme jbeans-theme jazz-theme ir-black-theme inkpot-theme heroku-theme hemisu-theme hc-zenburn-theme gruvbox-theme gruber-darker-theme grandshell-theme gotham-theme gandalf-theme flatui-theme flatland-theme farmhouse-theme espresso-theme dracula-theme django-theme darktooth-theme autothemer darkokai-theme darkmine-theme darkburn-theme dakrone-theme cyberpunk-theme color-theme-sanityinc-tomorrow color-theme-sanityinc-solarized clues-theme cherry-blossom-theme busybee-theme bubbleberry-theme birds-of-paradise-plus-theme badwolf-theme apropospriate-theme anti-zenburn-theme ample-zen-theme ample-theme alect-themes afternoon-theme language-detection mmm-mode markdown-toc markdown-mode gh-md web-mode tagedit slim-mode scss-mode sass-mode pug-mode haml-mode emmet-mode ox-reveal ox-gfm org-projectile org-category-capture org-present org-pomodoro alert log4e gntp org-download htmlize gnuplot ws-butler winum which-key wgrep volatile-highlights vi-tilde-fringe uuidgen use-package toc-org spaceline powerline smex restart-emacs request rainbow-delimiters popwin persp-mode pcre2el paradox spinner org-plus-contrib org-bullets open-junk-file neotree move-text macrostep lorem-ipsum linum-relative link-hint ivy-hydra info+ indent-guide hydra hungry-delete hl-todo highlight-parentheses highlight-numbers parent-mode highlight-indentation hide-comnt help-fns+ helm-make helm helm-core google-translate golden-ratio flx-ido flx fill-column-indicator fancy-battery eyebrowse expand-region exec-path-from-shell evil-visualstar evil-visual-mark-mode evil-unimpaired evil-tutor evil-surround evil-search-highlight-persist evil-numbers evil-nerd-commenter evil-mc evil-matchit evil-lisp-state smartparens evil-indent-plus evil-iedit-state iedit evil-exchange evil-escape evil-ediff evil-args evil-anzu anzu evil goto-chg undo-tree eval-sexp-fu highlight elisp-slime-nav dumb-jump popup f dash s diminish define-word counsel-projectile projectile pkg-info epl counsel swiper ivy column-enforce-mode clean-aindent-mode bind-map bind-key auto-highlight-symbol auto-compile packed async aggressive-indent adaptive-wrap ace-window ace-link avy)))
 '(persistent-scratch-autosave-interval 10)
 '(persistent-scratch-backup-directory "~/.emacs.d.persistent-scratch"))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
)
