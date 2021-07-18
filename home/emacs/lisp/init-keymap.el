;;; init-keymap --- keymap settings

(global-set-key (kbd "M-o") 'ace-window)
(global-set-key (kbd "M-z") 'avy-zap-to-char-dwim)
(global-set-key (kbd "M-Z") 'avy-zap-up-to-char-dwim)

(global-set-key (kbd "C-<tab>") 'switch-to-last-buffer)

(global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
(global-set-key (kbd "C-,") 'mc/skip-to-next-like-this)
(global-set-key (kbd "C-:") 'avy-goto-char)

(global-set-key (kbd "C-t b") 'switch-to-buffer)
(global-set-key (kbd "C-t e") 'er/expand-region)
(global-set-key (kbd "C-t f") 'projectile-find-file)
(global-set-key (kbd "C-t g") 'magit-status)
(global-set-key (kbd "C-t j") 'org-roam-dailies-capture-today)
(global-set-key (kbd "C-t l") 'consult-line)
(global-set-key (kbd "C-t p") 'projectile-switch-project)
(global-set-key (kbd "C-t r") 'consult-ripgrep)
(global-set-key (kbd "C-t s") 'vr/replace)
(global-set-key (kbd "C-t t") 'treemacs-select-window)
(global-set-key (kbd "C-t v") 'projectile-run-vterm)
(global-set-key (kbd "C-t w") 'kill-this-buffer)

(provide 'init-keymap)
;;; init-keymap.el ends here
