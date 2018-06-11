(setenv "WORKON_HOME" "/Users/ei4577/Dropbox/venv")

(elpy-enable)

;; (add-hook 'before-save-hook #'elpy-autopep8-fix-code)
(setq elpy-rpc-backend "jedi")

(add-hook 'before-save-hook #'elpy-format-code)
(add-hook 'elpy-mode-hook
          (λ (add-hook 'after-save-hook (λ (elpy-test 1)) nil 'make-it-local)))

(setq elpy-test-runner 'elpy-test-pytest-runner)

;; (let ((virtualenv-workon-starts-python nil))
;;(virtualenv-workon "wildcat"))

(add-hook 'elpy-mode-hook #'smartparens-mode)

(defun elpy-goto-definition-or-rgrep ()
  "Go to the definition of the symbol at point, if found. Otherwise, run `elpy-rgrep-symbol'."
  (interactive)
  (ring-insert find-tag-marker-ring (point-marker))
  (condition-case nil (elpy-goto-definition)
    (error (elpy-rgrep-symbol
            (concat "\\(def\\|class\\)\s" (thing-at-point 'symbol) "(")))))

(define-key elpy-mode-map (kbd "M-.") 'elpy-goto-definition-or-rgrep)

(when (load "flycheck" t t)
  (setq elpy-modules (delq 'elpy-module-flymake elpy-modules))
  (add-hook 'elpy-mode-hook 'flycheck-mode))

(provide 'setup-elpy)
