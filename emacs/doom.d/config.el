;;; ~/.doom.d/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here

(restore-frame-position)

;; Functions
(defun joe/avy-goto-url()
  "Use avy to go to an URL in the buffer."
  ;; Copied from http://bit.ly/2PJQoIq
  (interactive)
  (avy--generic-jump "https?://" nil 'pre))

(setq doom-font (font-spec :family "Inconsolata" :size 18)
      split-width-threshold 100 ;; split windows if the window's max width <100
      evil-escape-key-sequence ";y"
      evil-escape-unordered-key-sequence t

      ;; deft
      deft-default-extension "txt"
      deft-directory "~/Google Drive/Notational Velocity"
      deft-extensions '("md" "org" "txt")
      deft-use-filename-as-title t

      ;; ffip
      ffip-use-rust-fd t

      )

;; Default modes
(add-to-list 'auto-mode-alist '("\\.txt\\'" . markdown-mode)) ;; default mode for .txt files

;; UTF8 per http://ergoemacs.org/emacs/emacs_encoding_decoding_faq.html
(set-language-environment "UTF-8")

;; deft
;; Overwrite `deft-current-files` for the `deft-buffer-setup` and limit it to 30 entries: https://github.com/jrblevin/deft/issues/43#issuecomment-350198825
(defun anks-deft-limiting-fn (orig-fun &rest args)
  (let
      ((deft-current-files (-take 30 deft-current-files)))
    (apply orig-fun args)))
(advice-add 'deft-buffer-setup :around #'anks-deft-limiting-fn)
;; auto refresh after clearing filter
(advice-add #'deft-filter-clear :after #'deft-refresh)
(setq deft-file-naming-rules
      '((noslash . "-")
        (case-fn . downcase)))

;; Org mode
(setq
 org-directory "~/Google Drive/Notational Velocity"
 org-default-notes-file (concat org-directory "/notes.org")
 org-footnote-auto-adjust t ;; sort and renumber footnotes after every insert/delete
 +workspaces-on-switch-project-behavior nil ;; make switch-project not open new workspace
 )
;; failback notes directory
(unless (file-directory-p org-directory) (setq org-directory "~/Dropbox/Notes"))

;; use fd per https://github.com/abo-abo/swiper/issues/1926#issuecomment-462026310
(if (executable-find "fd") (setq find-program "fd"
                                 counsel-file-jump-args "--hidden")
  (if (executable-find "rg") (setq find-program "rg"
                                   counsel-file-jump-args "--files --hidden --no-messages") nil))
;; make projectile faster
(after! projectile
  (if (executable-find "fd") (setq projectile-generic-command "fd . -0"
                                      projectile-git-command "fd . -0")
    (if (executable-find "rg") (setq projectile-generic-command "rg --files -0 --no-messages ."
                                     projectile-git-command "rg --files -0 --no-messages .") nil))
  (setq projectile-switch-project-action 'projectile-find-file-dwim))

;; Ivy
(add-to-list 'ivy-re-builders-alist '(counsel-M-x . ivy--regex-ignore-order))
(add-to-list 'ivy-re-builders-alist '(counsel-describe-function . ivy--regex-ignore-order))

;; Snipe
(evil-snipe-override-mode 1)  ;; enable 1-char snipes
(setq evil-snipe-scope 'buffer)  ;; snipe rest of buffer after cursor
;; Disable 1-char snipes in magit because conflicts
(add-hook 'magit-mode-hook 'turn-off-evil-snipe-override-mode)
;; To map [ to any opening parentheses or bracket in all modes:
(push '(?\[ "[[{(]") evil-snipe-aliases)

;; set default regex builder for all commands
;; (setq ivy-re-builders-alist '((t . ivy--regex-ignore-order)))

(after! counsel
  ;; This currently does not work
  (add-to-list 'ivy-sort-functions-alist '(counsel-recentf . file-newer-than-file-p))
  )

;; Keybindings
;; examples at https://github.com/hlissner/doom-emacs/blob/master/modules/private/default/%2Bbindings.el
(map!
 ;; Global bindings
 :gnvime [A-backspace] #'backward-kill-word
 :n "DEL" #'evil-switch-to-windows-last-buffer
 :m "\\" nil ;; by default this is evil-execute-in-emacs-state, which I never use. TODO: This doesn't work
 :i "A-SPC"            #'+company/complete ;; I use C-SPC for Spotlight com

 ;; Leader bindings
 (:leader
   :desc "Last buffer"              :n "\\" #'evil-switch-to-windows-last-buffer
   :desc "Switch buffer"            :n "bb" #'+ivy/switch-buffer  ;; swap default switch-buffer binds as I don't use workspaces often
   :desc "Switch workspace buffer"  :n "bB" #'+ivy/switch-workspace-buffer
   :desc "Switch workspace buffer"  :n "bw" #'+ivy/switch-workspace-buffer  ;; easier
   :desc "Find file in project"     :n "SPC" #'find-file-in-project

   ;; Recursive find-file in a target directory (broken as of 2022-07-15)
   ;; :desc "Find file in directory" :n "f/" (lambda! (counsel-file-jump nil (read-directory-name "From directory: ")))
   ;; Recursive grep in target directory (broken as of 2021-03-03)
   ;; :n "/" nil
   ;; :desc "Target directory" :n "//" (lambda! (+ivy/rg nil nil (read-directory-name "From directory: ")))
   ;; Broken as of 2022-07-15
   ;; :desc "Find file in subdirectory" :n "ff"  (lambda!
   ;;                                             (let* ((proot (read-directory-name "From parent directory: "))
   ;;                                                    (pdir (expand-file-name (projectile-complete-dir proot)
   ;;                                                                            proot))
   ;;                                                    (file (projectile-completing-read
   ;;                                                           "Find file: "
   ;;                                                           (projectile-project-files pdir))))
   ;;                                               (find-file (expand-file-name file pdir))))

   ;; Prefix bindings
   (:prefix ("j" . "avy")
     :nv "b" #'avy-pop-mark
     :nv "j" #'evil-avy-goto-char
     :nv "J" #'evil-avy-goto-char-2
     :nv "l" #'evil-avy-goto-line
     :nv "u" #'+joe/avy-goto-url
     :nv "w" #'evil-avy-goto-word-or-subword-1)

   (:prefix ("t" . "toggle")
     :desc "Truncate lines"           :n "t" #'toggle-truncate-lines)

   ;; Custom prefix - (e)xtended
   (:prefix ("e" . "extended")
     :nv "o" #'link-hint-open-link
     :nv "y" #'link-hint-copy-link))

 ;; deft
 (:after deft
   (:map (deft-mode-map)
     :i "C-u"                  #'deft-filter-clear
     :i [M-backspace]          #'deft-filter-decrement-word))

 ;; evil-magit
 (:after evil-magit
   (:map (magit-status-mode-map magit-revision-mode-map)
     :n [A-tab]          #'magit-section-cycle-diffs)) ;; M-tab is used by OSX

 ;; magit git commit buffer
 (:after with-editor
   :map with-editor-mode-map
   (:localleader
     :n "c" #'with-editor-finish
     :n "k" #'with-editor-cancel))

 ;; markdown
 (:after markdown-mode
   (:map markdown-mode-map
     (:localleader
       ;; Movement
       :nv "{"   #'markdown-backward-paragraph
       :nv "}"   #'markdown-forward-paragraph
       ;; Completion, and Cycling
       :nv "]"       #'markdown-complete
       :nv [tab]     #'markdown-cycle
       ;; Indentation
       :nv ">"   #'markdown-indent-region
       :nv "<"   #'markdown-outdent-region
       ;; Element removal
       :nv "k"   #'markdown-kill-thing-at-point

       ;; Do something sensible based on context
       :nv "d"   #'markdown-do
       :nv "t"   #'markdown-do  ;; mirror Org (t)odo bind

       ;; Following and Jumping
       :n "N"   #'markdown-next-link
       :n "f"   #'markdown-follow-thing-at-point
       :n "P"   #'markdown-previous-link
       :n "<RET>" #'markdown-jump

       (:prefix ("c" . "complete buffer")
         ;; Buffer-wide commands
         :nv "]"  #'markdown-complete-buffer
         :nv "c"  #'markdown-check-refs
         :nv "e"  #'markdown-export
         :nv "m"  #'markdown-other-window
         :nv "n"  #'markdown-cleanup-list-numbers
         :nv "o"  #'markdown-open
         :nv "p"  #'markdown-preview
         :nv "v"  #'markdown-export-and-preview
         :nv "w"  #'markdown-kill-ring-save)

       (:prefix ("h" . "headings")
         :nv "i"  #'markdown-insert-header-dwim
         :nv "I"  #'markdown-insert-header-setext-dwim
         :nv "1"  #'markdown-insert-header-atx-1
         :nv "2"  #'markdown-insert-header-atx-2
         :nv "3"  #'markdown-insert-header-atx-3
         :nv "4"  #'markdown-insert-header-atx-4
         :nv "5"  #'markdown-insert-header-atx-5
         :nv "6"  #'markdown-insert-header-atx-6
         :nv "!"  #'markdown-insert-header-setext-1
         :nv "@"  #'markdown-insert-header-setext-2)

       (:prefix ("i" . "insert")
         ;; Insertion of common elements
         ;;:nv "ik"  #'spacemacs/insert-keybinding-markdown
         :nv "-"   #'markdown-insert-hr
         :nv "f"  #'markdown-insert-footnote
         :nv "i"  #'markdown-insert-image
         :nv "I"  #'markdown-insert-reference-image
         :nv "l"  #'markdown-insert-link
         :nv "L"  #'markdown-insert-reference-link-dwim
         :nv "w"  #'markdown-insert-wiki-link
         :nv "u"  #'markdown-insert-uri)

       (:prefix ("l" . "lists")
         :nv "i"  #'markdown-insert-list-item
         :nv "c"  #'markdown-insert-gfm-checkbox
         :nv "t"  #'markdown-toggle-gfm-checkbox)

       (:prefix ("x" . "region manipulation")
         :nv "b"  #'markdown-insert-bold
         :nv "i"  #'markdown-insert-italic
         :nv "c"  #'markdown-insert-code
         :nv "C"  #'markdown-insert-gfm-code-block
         :nv "q"  #'markdown-insert-blockquote
         :nv "Q"  #'markdown-blockquote-region
         :nv "p"  #'markdown-insert-pre
         :nv "P"  #'markdown-pre-region))))

 (:after org
   (:map org-mode-map
     (:localleader
       ;; need to unbind keys that have already been mapped before mapping them
       "," nil
       ","  #'counsel-org-goto
       "/" nil
       (:prefix ("/" . "search")
         "a"  #'helm-org-agenda-files-headings)
       "h" nil
       (:prefix ("h" . "heading")
         "i"  #'org-insert-heading-after-current
         "I"  #'org-insert-heading
         "h"  #'org-toggle-heading
         "s"  #'org-insert-subheading)
       (:prefix ("g" . "goto")
         "/"  #'counsel-org-goto
         "j"  #'org-forward-heading-same-level
         "k"  #'org-backward-heading-same-level
         "l"  #'outline-next-visible-heading)
       (:prefix ("S" . "subtree")
         "j"  #'org-move-subtree-down
         "k"  #'org-move-subtree-up
         "h"  #'org-toggle-heading
         "s"  #'org-insert-subheading))))
 )

(after! magit
  ;; Load magit in split frame
  (setq magit-display-buffer-function 'magit-display-buffer-traditional))

;; Terminal-specific config
(unless (display-graphic-p)
  (progn
    (setq-hook! 'minibuffer-setup-hook truncate-lines t) ;; don't wrap in ivy results
    (setq term-suppress-hard-newline t) ;; disable newlines
    (set-display-table-slot standard-display-table 'wrap ?\b))) ;; disable wrap character

;; load local config last
(when (file-exists-p "~/.emacs.local.el") (load "~/.emacs.local.el"))
