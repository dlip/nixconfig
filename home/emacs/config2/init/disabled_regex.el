;;; init-regex --- regex settings


(use-package visual-regexp)
(use-package visual-regexp-steroids)

;; Make it easier to write re-builder
(require 're-builder)
(setq reb-re-syntax 'string)

(defvar my/re-builder-positions nil
  "Store point and region bounds before calling re-builder")
(advice-add 're-builder
            :before
            (defun my/re-builder-save-state (&rest _)
              "Save into `my/re-builder-positions' the point and region
positions before calling `re-builder'."
              (setq my/re-builder-positions
                    (cons (point)
                          (when (region-active-p)
                            (list (region-beginning)
                                  (region-end)))))))
(defun reb-replace-regexp (&optional delimited)
  "Run `query-replace-regexp' with the contents of re-builder. With
non-nil optional argument DELIMITED, only replace matches
surrounded by word boundaries."
`  (interactive "P")
  (reb-update-regexp)
  (let* ((re (reb-target-binding reb-regexp))
         (replacement (query-replace-read-to
                       re
                       (concat "Query replace"
                               (if current-prefix-arg
                                   (if (eq current-prefix-arg '-) " backward" " word")
                                 "")
                               " regexp"
                               (if (with-selected-window reb-target-window
                                     (region-active-p)) " in region" ""))
                       t))
         (pnt (car my/re-builder-positions))
         (beg (cadr my/re-builder-positions))
         (end (caddr my/re-builder-positions)))
    (with-selected-window reb-target-window
      (goto-char pnt) ; replace with (goto-char (match-beginning 0)) if you want
					; to control where in the buffer the replacement starts
					; with re-builder
      (setq my/re-builder-positions nil)
      (reb-quit)
      (query-replace-regexp re replacement delimited beg end))))
(define-key reb-mode-map (kbd "RET") #'reb-repiace-regexp)
(define-key reb-lisp-mode-map (kbd "RET") #'reb-replace-regexp)
(global-set-key (kbd "C-M-%") #'re-builder)

(provide 'init-regex)
;;; init-regex.el ends here
