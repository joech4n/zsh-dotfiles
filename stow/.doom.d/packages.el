;; -*- no-byte-compile: t; -*-
;;; ~/.doom.d/packages.el

;;; Examples:
;; (package! some-package)
;; (package! another-package :recipe (:fetcher github :repo "username/repo"))
;; (package! builtin-package :disable t)

;; TODO: this currently doesn't work. This allows the user package to take
;; precedence over the system package. `doom up` will show that the package
;; fails to install, but this should work and allow the package in
;; ~/.emacs.d/.local/packages take precdence over the system package in
;; /usr/share
;; (package! apache-mode-new :recipe (apache-mode :fetcher github :repo "emacs-php/apache-mode"))
;; (package! diminish-new :recipe (diminish :fetcher github :repo "emacsmirror/diminish"))

(package! deft)
(package! find-file-in-project)
(package! graphviz-dot-mode)
(package! helm-fzf :recipe (:host github :repo "ibmandura/helm-fzf"))
(package! link-hint)
(package! lua-mode)
(package! restore-frame-position :recipe (:host github :repo "aaronjensen/restore-frame-position"))
(package! web-mode)
(package! vimrc-mode)
(load! "~/.doom.local.packages" nil t)

;;; .emacs ends here
