(setq inhibit-startup-message t)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar
;; Make ESC quit prompts
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(ivy-mode)

(load-theme 'doom-one t)

(cua-mode)
(set-face-attribute 'default nil :font "FiraCode Nerd Font" :height 120)
(doom-modeline-mode 1)

(setq projectile-project-search-path '("~/code/"))
(setq magit-revision-show-gravatars t)
(setq org-directory "~/org/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)
(all-the-icons-ivy-setup)
