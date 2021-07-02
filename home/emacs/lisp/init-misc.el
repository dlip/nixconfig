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
   ;; ignore warnings
   ;; warning-minimum-level :emergency
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

;; save open buffers
(desktop-save-mode 1)

;; Use y/p for prompts
(defalias 'yes-or-no-p 'y-or-n-p)

(use-package super-save
  :config
  (super-save-mode +1)
  (add-to-list 'super-save-triggers 'ace-window))

;; (persp-mode 1)
;; (persp-mode-projectile-bridge-mode 1)

;; Disable backup/lock files
(setq
 make-backup-files nil
 auto-save-default nil
 create-lockfiles nil)

;; Dired
(defun dired-up-directory-same-buffer ()
  "Go up in the same buffer."
  (find-alternate-file ".."))

(defun my-dired-mode-hook ()
  (put 'dired-find-alternate-file 'disabled nil) ; Disables the warning.
  (define-key dired-mode-map (kbd "RET") 'dired-find-alternate-file)
  (define-key dired-mode-map (kbd "^") 'dired-up-directory-same-buffer))

(add-hook 'dired-mode-hook #'my-dired-mode-hook)

(setq dired-use-ls-dired nil)

;; my prefix
(global-unset-key (kbd "C-t"))

;; ctrl-tab
(global-set-key (kbd "C-`") 'iflipb-next-buffer)
(global-set-key
 (if (featurep 'xemacs) (kbd "C-`") (kbd "C-~"))
 'iflipb-previous-buffer)

(defun switch-to-last-buffer ()
  (interactive)
  (switch-to-buffer nil))

(use-package ace-window
  :config
  ;; Show the window designators in the modeline.
  (ace-window-display-mode)

   ;; Make the number indicators a little larger. I'm getting old.
  (set-face-attribute 'aw-leading-char-face nil :height 2.0 :background "black")

  :bind (("M-o" . ace-window))
  :custom
  (aw-keys '(?a ?r ?s ?t ?n ?e ?i ?o) "Designate windows by home row keys, not numbers.")
  (aw-background nil))

(use-package duplicate-thing
  :init
  (defun my-duplicate-thing ()
    "Duplicate thing at point without changing the mark."
    (interactive)
    (save-mark-and-excursion (duplicate-thing 1)))
  :bind (("C-t d" . my-duplicate-thing)))

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

(provide 'init-misc)
;;; init-misc.el ends here
