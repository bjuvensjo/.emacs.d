;;; git.el --- git functions

;;; Commentary:

;;; Code:

(require 's)


(defun patches-region ()
  (save-excursion
    (end-of-line)
    (let* ((backward-patch (search-backward "@patch" (point-min) t))
           (backward-def (search-backward-regexp "^def " (point-min) t))
           (start (if (or (not backward-patch) (not backward-def))
                      (point-min)
                    backward-def)))
      (list (progn (goto-char start)
                   (search-forward "@patch")
                   (- (match-beginning 0) 1))
            (progn (search-forward-regexp "^def ")
                   (- (match-beginning 0) 1))))))


;; (defun patch-params (region-string)
;;   "Return list of patch params named from @patch annotations in REGION-STRING."
;;   (->> region-string
;;        (s-replace "\n" "")
;;        (s-split "@patch")
;;        (seq-filter (lambda (x)
;;                      (not (string= "" x))))
;;        (seq-map (lambda (x)
;;                   (->> x
;;                        (s-trim)
;;                        (s-chop-prefix "(")
;;                        (s-chop-suffix ")"))))
;;        (seq-map (lambda (x)
;;                   (first (s-split "," x))))
;;        (seq-map (lambda (x)
;;                   (->> x
;;                        (s-split "\\.")
;;                        (last)
;;                        (first))))
;;        (seq-map (lambda (x)
;;                   (->> x
;;                        (s-replace-all '(("'" . "") ("\"" . "")))
;;                        (s-trim))))
;;        (seq-map (lambda (x)
;;                   (concat "mock_" x)))
;;        (reverse)))


(defun patch-params (region-string)
  "Return list of patch params named from @patch annotations in REGION-STRING."
  (->> region-string
       (s-replace "\n" "")
       (s-split "@patch")
       (seq-filter (lambda (x)
                     (not (string= "" x))))
       (seq-map (lambda (x)
                  (string-match "\\(['\"]\\)\\([^'\"]+\\)" x)
                  (match-string-no-properties 2 x)))
       (seq-map (lambda (x)
                  (->> x
                       (s-split "\\.")
                       (last)
                       (first))))
       (seq-map (lambda (x)
                  (concat "mock_" x)))
       (reverse)))


(ert-deftest test-patch-params ()
  (should (equal '("mock_unpack_delivery" "mock_get_to_redeploy" "mock_get_to_upgrade"
                   "mock_get_new_deploys" "mock_undeploy_apps" "mock_deploy_apps"
                   "mock_create_apache_configs" "mock_cleanup" "mock_verify_deploys")
                 (patch-params "@patch('condep.main.verify_deploys', autospec=verify_deploys)
@patch('condep.main.cleanup', autospec=cleanup)
@patch('condep.main.create_apache_configs', autospec=create_apache_configs)
@patch('condep.main.deploy_apps', autospec=deploy_apps)
@patch('condep.main.undeploy_apps', autospec=undeploy_apps)
@patch('condep.main.get_new_deploys', autospec=get_new_deploys)
@patch(
    'condep.main.get_to_upgrade',
    autospec=get_to_upgrade,
    return_value=['to_upgrade'])
@patch(
    'condep.main.get_to_redeploy',
    autospec=get_to_redeploy,
    return_value=['to_redeploy'])
@patch(
    'condep.main.unpack_delivery',
    autospec=unpack_delivery,
    return_value='unpacked')
"))))


(defun set-patch-params ()
  "Set Python patch params named from @patch annotations."
  (interactive)
  (save-excursion
    (let* ((region (patches-region))
           (params (string-join
                    (patch-params
                     (apply 'buffer-substring-no-properties region)) ", ")))
      (goto-char (second region))
      (search-forward "(")
      (left-char)
      (sp-kill-sexp)
      (insert (concat "(" params ")")))))


(provide 'python-patch)


;;; python-patch ends here
