;; I don't need to kill emacs that easily. The mnemonic is C-x REALLY QUIT
(keymap-global-set "C-x r q" #'save-buffers-kill-terminal)
(keymap-global-set "C-x C-c" #'delete-frame)

;; Completion that uses many different methods to find options.
(keymap-global-set "C-." #'hippie-expand-no-case-fold)
(keymap-global-set "C-:" #'hippie-expand-lines)
(keymap-global-set "C-," #'completion-at-point)

;; Misc functions
(require 'misc)
(keymap-global-set "M-s-<up>" #'copy-from-above-command)
(keymap-global-set "M-s-<down>" (λ (forward-line 1) (open-line 1) (copy-from-above-command)))
(keymap-global-set "M-s-<right>" (λ (copy-from-above-command 1)))
(keymap-global-set "M-s-<left>" (λ (copy-from-above-command -1) (forward-char -1) (delete-char -1)))

;; Zap to char
(keymap-global-set "M-z" #'zap-up-to-char)
(keymap-global-set "s-z" (lambda (char) (interactive "cZap up to char backwards: ") (zap-up-to-char -1 char)))
(keymap-global-set "M-Z" (lambda (char) (interactive "cZap to char: ") (zap-to-char 1 char)))
(keymap-global-set "s-Z" (lambda (char) (interactive "cZap to char backwards: ") (zap-to-char -1 char)))

;; Smart M-x
(keymap-global-set "M-x" #'smex)
(keymap-global-set "M-X" #'smex-major-mode-commands)
(keymap-global-set "C-c C-c M-x" #'execute-extended-command)

;; Use C-x C-m to do M-x per Steve Yegge's advice
(keymap-global-set "C-x C-m" #'smex)

;; Expand region (increases selected region by semantic units)
(keymap-global-set (if is-mac "C-+" "C-'") #'er/expand-region)

;; Mark additional regions matching current region
(keymap-global-set "M-ä" #'mc/mark-all-dwim)
(keymap-global-set "C-å" #'mc/mark-previous-like-this)
(keymap-global-set "C-ä" #'mc/mark-next-like-this)
(keymap-global-set "C-Ä" #'mc/mark-more-like-this-extended)
(keymap-global-set "M-å" #'mc/mark-all-in-region)

;; Set anchor to start rectangular-region-mode
(keymap-global-set "H-SPC" #'set-rectangular-region-anchor)

(keymap-global-set "C-x r t" #'mc/edit-lines)

;; Quickly jump in document with avy
(key-chord-define-global "ss" #'avy-goto-char)
(key-chord-define-global "SS" #'avy-pop-mark)
(keymap-global-set "C-ö" #'avy-goto-char)
(keymap-global-set "C-Ö" #'avy-pop-mark)

;; Perform general cleanup
(keymap-global-set "C-c n" #'cleanup-buffer)
(keymap-global-set "C-c C-n" #'cleanup-buffer)
(keymap-global-set "C-c C-<return>" #'delete-blank-lines)
;; Delete all blank lines
(key-chord-define-global "DD" (λ (flush-lines "^$" (point-min) (point-max))))
(key-chord-define-global "ZZ" 'mbj/delete-line)
(key-chord-define-global "gg" 'beginning-of-buffer)
(key-chord-define-global "GG" 'end-of-buffer)
(key-chord-define-global "yy" (λ (kill-new (buffer-substring-no-properties (line-beginning-position) (line-beginning-position 2)))))

;; M-i for back-to-indentation
(keymap-global-set "M-i" #'back-to-indentation)

;; Transpose stuff with M-t
;; (keymap-global-unset "M-t") ;; which used to be transpose-words
;; (keymap-global-set "M-t l" #'transpose-lines)
;; (keymap-global-set "M-t w" #'transpose-words)
;; (keymap-global-set "M-t s" #'transpose-sexps)
;; (keymap-global-set "M-t p" #'transpose-params)

;; Change word separators
(keymap-global-unset "C-x +") ;; used to be balance-windows
;; (keymap-global-set "C-x -" (λ (replace-region-by #'s-dashed-words)))
(keymap-global-set "C-x _" (λ (replace-region-by #'s-snake-case)))
(keymap-global-set "C-x c" (λ (replace-region-by #'s-lower-camel-case)))
(keymap-global-set "C-x C" (λ (replace-region-by #'s-upper-camel-case)))

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

(keymap-global-set "C-x ."
                   (lambda ()
                     (interactive)
                     (replace-region-by #'my/underscores-to-dots-but-last-per-line)))

;; Killing text
(keymap-global-set "C-w" #'kill-region-or-backward-word)
(keymap-global-set "C-c C-w" #'kill-to-beginning-of-line)

;; Use M-w for copy-line if no active region
(keymap-global-set "M-w" #'save-region-or-current-line)
(keymap-global-set "s-w" #'save-region-or-current-line)
(keymap-global-set "M-W" (λ (save-region-or-current-line 1)))

;; vim's ci and co commands
(keymap-global-set "M-I" #'change-inner)
(keymap-global-set "M-O" #'change-outer)

(keymap-global-set "s-i" #'copy-inner)
(keymap-global-set "s-o" #'copy-outer)

;; Create new frame
(keymap-global-set "C-x C-n" #'make-frame-command)

;; Jump to a definition in the current file. (This is awesome)
(keymap-global-set "C-x C-i" #'ido-imenu)

;; File finding
(keymap-global-set "C-x M-f" #'ido-find-file-other-window)
(keymap-global-set "C-x f" #'recentf-ido-find-file)
(keymap-global-set "C-x C-p" #'find-or-create-file-at-point)
(keymap-global-set "C-x M-p" #'find-or-create-file-at-point-other-window)
(keymap-global-set "C-c r" #'revert-buffer)
(keymap-global-set "C-x C-b" #'ibuffer)

;; toggle two most recent buffers
(fset 'quick-switch-buffer [?\C-x ?b return])
(keymap-global-set "C-z" #'quick-switch-buffer)

;; Window switching
(keymap-global-set "C-x -" #'toggle-window-split)
(keymap-global-set "C-x C--" #'rotate-windows)
(keymap-global-set "C-x C-+" #'mbj/zoom-frame)

(keymap-global-set "C-x 3" #'split-window-right-and-move-there-dammit)

;; Help should search more than just commands
(keymap-global-set "<f1> a" #'apropos)

;; Should be able to eval-and-replace anywhere.
(keymap-global-set "C-c C-e" #'eval-and-replace)

;; Navigation bindings
(global-set-key [remap goto-line] #'goto-line-with-feedback)

;; jump-char - like f in Vimq
;; (keymap-global-set "M-m" #'jump-char-forward)
;; (keymap-global-set "M-M" #'jump-char-backward)
;; (keymap-global-set "s-m" #'jump-char-backward)

;; Define some keychords
;; (key-chord-define-global "fg" #'jump-char-forward)
;; (key-chord-define-global "df" #'jump-char-backward)
(key-chord-define-global ";;" "\C-e;")
(key-chord-define-global ",." "{}\C-b")
(key-chord-define-global ".-" "[]\C-b")
(key-chord-define-global "\'\'" "''\C-b")
(key-chord-define-global "\"\"" "\"\"\C-b")
(key-chord-define-global "--" " = ")
(key-chord-define-global "qq" (λ (kill-buffer (buffer-name))))

;; Completion at point
(keymap-global-set "C-<tab>" #'completion-at-point)

;; Visual regexp
(keymap-global-set "M-#" #'vr/query-replace)
(keymap-global-set "M-/" #'vr/replace)

;; Comment/uncomment block
(keymap-global-set "C-c c" #'comment-or-uncomment-region)
(keymap-global-set "C-c u" #'uncomment-region)

;; Eval buffer
(keymap-global-set "C-c C-k" #'eval-buffer)

;; Create scratch buffer
(keymap-global-set "C-c b" #'mbj/create-file-visiting-scratch-buffer)
(keymap-global-set "C-c B" #'mbj/delete-file-visiting-scratch-buffers)

;; Move windows, even in org-mode
(keymap-global-set "s-<right>" #'windmove-right)
(keymap-global-set "s-<left>"  #'windmove-left)
(keymap-global-set "s-<up>"    #'windmove-up)
(keymap-global-set "s-<down>"  #'windmove-down)

;; Resize window
(keymap-global-set "S-s-<down>"  #'shrink-window)
(keymap-global-set "S-s-<up>"    #'enlarge-window)
(keymap-global-set "S-s-<left>"  #'shrink-window-horizontally)
(keymap-global-set "S-s-<right>" #'enlarge-window-horizontally)

;; Clever newlines
(keymap-global-set "C-o" #'open-line-and-indent)
(keymap-global-set "C-<return>" #'open-line-below)
(keymap-global-set "C-S-<return>" #'open-line-above)
(keymap-global-set "M-<return>" #'new-line-dwim)

;; Duplicate region
(keymap-global-set "C-c d" #'duplicate-current-line-or-region)

;; Line movement
(keymap-global-set "C-S-<down>" #'move-text-down)
(keymap-global-set "C-S-<up>" #'move-text-up)

;; Browse the kill ring
(keymap-global-set "C-x C-y" #'browse-kill-ring)

;; Buffer file functions
(keymap-global-set "C-x C-r" #'rename-current-buffer-file)

;; Toggle frame fullscreen
(keymap-global-set "H-f" #'toggle-frame-fullscreen)

;; Switch themes
(keymap-global-set "C-<f7>" #'use-default-theme)
(keymap-global-set "C-<f9>" #'use-night-owl-theme)

;; Display and edit occurances of regexp in buffer
(keymap-global-set "C-c o" #'occur)

;; Find files by name and display results in dired
(keymap-global-set "M-s-f" #'find-name-dired)

;; phi-search
(keymap-global-set "C-s" #'phi-search)
(keymap-global-set "C-r" #'phi-search-backward)

;; Sort and delete duplicate lines in buffer"
(keymap-global-set "<f9>" #'mbj/sort-and-delete-duplicate-lines)

;; Run current file
(keymap-global-set "<f7>" #'mbj/run-current-file)

;; Toggle window dedicated
(keymap-global-set "C-c t" #'mbj/toggle-window-dedicated)

;; Downcase and upcase
(keymap-global-set "H-d" #'mbj/downcase-char-at-point)
(keymap-global-set "H-u" #'mbj/upcase-char-at-point)

;; Copy file path
(keymap-global-set "C-c p" #'mbj/copy-full-path-to-kill-ring)

;; Kill other buffers
(keymap-global-set "C-c C-o" #'mbj/kill-other-buffers)

;; Kill current buffer
(keymap-global-set "H-k" (λ (kill-buffer (buffer-name))))

;; Open terminal
(keymap-global-set "C-x t"
                   (λ (shell-command "open -a /Applications/kitty.app/Contents/MacOS/kitty .")))

(add-hook
 'dired-mode-hook
 (lambda ()
   (define-key dired-mode-map (kbd "ö") #'dired-up-directory)))

(add-hook
 'emacs-lisp-mode-hook
 (lambda ()
   (define-key emacs-lisp-mode-map (kbd "C-c C-k") #'mbj/ert-t)))

(provide 'setup-key-bindings)
