(require 'clojure-mode)
;; (require 'clojure-mode-extra-font-locking)
(require 'clj-refactor)

(setq cider-save-file-on-load t)

(setq cider-repl-pop-to-buffer-on-connect 'display-only)

;; (cljr-add-keybindings-with-modifier "C-s-")
;; (define-key clj-refactor-map (kbd "C-x C-r") 'cljr-rename-file)

;; (setq cider-pprint-fn 'pprint)

;; (require 'core-async-mode)

;; (defun enable-clojure-mode-stuff ()
;;   (clj-refactor-mode 1)
;;   (when (not (s-ends-with-p "/dev/user.clj" (buffer-file-name)))
;;     (core-async-mode 1)))

;; (add-hook 'clojure-mode-hook 'enable-clojure-mode-stuff)

;; (require 'symbol-focus)
;; (define-key clojure-mode-map (kbd "M-s-f") 'sf/focus-at-point)

;; (require 'cider)

;; (define-key cider-repl-mode-map (kbd "<home>") nil)
;; (define-key cider-repl-mode-map (kbd "C-,") 'complete-symbol)
;; (define-key cider-mode-map (kbd "C-,") 'complete-symbol)
;; (define-key cider-mode-map (kbd "C-c C-q") 'nrepl-close)
;; (define-key cider-mode-map (kbd "C-c C-Q") 'cider-quit)


;; ;; Don't warn me about the dangers of clj-refactor, fire the missiles!
;; (setq cljr-warn-on-eval nil)

;; ;; Use figwheel for cljs repl

;; (setq cider-cljs-lein-repl "(do (use 'figwheel-sidecar.repl-api) (start-figwheel!) (cljs-repl))")

;; ;; Enable error buffer popping also in the REPL:
;; (setq cider-repl-popup-stacktraces t)

;; ;; Pretty print results in repl
(setq cider-repl-use-pretty-printing t)

;; ;; Don't prompt for symbols
;; (setq cider-prompt-for-symbol nil)

;; ;; Enable eldoc in Clojure buffers
;; (add-hook 'cider-mode-hook #'eldoc-mode)

;; ;; Some expectations features

;; (require 'clj-autotest)

;; (defun my-toggle-expect-focused ()
;;   (interactive)
;;   (save-excursion
;;     (search-backward "(expect" (cljr--point-after 'cljr--goto-toplevel))
;;     (forward-word)
;;     (if (looking-at "-focused")
;;         (paredit-forward-kill-word)
;;       (insert "-focused"))))

;; (defun my-remove-all-focused ()
;;   (interactive)
;;   (save-excursion
;;     (goto-char (point-min))
;;     (while (search-forward "(expect-focused" nil t)
;;       (delete-char -8))))

;; (define-key clj-refactor-map
;;   (cljr--key-pairs-with-modifier "C-s-" "xf") 'my-toggle-expect-focused)

;; (define-key clj-refactor-map
;;   (cljr--key-pairs-with-modifier "C-s-" "xr") 'my-remove-all-focused)

;; ;; Cycle between () {} []

(defun live-delete-and-extract-sexp ()
  "Delete the sexp and return it."
  (interactive)
  (let* ((begin (point)))
    (forward-sexp)
    (let* ((result (buffer-substring-no-properties begin (point))))
      (delete-region begin (point))
      result)))

(defun live-cycle-clj-coll ()
  "convert the coll at (point) from (x) -> {x} -> [x] -> (x) recur"
  (interactive)
  (let* ((original-point (point)))
    (while (and (> (point) 1)
                (not (equal "(" (buffer-substring-no-properties (point) (+ 1 (point)))))
                (not (equal "{" (buffer-substring-no-properties (point) (+ 1 (point)))))
                (not (equal "[" (buffer-substring-no-properties (point) (+ 1 (point))))))
      (backward-char))
    (cond
     ((equal "(" (buffer-substring-no-properties (point) (+ 1 (point))))
      (insert "[" (substring (live-delete-and-extract-sexp) 1 -1) "]"))
     ((equal "{" (buffer-substring-no-properties (point) (+ 1 (point))))
      (insert "(" (substring (live-delete-and-extract-sexp) 1 -1) ")"))
     ((equal "[" (buffer-substring-no-properties (point) (+ 1 (point))))
      (insert "{" (substring (live-delete-and-extract-sexp) 1 -1) "}"))
     ((equal 1 (point))
      (message "beginning of file reached, this was probably a mistake.")))
    (goto-char original-point)))


(define-key clojure-mode-map (kbd "C-'") 'live-cycle-clj-coll)

;; ;; Warn about missing nREPL instead of doing stupid things

;; (defun nrepl-warn-when-not-connected ()
;;   (interactive)
;;   (message "Oops! You're not connected to an nREPL server. Please run M-x cider or M-x cider-jack-in to connect."))

;; (define-key clojure-mode-map (kbd "C-M-x")   'nrepl-warn-when-not-connected)
;; (define-key clojure-mode-map (kbd "C-x C-e") 'nrepl-warn-when-not-connected)
;; (define-key clojure-mode-map (kbd "C-c C-e") 'nrepl-warn-when-not-connected)
;; (define-key clojure-mode-map (kbd "C-c C-l") 'nrepl-warn-when-not-connected)
;; (define-key clojure-mode-map (kbd "C-c C-r") 'nrepl-warn-when-not-connected)
;; (define-key clojure-mode-map (kbd "C-c C-z") 'nrepl-warn-when-not-connected)
;; (define-key clojure-mode-map (kbd "C-c C-k") 'nrepl-warn-when-not-connected)
;; (define-key clojure-mode-map (kbd "C-c C-n") 'nrepl-warn-when-not-connected)
;; (define-key clojure-mode-map (kbd "C-c C-q") 'nrepl-warn-when-not-connected)

;; (setq cljr-magic-require-namespaces
;;       '(("io"   . "clojure.java.io")
;;         ("set"  . "clojure.set")
;;         ("str"  . "clojure.string")
;;         ("walk" . "clojure.walk")
;;         ("zip"  . "clojure.zip")
;;         ("time" . "clj-time.core")
;;         ("log"  . "clojure.tools.logging")
;;         ("json" . "cheshire.core")))

;; ;; refer all from expectations

;; (setq cljr-expectations-test-declaration "[expectations :refer :all]")

;; ;; Add requires to blank devcards files


;; ;; Set up linting of clojure code with eastwood

;; ;; Make sure to add [acyclic/squiggly-clojure "0.1.2-SNAPSHOT"]
;; ;; to your :user :dependencies in .lein/profiles.clj

;; (require 'flycheck-clojure)

;; (defun my-cider-mode-enable-flycheck ()
;;   ;; (when (and (s-ends-with-p ".clj" (buffer-file-name))
;;   ;;            (not (s-ends-with-p "/dev/user.clj" (buffer-file-name))))
;;   ;;   (flycheck-mode 1))
;;   )

;; (add-hook 'cider-mode-hook 'my-cider-mode-enable-flycheck)

;; (eval-after-load 'flycheck '(add-to-list 'flycheck-checkers 'clojure-cider-eastwood))

;; ;; Make q quit out of find-usages to previous window config

;; (defadvice cljr-find-usages (before setup-grep activate)
;;   (window-configuration-to-register ?$))

;; ;; ------------

;; ;; TODO: Loot more stuff from:
;; ;;  - https://github.com/overtone/emacs-live/blob/master/packs/dev/clojure-pack/config/paredit-conf.el

;; Convert all forms to vectors, i.e. ((((foo)))) to [[[[[foo]]]]]
(defun convert-all-forms-to-vectors ()
  (interactive)
  (save-excursion
    (er/expand-region 1)
    (let ((begin (region-beginning))
          (end (region-end)))
      (goto-char begin)
      (while (search-forward "(" end t)
        (goto-char (match-beginning 0))
        (clojure-convert-collection-to-vector)))))

(define-key clojure-mode-map (kbd "H-'") 'convert-all-forms-to-vectors)


(defun cider-load-buffer-and-test-project ()
  "Load buffer and run project tests."
  (interactive)
  (cider-load-buffer)
  (cider-test-run-project-tests))

(define-key clojure-mode-map (kbd "H-.") 'cider-load-buffer-and-test-project)

(cider-auto-test-mode 1)

(add-hook 'clojure-mode-hook (lambda ()
                               (clj-refactor-mode 1)
                               (yas-minor-mode 1) ; for adding require/use/import statements
                               (cljr-add-keybindings-with-prefix "C-c C-m")
                               ;; e.g. rename files with `C-c C-m rf`.
                               (setq cljr-warn-on-eval nil)
                               ))

(provide 'setup-clojure-mode)
        
