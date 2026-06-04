;;; editing-defuns.el --- Basic text editing defuns -*- lexical-binding: t; -*-

(defun open-line-below ()
  (interactive)
  (end-of-line)
  (newline)
  (indent-for-tab-command))

(defun open-line-above ()
  (interactive)
  (beginning-of-line)
  (newline)
  (forward-line -1)
  (indent-for-tab-command))

(defun new-line-dwim ()
  (interactive)
  (let ((break-open-pair (or (and (looking-back "{" 1) (looking-at "}"))
                             (and (looking-back ">" 1) (looking-at "<"))
                             (and (looking-back "(" 1) (looking-at ")"))
                             (and (looking-back "\\[" 1) (looking-at "\\]")))))
    (newline)
    (when break-open-pair
      (save-excursion
        (newline)
        (indent-for-tab-command)))
    (indent-for-tab-command)))

(defun duplicate-current-line-or-region (arg)
  "Duplicates the current line or region ARG times.
If there's no region, the current line will be duplicated."
  (interactive "p")
  (if (region-active-p)
      (let ((beg (region-beginning))
            (end (region-end)))
        (duplicate-region arg beg end)
        (one-shot-keybinding "d" (λ (duplicate-region 1 beg end))))
    (duplicate-current-line arg)
    (one-shot-keybinding "d" 'duplicate-current-line)))

(defun one-shot-keybinding (key command)
  (set-temporary-overlay-map
   (let ((map (make-sparse-keymap)))
     (define-key map (kbd key) command)
     map) t))

(defun replace-region-by (fn)
  (let* ((beg (region-beginning))
         (end (region-end))
         (contents (buffer-substring beg end)))
    (delete-region beg end)
    (insert (funcall fn contents))))

(defun duplicate-region (&optional num start end)
  "Duplicates the region bounded by START and END NUM times.
If no START and END is provided, the current region-beginning and
region-end is used."
  (interactive "p")
  (save-excursion
    (let* ((start (or start (region-beginning)))
           (end (or end (region-end)))
           (region (buffer-substring start end)))
      (goto-char end)
      (dotimes (i num)
        (insert region)))))

(defun paredit-duplicate-current-line ()
  (back-to-indentation)
  (let (kill-ring kill-ring-yank-pointer)
    (paredit-kill)
    (yank)
    (newline-and-indent)
    (yank)))

(defun duplicate-current-line (&optional num)
  "Duplicate the current line NUM times."
  (interactive "p")
  (if (bound-and-true-p paredit-mode)
      (paredit-duplicate-current-line)
    (save-excursion
      (when (eq (line-end-position) (point-max))
        (goto-char (point-max))
        (newline)
        (forward-char -1))
      (duplicate-region num (line-beginning-position) (1+ (line-end-position))))))

;; automatically indenting yanked text if in programming-modes

(require 'dash)

(defvar yank-indent-modes '(prog-mode
                            sgml-mode
                            js2-mode)
  "Modes in which to indent regions that are yanked (or yank-popped)")

(defvar yank-advised-indent-threshold 1000
  "Threshold (# chars) over which indentation does not automatically occur.")

(defun yank-advised-indent-function (beg end)
  "Do indentation, as long as the region isn't too large."
  (if (<= (- end beg) yank-advised-indent-threshold)
      (indent-region beg end nil)))

(advice-add 'yank :after
  (lambda (&optional arg &rest _)
    (when (and (not arg)
               (--any? (derived-mode-p it) yank-indent-modes))
      (let ((transient-mark-mode nil))
        (yank-advised-indent-function (region-beginning) (region-end))))))

(advice-add 'yank-pop :after
  (lambda (&optional arg &rest _)
    (when (and (not arg)
               (member major-mode yank-indent-modes))
      (let ((transient-mark-mode nil))
        (yank-advised-indent-function (region-beginning) (region-end))))))

;; kill region if active, otherwise kill backward word

(defun kill-region-or-backward-word ()
  (interactive)
  (if (region-active-p)
      (kill-region (region-beginning) (region-end))
    (backward-kill-word 1)))

(defun kill-to-beginning-of-line ()
  (interactive)
  (kill-region (save-excursion (beginning-of-line) (point))
               (point)))

;; copy region if active
;; otherwise copy to end of current line
;;   * with prefix, copy N whole lines

(defun copy-to-end-of-line ()
  (interactive)
  (kill-ring-save (point)
                  (line-end-position))
  (message "Copied to end of line"))

(defun copy-whole-lines (arg)
  "Copy lines (as many as prefix argument) in the kill ring"
  (interactive "p")
  (kill-ring-save (line-beginning-position)
                  (line-beginning-position (+ 1 arg)))
  (message "%d line%s copied" arg (if (= 1 arg) "" "s")))

(defun copy-line (arg)
  "Copy to end of line, or as many lines as prefix argument"
  (interactive "P")
  (if (null arg)
      (copy-to-end-of-line)
    (copy-whole-lines (prefix-numeric-value arg))))

(defun save-region-or-current-line (arg)
  (interactive "P")
  (if (region-active-p)
      (kill-ring-save (region-beginning) (region-end))
    (copy-line arg)))

(autoload 'zap-up-to-char "misc"
  "Kill up to, but not including ARGth occurrence of CHAR.")

