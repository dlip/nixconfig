(setq inhibit-startup-message t)
(scroll-bar-mode -1)        ; Disable visible scrollbar
(tool-bar-mode -1)          ; Disable the toolbar
(tooltip-mode -1)           ; Disable tooltips
(set-fringe-mode 10)        ; Give some breathing room

(menu-bar-mode -1)            ; Disable the menu bar
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

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

(selectrum-mode +1)
;; to make sorting and filtering more intelligent
(selectrum-prescient-mode +1)
;; to save your command history on disk, so the sorting gets more
;; intelligent over time
(prescient-persist-mode +1)

(setq completion-styles '(orderless))
(marginalia-mode)

;; Allow C-h to trigger which-key before it is done automatically
(setq which-key-show-early-on-C-h t)
;; make sure which-key doesn't show normally but refreshes quickly after it is
;; triggered.
(setq which-key-idle-secondary-delay 0.05)
(which-key-mode)

(define-key selectrum-minibuffer-map (kbd "C-c C-o") 'embark)
(define-key selectrum-minibuffer-map (kbd "C-c C-c") 'embark-act)
(global-set-key (kbd "M-?") 'consult-ripgrep)
(add-hook 'embark-collect-mode-hook 'embark-consult-preview-minor-mode)
(global-set-key [remap switch-to-buffer] 'consult-buffer)
(global-set-key [remap switch-to-buffer-other-window] 'consult-buffer-other-window)
(global-set-key [remap switch-to-buffer-other-frame] 'consult-buffer-other-frame)
(global-set-key [remap goto-line] 'consult-goto-line)
(global-set-key [remap isearch-forward] 'consult-isearch)
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
;; save open buffers
(desktop-save-mode 1)
