


;; Dired
;; (defun dired-up-directory-same-buffer ()
;;   "Go up in the same buffer."
;;   (find-alternate-file ".."))

;; (defun my-dired-mode-hook ()
;;   (put 'dired-find-alternate-file 'disabled nil) ; Disables the warning.
;;   (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
;;   (define-key dired-mode-map (kbd "^") 'dired-up-directory-same-buffer))

;; (add-hook 'dired-mode-hook #'my-dired-mode-hook)

;; (setq dired-use-ls-dired nil)

(defun dired-toggle-mark (arg)
  "Toggle the current (or next ARG) files."
  ;; S.Namba Sat Aug 10 12:20:36 1996
  (interactive "P")
  (let ((dired-marker-char
         (if (save-excursion (beginning-of-line)
                             (looking-at " "))
             dired-marker-char ?\040)))
    (dired-mark arg)
    (dired-previous-line 1)))

(use-package dired
  :config
  (bind-keys :map dired-mode-map
             ("h" . dired-hide-details-mode)
             ("C-c C-d" . dired-hide-details-mode))
  (setq dired-recursive-deletes 'always)
  (setq dired-recursive-copies  'always)
  (use-package dired-aux
    :after dired
    :config
    (add-to-list 'dired-compress-file-suffixes
                 '(".zip" "unzip"))))