;;; init-misc --- misc settings

(setq inhibit-startup-message t)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar
(show-paren-mode 1)

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(load-theme 'doom-one t)

(cua-mode)

(set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 120)
(set-face-attribute 'variable-pitch nil :family "Noto Sans" :height 150)

;; Emoji: 😄 🤦 🏴
(set-fontset-font t 'symbol "Apple Color Emoji")
(set-fontset-font t 'symbol "Noto Color Emoji" nil 'append)
(set-fontset-font t 'symbol "Segoe UI Emoji" nil 'append)
(set-fontset-font t 'symbol "Symbola" nil 'append)

(doom-modeline-mode 1)

(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
  (setq projectile-enable-caching t)
  (setq projectile-project-search-path '("~/code/"))
  (setq magit-revision-show-gravatars t)
  (projectile-mode 1))


(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; (persp-mode 1)
;; (persp-mode-projectile-bridge-mode 1)
(setq auto-save-file-name-transforms
      `((".*" "/tmp/" t)))

(global-set-key (kbd "C-`") 'iflipb-next-buffer)
(global-set-key
 (if (featurep 'xemacs) (kbd "C-`") (kbd "C-~"))
 'iflipb-previous-buffer)

(defun switch-to-last-buffer ()
  (interactive)
  (switch-to-buffer nil))

(global-set-key (kbd "C-<tab>") 'switch-to-last-buffer)
(global-set-key (kbd "C-c C-w") 'kill-current-buffer)
;; save open buffers
(desktop-save-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)
;; Autosave on focus lost
(defun save-all ()
  (interactive)
  (save-some-buffers t))

(add-hook 'focus-out-hook 'save-all)
(global-set-key (kbd "C-S-M-b") 'consult-buffer)
(global-set-key (kbd "C-S-M-f") 'projectile-find-file)
(global-set-key (kbd "C-S-M-g") 'magit-status)
(global-set-key (kbd "C-S-M-r") 'consult-ripgrep)
(global-set-key (kbd "C-S-M-s") 'save-buffer)
(global-set-key (kbd "C-S-M-v") 'projectile-run-vterm)
(global-set-key (kbd "C-S-M-w") 'kill-this-buffer)

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(global-flycheck-mode)

(use-package wgrep
  :init (setq wgrep-auto-save-buffer t
	      wgrep-enable-key "E"))

(use-package nov
  :hook
  (nov-mode . visual-line-mode)
  (nov-mode . visual-fill-column-mode)
  :config
  (setq nov-text-width t)
  (setq visual-fill-column-center-text t)
  :mode ("\\.epub\\'" . nov-mode))

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
  (interactive "P")
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
(define-key reb-mode-map (kbd "RET") #'reb-replace-regexp)
(define-key reb-lisp-mode-map (kbd "RET") #'reb-replace-regexp)
(global-set-key (kbd "C-M-%") #'re-builder)

(provide 'init-misc)
;;; init-misc.el ends here
