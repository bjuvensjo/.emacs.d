;;; my-misc.el --- Miscellaneous functions

;;; Commentary:

;;; Code:


;;; Text editing ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun mbj/downcase-char-at-point (n)
  "Downcase char at point N."
  (interactive "p")
  (dotimes (i (or n 1))
    (downcase-region (point) (progn (forward-char) (point)))))

(defun mbj/upcase-char-at-point (n)
  "Upcase char at point N."
  (interactive "p")
  (dotimes (i (or n 1))
    (upcase-region (point) (progn (forward-char) (point)))))

(defun mbj/delete-line ()
  "Deletes current line"
  (interactive)
  (save-excursion
    (delete-region (line-beginning-position) (min (+ 1 (line-end-position)) (buffer-end 1)))))


;;; Buffers and files ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun mbj/copy-full-path-to-kill-ring ()
  "Copy buffer's full path to kill ring."
  (interactive)
  (when buffer-file-name
    (message (buffer-file-name))
    (kill-new (file-truename buffer-file-name))))

(defun mbj/kill-other-buffers ()
  "Kill all other buffers."
  (interactive)
  (mapc 'kill-buffer (delq (current-buffer) (buffer-list)))
  (delete-other-windows))

(defvar file-visiting-scratch-buffer-dir (expand-file-name "fscratch" "~/.emacs.d"))
(defvar file-visiting-scratch-buffer-pattern "^fscratch[1-9]*$")

(defun mbj/create-file-visiting-scratch-buffer nil
  "Create a new file visiting scratch buffer to work in. (could be fscratch - fscratchX)"
  (interactive)
  (unless (file-directory-p file-visiting-scratch-buffer-dir)
    (make-directory file-visiting-scratch-buffer-dir))
  (let ((n (length (directory-files file-visiting-scratch-buffer-dir '() file-visiting-scratch-buffer-pattern)))
        filename)
    (while (progn
             (setq filename (concat "fscratch"
                                    (if (= n 0) "" (int-to-string n))))
             (setq n (1+ n))
             (get-buffer filename)))
    (find-file (expand-file-name filename file-visiting-scratch-buffer-dir))
    (text-mode)))

(defun mbj/delete-file-visiting-scratch-buffers nil
  "Delete all file visiting scratch buffers"
  (interactive)
  (let ((n (length (directory-files file-visiting-scratch-buffer-dir '() file-visiting-scratch-buffer-pattern)))
        filename)
    (if (yes-or-no-p "Kill and delete all file visiting scratch buffers? ")
        (progn
          (dolist (buffer (buffer-list))
            (if (string-match-p file-visiting-scratch-buffer-pattern (buffer-name buffer))
                (kill-buffer buffer)))
          (delete-directory file-visiting-scratch-buffer-dir t nil)
          (message "Deleted %s" file-visiting-scratch-buffer-dir)))))


;;; Frame ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun mbj/zoom-frame (steps)
  "Zoom selected frame font by STEPS × 10 units (positive = larger, negative = smaller).
After invoking, use +/= to zoom in, - to zoom out, 0 to reset."
  (interactive "p")
  (set-face-attribute 'default (selected-frame)
    :height (max 10 (+ (face-attribute 'default :height) (* steps 10))))
  (set-transient-map
    (let ((map (make-sparse-keymap)))
      (define-key map "+" (lambda () (interactive) (mbj/zoom-frame  1)))
      (define-key map "=" (lambda () (interactive) (mbj/zoom-frame  1)))
      (define-key map "-" (lambda () (interactive) (mbj/zoom-frame -1)))
      (define-key map "0" #'mbj/zoom-frame-reset)
      map)
    t))

(defun mbj/zoom-frame-reset ()
  "Reset selected frame font to the global default size."
  (interactive)
  (set-face-attribute 'default (selected-frame) :height 'unspecified))


;;; Dired ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Prompt once when deleting a directory tree, not for each subdirectory.
(defvar dired-recursive-deletes)
(setq dired-recursive-deletes 'always)


;;; macOS ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Open drag-and-drop files in the same frame rather than a new one.
(if (fboundp 'ns-find-file)
    (global-set-key [ns-drag-file] 'ns-find-file))
(setq ns-pop-up-frames nil)


;;; Testing ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun mbj/ert-t ()
  "Run ert t."
  (interactive)
  (ert t))

(provide 'my-misc)

;;; my-misc.el ends here
