;; Set fringes
(set-fringe-style '(10 . 0))


;; Turn off mouse interface early in startup to avoid momentary display
;; (if (fboundp 'menu-bar-mode) (menu-bar-mode -1))
(if (fboundp 'tool-bar-mode) (tool-bar-mode -1))
(if (fboundp 'scroll-bar-mode) (scroll-bar-mode -1))

;; No splash screen please ... jeez
(setq inhibit-startup-message t)

;; No scratch message
(setq initial-scratch-message nil)

;; This is not really good...
;; (setq warning-minimum-level :emergency)
(setq settings-dir (expand-file-name "settings" emacs.d-directory))

;; ;; Set up load path
(add-to-list 'load-path settings-dir)

(setq package-user-dir (expand-file-name "elpa" emacs.d-directory))

;; Keep emacs Custom-settings in separate file
(setq custom-file (expand-file-name "custom.el" emacs.d-directory))
(load custom-file)

;; Write backup files to own directory
(setq backup-directory-alist `(("." . ,(expand-file-name "backups"  user-emacs-directory))))

;; Make backups of files, even when they're in version control
(setq vc-make-backup-files t)

;; Save point position between sessions
(save-place-mode 1)
(setq save-place-file (expand-file-name ".places" user-emacs-directory))
(setq save-place-forget-unreadable-files nil)

;; Are we on a mac?
(setq is-mac (equal system-type 'darwin))

;; ;; Setup packages
(require 'setup-package)

;; Install extensions if they're missing
(defun init--install-packages ()
  (packages-install
   '(;; whitespace-cleanup-mode
     avy
     browse-kill-ring
     change-inner
     company
     dash
     diminish
     elisp-slime-nav
     expand-region
     f
     flx
     flx-ido
     hydra
     ido-at-point
     ido-completing-read+
     ido-vertical-mode
     key-chord
     move-text
     multiple-cursors
     phi-search
     s
     smex
     undo-tree
     visual-regexp
     wgrep
     window-numbering
)))

(condition-case nil
    (init--install-packages)
  (error
   (package-refresh-contents)
   (init--install-packages)))

;; Functions (load all files in defuns-dir)
(setq defuns-dir (expand-file-name "defuns" emacs.d-directory))
(dolist (file (directory-files defuns-dir t "\\w+"))
  (when (file-regular-p file)
    (load file)))


;; Functions (load all el-files in wiki-defuns-dir)
(setq wiki-defuns-dir (expand-file-name "wiki-defuns" emacs.d-directory)) 
(load (expand-file-name "frame-fns.el" wiki-defuns-dir))
(dolist (file (directory-files wiki-defuns-dir t "\\w+.el"))
  (when (file-regular-p file)
    (load file)))

;; Functions (load all el-files in my-defuns-dir)
(setq my-defuns-dir (expand-file-name "my-defuns" emacs.d-directory))
(dolist (file (directory-files my-defuns-dir t "\\w+.el"))
  (when (file-regular-p file)
    (load file)))

;; Set up appearance early
(require 'appearance)

;; Lets start with a smattering of sanity
(require 'sane-defaults)

;; Setup environment variables from the user's shell.
;; (when is-mac
;;   (require-package 'exec-path-from-shell)
;;   (exec-path-from-shell-initialize))

(setq shell-command-switch "-ic")

;; ;; Setup extensions
(eval-after-load 'ido '(require 'setup-ido))
(eval-after-load 'grep '(require 'setup-rgrep))
(require 'setup-hippie)
(require 'key-chord)
(key-chord-mode 1)

;; Font lock dash.el
(eval-after-load "dash" '(dash-enable-font-lock))

;; Load stuff on demand
(autoload 'auto-complete-mode "auto-complete" nil t)

(require 'expand-region)
(require 'multiple-cursors)
(require 'visual-regexp)
(require 'change-inner)

;; ;; Don't use expand-region fast keys
(setq expand-region-fast-keys-enabled t)

;; ;; Show expand-region command used
(setq er--show-expansion-message t)

;; ;; Browse kill ring
(require 'browse-kill-ring)
(setq browse-kill-ring-quit-action 'save-and-restore)

;; Smart M-x is smart
(require 'smex)
(smex-initialize)

;; phi-search
(require 'phi-search)
(setq phi-search-limit           10000
      phi-search-case-sensitive  'guess) ;; You may also set “phi-search-case-sensitive” to ‘guess, to make phi-search case sensitive only when some upcase letters are in the query.


;; Setup key bindings
(require 'key-bindings)

;; Misc
;; (require 'my-misc)
(when is-mac (require 'mac))

;; gpg
;; (setenv "INSIDE_EMACS" (format "%s,comint" emacs-version))

;; ;; Elisp go-to-definition with M-. and back again with M-,
(autoload 'elisp-slime-nav-mode "elisp-slime-nav")
(add-hook 'emacs-lisp-mode-hook (lambda () (elisp-slime-nav-mode t) (eldoc-mode 1)))

;; Emacs server
(require 'server)
(unless (server-running-p)
  (server-start))

;; ;; Run at full power please
(put 'downcase-region 'disabled nil)
(put 'upcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)

;; Company mode everywhere
(add-hook 'after-init-hook 'global-company-mode)
(setq company-dabbrev-downcase nil)

;; Frame window size
(set-frame-parameter nil 'fullscreen 'fullboth)

;; xml indentation
(setq nxml-child-indent 4 nxml-attribute-indent 4)

;; indentation
(setq c-basic-offset 4)

;; Undo
(global-undo-tree-mode)
(setq undo-tree-auto-save-history t)
(setq undo-tree-history-directory-alist '(("." . "~/.emacs.d/undo")))

;; Set font
(set-frame-font "Andale Mono 12" nil t)

;; window numbering
(window-numbering-mode)

(add-to-list 'default-frame-alist '(fullscreen . fullboth)) 
