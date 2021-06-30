;;; init-misc --- misc settings

(setq
   ;; No need to see GNU agitprop.
   inhibit-startup-screen t
   ;; No need to remind me what a scratch buffer is.
   initial-scratch-message nil
   ;; Double-spaces after periods is morally wrong.
   sentence-end-double-space nil
   ;; Never ding at me, ever.
   ring-bell-function 'ignore
   ;; Prompts should go in the minibuffer, not in a GUI.
   use-dialog-box nil
   ;; Fix undo in commands affecting the mark.
   mark-even-if-inactive nil
   ;; Let C-k delete the whole line.
   kill-whole-line t
   ;; search should be case-sensitive by default
   case-fold-search nil
   ;; no need to prompt for the read command _every_ time
   compilation-read-command nil
   ;; always scroll
   compilation-scroll-output t
   ;; my source directory
   default-directory "~/code/"
   )

(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar
(show-paren-mode 1)
(setq gc-cons-threshold 100000000) ; Set garbage collection threshold to 100mb

; Default to unicode
(set-charset-priority 'unicode)
(setq locale-coding-system 'utf-8)
(set-terminal-coding-system 'utf-8)
(set-keyboard-coding-system 'utf-8)
(set-selection-coding-system 'utf-8)
(prefer-coding-system 'utf-8)
(setq default-process-coding-system '(utf-8-unix . utf-8-unix))

;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(load-theme 'doom-one t)

(cua-mode)

(set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 120)
(set-face-attribute 'variable-pitch nil :family "Noto Sans" :height 140)

;; Emoji: 😄 🤦 🏴
(set-fontset-font t 'symbol "Apple Color Emoji")
(set-fontset-font t 'symbol "Noto Color Emoji" nil 'append)
(set-fontset-font t 'symbol "Segoe UI Emoji" nil 'append)
(set-fontset-font t 'symbol "Symbola" nil 'append)

(doom-modeline-mode 1)

(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
  (setq projectile-enable-caching t)
  (setq projectile-project-search-path '("~/code/"))
  (setq magit-revision-show-gravatars t)
  (projectile-mode 1))


(add-hook 'prog-mode-hook 'display-line-numbers-mode)

;; save open buffers
(desktop-save-mode 1)

;; Use y/p for prompts
(defalias 'yes-or-no-p 'y-or-n-p)
;; Autosave on focus lost
(defun save-all ()
  (interactive)
  (save-some-buffers t))

;; (persp-mode 1)
;; (persp-mode-projectile-bridge-mode 1)

;; Disable backup/lock files
(setq
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil)

(global-set-key (kbd "C-`") 'iflipb-next-buffer)
(global-set-key
 (if (featurep 'xemacs) (kbd "C-`") (kbd "C-~"))
 'iflipb-previous-buffer)

(defun switch-to-last-buffer ()
  (interactive)
  (switch-to-buffer nil))

(global-set-key (kbd "C-<tab>") 'switch-to-last-buffer)

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-,") 'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:") 'avy-goto-char)

(add-hook 'focus-out-hook 'save-all)
(global-set-key (kbd "C-c b") 'consult-buffer)
(global-set-key (kbd "C-c d") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c e") 'er/expand-region)
(global-set-key (kbd "C-c f") 'projectile-find-file)
(global-set-key (kbd "C-c g") 'magit-status)
(global-set-key (kbd "C-c l") 'consult-line)
(global-set-key (kbd "C-c p") 'projectile-switch-project)
(global-set-key (kbd "C-c r") 'consult-ripgrep)
(global-set-key (kbd "C-c s") 'save-buffer)
(global-set-key (kbd "C-c v") 'projectile-run-vterm)
(global-set-key (kbd "C-c w") 'kill-this-buffer)
(global-set-key (kbd "C-c x") 'mc/skip-to-next-like-this)

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
(define-key reb-mode-map (kbd "RET") #'reb-repiace-regexp)
(define-key reb-lisp-mode-map (kbd "RET") #'reb-replace-regexp)
(global-set-key (kbd "C-M-%") #'re-builder)

(provide 'init-misc)
;;; init-misc.el ends here
