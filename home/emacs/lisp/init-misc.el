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
(doom-modeline-mode 1)

(projectile-mode +1)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)
(setq projectile-project-search-path '("~/code/"))
(setq magit-revision-show-gravatars t)
(setq org-directory "~/org/")
(use-package org-bullets
    :hook (org-mode . org-bullets-mode))
;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; (persp-mode 1)
;; (persp-mode-projectile-bridge-mode 1)
(setq auto-save-file-name-transforms
      `((".*" "/tmp/" t)))

(global-set-key (kbd "<C-tab>") 'iflipb-next-buffer)
(global-set-key
 (if (featurep 'xemacs) (kbd "<C-iso-left-tab>") (kbd "<C-S-iso-lefttab>"))
 'iflipb-previous-buffer)

(defun switch-to-last-buffer ()
  (interactive)
  (switch-to-buffer nil))

(global-set-key (kbd "C-`") 'switch-to-last-buffer)
(global-set-key (kbd "C-c C-w") 'kill-current-buffer)
;; save open buffers
(desktop-save-mode 1)
(defalias 'yes-or-no-p 'y-or-n-p)
;; Autosave on focus lost
(defun save-all ()
  (interactive)
  (save-some-buffers t))

(add-hook 'focus-out-hook 'save-all)

(setq neo-theme (if (display-graphic-p) 'icons 'arrow))
(global-set-key (kbd "C-c f") 'projectile-find-file)
(global-set-key (kbd "C-c n") 'neotree-projectile-action)
(global-set-key (kbd "C-c r") 'consult-ripgrep)
(global-set-key (kbd "C-c v") 'projectile-run-vterm)

(setq org-journal-dir "~/org/journal/")
(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(global-flycheck-mode)

(use-package wgrep
  :init (setq wgrep-auto-save-buffer t
	      wgrep-enable-key "E"))

(provide 'init-misc)
;;; init-misc.el ends here
