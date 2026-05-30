;; I don't need to kill emacs that easily
;; the mnemonic is C-x REALLY QUIT
(global-set-key (kbd "C-x r q") 'save-buffers-kill-terminal)
(global-set-key (kbd "C-x C-c") 'delete-frame)

;; Completion that uses many different methods to find options.
(global-set-key (kbd "C-.") 'hippie-expand-no-case-fold)
(global-set-key (kbd "C-:") 'hippie-expand-lines)
(global-set-key (kbd "C-,") 'completion-at-point)

;; Misc functions
(require 'misc)
(global-set-key (kbd "M-s-<up>") 'copy-from-above-command)
(global-set-key (kbd "M-s-<down>") (λ (forward-line 1) (open-line 1) (copy-from-above-command)))
(global-set-key (kbd "M-s-<right>") (λ (copy-from-above-command 1)))
(global-set-key (kbd "M-s-<left>") (λ (copy-from-above-command -1) (forward-char -1) (delete-char -1)))

;; Zap to char
(global-set-key (kbd "M-z") 'zap-up-to-char)
(global-set-key (kbd "s-z") (lambda (char) (interactive "cZap up to char backwards: ") (zap-up-to-char -1 char)))
(global-set-key (kbd "M-Z") (lambda (char) (interactive "cZap to char: ") (zap-to-char 1 char)))
(global-set-key (kbd "s-Z") (lambda (char) (interactive "cZap to char backwards: ") (zap-to-char -1 char)))

;; Smart M-x
(global-set-key (kbd "M-x") 'smex)
(global-set-key (kbd "M-X") 'smex-major-mode-commands)
(global-set-key (kbd "C-c C-c M-x") 'execute-extended-command)

;; Use C-x C-m to do M-x per Steve Yegge's advice
(global-set-key (kbd "C-x C-m") 'smex)

;; Expand region (increases selected region by semantic units)
(global-set-key (if is-mac (kbd "C-+") (kbd "C-'")) 'er/expand-region)

;; Experimental multiple-cursors
(global-set-key (kbd "C-S-c C-S-c") 'mc/edit-lines)
(global-set-key (kbd "C-S-c C-e") 'mc/edit-ends-of-lines)
(global-set-key (kbd "C-S-c C-a") 'mc/edit-beginnings-of-lines)

;; Mark additional regions matching current region
(global-set-key (kbd "M-ä") 'mc/mark-all-dwim)
(global-set-key (kbd "C-å") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-ä") 'mc/mark-next-like-this)
(global-set-key (kbd "C-Ä") 'mc/mark-more-like-this-extended)
(global-set-key (kbd "M-å") 'mc/mark-all-in-region)

;; Set anchor to start rectangular-region-mode
(global-set-key (kbd "H-SPC") 'set-rectangular-region-anchor)

;; Replace rectangle-text with inline-string-rectangle
(global-set-key (kbd "C-x r t") 'mc/edit-lines)

;; ;; Quickly jump in document with avy
(key-chord-define-global "ss" 'avy-goto-char)
(key-chord-define-global "SS" 'avy-pop-mark)
(global-set-key (kbd "C-ö") 'avy-goto-char)
(global-set-key (kbd "C-Ö") 'avy-pop-mark)


;; ;; Perform general cleanup
(global-set-key (kbd "C-c n") 'cleanup-buffer)
(global-set-key (kbd "C-c C-n") 'cleanup-buffer)
(global-set-key (kbd "C-c C-<return>") 'delete-blank-lines)
;; Delete all blank lines
(key-chord-define-global "DD" (λ (flush-lines "^$" (point-min) (point-max))))
(key-chord-define-global "ZZ" 'delete-line)

;; M-i for back-to-indentation
(global-set-key (kbd "M-i") 'back-to-indentation)

;; ;; Transpose stuff with M-t
;; (global-unset-key (kbd "M-t")) ;; which used to be transpose-words
;; (global-set-key (kbd "M-t l") 'transpose-lines)
;; (global-set-key (kbd "M-t w") 'transpose-words)
;; (global-set-key (kbd "M-t s") 'transpose-sexps)
;; (global-set-key (kbd "M-t p") 'transpose-params)

;; Change word separators
(global-unset-key (kbd "C-x +")) ;; used to be balance-windows
;; (global-set-key (kbd "C-x -") (λ (replace-region-by 's-dashed-words)))
(global-set-key (kbd "C-x _") (λ (replace-region-by 's-snake-case)))
(global-set-key (kbd "C-x c") (λ (replace-region-by 's-lower-camel-case)))
(global-set-key (kbd "C-x C") (λ (replace-region-by 's-upper-camel-case)))
(defun my/underscores-to-dots-but-last-line (line)
  (if (string-match "_[^_]*\\'" line)
      (let ((i (match-beginning 0)))
        (concat
         (replace-regexp-in-string "_" "." (substring line 0 i) t t)
         (substring line i)))
    line))

(defun my/underscores-to-dots-but-last-per-line (s)
  (let* ((ends-with-newline (string-suffix-p "\n" s))
         (lines (split-string s "\n" nil))
         (result (mapconcat #'my/underscores-to-dots-but-last-line lines "\n")))
    (if ends-with-newline
        (concat result "\n")
      result)))

(global-set-key (kbd "C-x .")
                (lambda ()
                  (interactive)
                  (replace-region-by #'my/underscores-to-dots-but-last-per-line)))


;; Killing text
;; (global-set-key (kbd "C-S-k") 'kill-and-retry-line)
(global-set-key (kbd "C-w") 'kill-region-or-backward-word)
(global-set-key (kbd "C-c C-w") 'kill-to-beginning-of-line)

;; ;; Use M-w for copy-line if no active region
(global-set-key (kbd "M-w") 'save-region-or-current-line)
(global-set-key (kbd "s-w") 'save-region-or-current-line)
(global-set-key (kbd "M-W") (λ (save-region-or-current-line 1)))

;; ;; Make shell more convenient, and suspend-frame less
;; (global-set-key (kbd "C-z") 'shell)
(global-set-key (kbd "C-x M-z") 'suspend-frame)

;; ;; vim's ci and co commands
(global-set-key (kbd "M-I") 'change-inner)
(global-set-key (kbd "M-O") 'change-outer)

(global-set-key (kbd "s-i") 'copy-inner)
(global-set-key (kbd "s-o") 'copy-outer)

;; ;; Create new frame
(define-key global-map (kbd "C-x C-n") 'make-frame-command)

;; ;; Jump to a definition in the current file. (This is awesome)
(global-set-key (kbd "C-x C-i") 'ido-imenu)

;; ;; File finding
(global-set-key (kbd "C-x M-f") 'ido-find-file-other-window)
(global-set-key (kbd "C-x f") 'recentf-ido-find-file)
(global-set-key (kbd "C-x C-p") 'find-or-create-file-at-point)
(global-set-key (kbd "C-x M-p") 'find-or-create-file-at-point-other-window)
;; (global-set-key (kbd "C-c y") 'bury-buffer)
(global-set-key (kbd "C-c r") 'revert-buffer)
;; (global-set-key (kbd "M-`") 'file-cache-minibuffer-complete)
(global-set-key (kbd "C-x C-b") 'ibuffer)

;; ;; toggle two most recent buffers
(fset 'quick-switch-buffer [?\C-x ?b return])
(global-set-key (kbd "C-z") 'quick-switch-buffer)

;; Revert without any fuss
(global-set-key (kbd "M-<escape>") (λ (revert-buffer t t)))

;; ;; Edit file with sudo
;; (global-set-key (kbd "M-s e") 'sudo-edit)

;; ;; Window switching
;; (windmove-default-keybindings) ;; Shift+direction
(global-set-key (kbd "C-x -") 'toggle-window-split)
(global-set-key (kbd "C-x C--") 'rotate-windows)
(global-unset-key (kbd "C-x C-+")) ;; don't zoom like this
(global-set-key (kbd "C-x C-+") 'zoom-in/out)

(global-set-key (kbd "C-x 3") 'split-window-right-and-move-there-dammit)

;; Help should search more than just commands
(global-set-key (kbd "<f1> a") 'apropos)

;; ;; Should be able to eval-and-replace anywhere.
(global-set-key (kbd "C-c C-e") 'eval-and-replace)
(global-set-key (kbd "M-s-e") 'eval-and-replace)

;; ;; Navigation bindings
(global-set-key [remap goto-line] 'goto-line-with-feedback)

;; jump-char - like f in Vim
(global-set-key (kbd "M-m") 'jump-char-forward)
(global-set-key (kbd "M-M") 'jump-char-backward)
(global-set-key (kbd "s-m") 'jump-char-backward)

;; Define some keychords
(key-chord-define-global "fg" 'jump-char-forward)
(key-chord-define-global "df" 'jump-char-backward)
(key-chord-define-global ";;" "\C-e;")
(key-chord-define-global ",." "{}\C-b")
(key-chord-define-global ".-" "[]\C-b")
(key-chord-define-global "\'\'" "''\C-b")
(key-chord-define-global "\"\"" "\"\"\C-b")
(key-chord-define-global "--" " = ")
(key-chord-define-global "qq" (λ (kill-buffer (buffer-name))))


;; Completion at point
(global-set-key (kbd "C-<tab>") 'completion-at-point)

;; Visual regexp
;; (define-key global-map (kbd "M-&") 'vr/query-replace)
(define-key global-map (kbd "M-#") 'vr/query-replace)
(define-key global-map (kbd "M-/") 'vr/replace)

;; Comment/uncomment block
(global-set-key (kbd "C-c c") 'comment-or-uncomment-region)
(global-set-key (kbd "C-c u") 'uncomment-region)

;; Eval buffer
(global-set-key (kbd "C-c C-k") 'eval-buffer)

;; Create scratch buffer
;; (global-set-key (kbd "C-c b") 'create-scratch-buffer)
(global-set-key (kbd "C-c b") 'create-file-visiting-scratch-buffer)
(global-set-key (kbd "C-c B") 'delete-file-visiting-scratch-buffers)

;; Move windows, even in org-mode
(global-set-key (kbd "<s-right>") 'windmove-right)
(global-set-key (kbd "<s-left>") 'windmove-left)
(global-set-key (kbd "<s-up>") 'windmove-up)
(global-set-key (kbd "<s-down>") 'windmove-down)

;; Resize window
(global-set-key (kbd "<S-s-down>") 'shrink-window)
(global-set-key (kbd "<S-s-up>") 'enlarge-window)
(global-set-key (kbd "<S-s-left>") 'shrink-window-horizontally)
(global-set-key (kbd "<S-s-right>") 'enlarge-window-horizontally)

;; Magit
(global-set-key (kbd "C-x m") 'magit-status-fullscreen)
(autoload 'magit-status-fullscreen "magit")

;; Clever newlines
(global-set-key (kbd "C-o") 'open-line-and-indent)
(global-set-key (kbd "<C-return>") 'open-line-below)
(global-set-key (kbd "<C-S-return>") 'open-line-above)
(global-set-key (kbd "<M-return>") 'new-line-dwim)

;; Duplicate region
(global-set-key (kbd "C-c d") 'duplicate-current-line-or-region)

;; Line movement
(global-set-key (kbd "<C-S-down>") 'move-text-down)
(global-set-key (kbd "<C-S-up>") 'move-text-up)

;; ;; Browse the kill ring
(global-set-key (kbd "C-x C-y") 'browse-kill-ring)

;; Buffer file functions
;; (global-set-key (kbd "C-x t") 'touch-buffer-file)
(global-set-key (kbd "C-x C-r") 'rename-current-buffer-file)
;; (global-set-key (kbd "C-x C-k") 'delete-current-buffer-file)

;; Easy-mode fullscreen rgrep
(global-set-key (kbd "M-g s") 'git-grep-fullscreen)
(global-set-key (kbd "M-g S") 'rgrep-fullscreen)

;; ;; Toggle frame fullscreen
(global-set-key (kbd "H-f") 'toggle-frame-fullscreen)

;; ;; Multi-occur
;; (global-set-key (kbd "M-s m") 'multi-occur)
;; (global-set-key (kbd "M-s M") 'multi-occur-in-matching-buffers)

;; ;; Display and edit occurances of regexp in buffer
(global-set-key (kbd "C-c o") 'occur)

;; Find files by name and display results in dired
(global-set-key (kbd "M-s-f") 'find-name-dired)

;; ;; Find file in project
(global-set-key (kbd "C-x o") 'find-file-in-project)

;; phi-search
(global-set-key (kbd "C-s") 'phi-search)
(global-set-key (kbd "C-r") 'phi-search-backward)

;; Sort and delete duplicate lines in buffer"
(global-set-key (kbd "<f9>") 'sort-and-delete-duplicate-lines)

;; Run current file
(global-set-key (kbd "<f7>") 'run-current-file)

;; Toggle window dedicated
(global-set-key (kbd "C-c t") 'toggle-window-dedicated)

;; Downcase and upcase
(global-set-key (kbd "H-d") 'mbj/downcase-char-at-point)
(global-set-key (kbd "H-u") 'mbj/upcase-char-at-point)

;; Copy file path
(global-set-key (kbd "C-c p") 'copy-full-path-to-kill-ring)

;; Kill other buffers
(global-set-key (kbd "C-c C-o") 'kill-other-buffers)

;; Kill current buffer
(global-set-key (kbd "H-k") (λ (kill-buffer (buffer-name))))

;; Open terminal
(global-set-key (kbd "C-x t") (λ (shell-command "open -a /Applications/kitty.app/Contents/MacOS/kitty .")))

;; Flycheck
(define-key flycheck-mode-map (kbd "C-c f l") #'flycheck-list-errors)
(define-key flycheck-mode-map (kbd "C-c f n") #'flycheck-next-error)
(define-key flycheck-mode-map (kbd "C-c f p") #'flycheck-previous-error)

(add-hook
 'dired-mode-hook
 (lambda ()
   (define-key dired-mode-map (kbd "ö") 'dired-up-directory)))

(add-hook
 'emacs-lisp-mode-hook
 (lambda ()
   (define-key emacs-lisp-mode-map (kbd "C-c C-k") 'ert-t)))

(provide 'key-bindings)
