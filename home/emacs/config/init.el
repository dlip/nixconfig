;; Treesitter
(use-package treesit-auto
  :config
  (treesit-auto-add-to-auto-mode-alist)
  (global-treesit-auto-mode))

(use-package nix-ts-mode
  :mode "\\.nix\\'")

;; LSP
(use-package lsp-mode
  :init
  ;; set prefix for lsp-command-keymap (few alternatives - "C-l", "C-c l")
  ;;(setq lsp-keymap-prefix "C-c l")
  :hook (;; replace XXX-mode with concrete major-mode(e. g. python-mode)
         (python-ts-mode . lsp)
         ;; if you want which-key integratio
         (lsp-mode . lsp-enable-which-key-integration))
  :config
  (general-def 'normal lsp-mode :definer 'minor-mode
    "SPC l" lsp-command-map)
  )

;; UI
(use-package catppuccin-theme
  :config
  (load-theme 'catppuccin :no-confirm)
  (setq catppuccin-flavor 'macchiato)
  (catppuccin-reload))

(set-frame-font "RobotoMono Nerd Font 15" nil t)

(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)

(global-display-line-numbers-mode 1)
(setq display-line-numbers-type 'relative)

;; OTHER PACKAGES
(use-package which-key
  :config
  (which-key-mode))

(use-package projectile
  :ensure t
  :init
  (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))
:config
(setq projectile-project-search-path '("~/code/"))

(use-package ivy
  :config
  (ivy-mode)
  (setq ivy-use-virtual-buffers t)
  (setq enable-recursive-minibuffers t)
  ;; enable this if you want `swiper' to use it
  ;; (setq search-default-mode #'char-fold-to-regexp)
  (global-set-key "\C-s" 'swiper)
  (global-set-key (kbd "C-c C-r") 'ivy-resume)
  (global-set-key (kbd "<f6>") 'ivy-resume)
  (counsel-mode))

(use-package evil
  :init      ;; tweak evil's configuration before loading it
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  (setq evil-vsplit-window-right t)
  (setq evil-split-window-below t)
  (evil-mode))

(use-package evil-collection
  :after evil
  :config
  (setq evil-collection-mode-list '(dashboard dired ibuffer))
  (evil-collection-init))
(use-package evil-tutor)
;; (add-hook 'evil-insert-state-exit-hook
;;           (lambda ()
;;             (call-interactively #'save-buffer)))

(use-package format-all
  :commands format-all-mode
  :hook (prog-mode . format-all-mode)
  :config
  (setq-default format-all-formatters '(("C"     (astyle "--mode=c"))
                                        ("Shell" (shfmt "-i" "4" "-ci")))))

(use-package general
  :config
  (general-evil-setup)
  (general-define-key
   :states 'normal
   "RET" 'evil-write)
  ;;(general-def 'normal lsp-mode :definer 'minor-mode
  ;;"SPC l" lsp-command-map)
  ;; set up 'SPC' as the global leader key
  (general-create-definer dlip/leader-keys
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "M-SPC") ;; access leader in insert mode

  (dlip/leader-keys
    "b" '(:ignore t :wk "buffer")
    "bb" '(switch-to-buffer :wk "Switch buffer")
    "bk" '(kill-this-buffer :wk "Kill this buffer")
    "bn" '(next-buffer :wk "Next buffer")
    "bp" '(previous-buffer :wk "Previous buffer")
    "br" '(revert-buffer :wk "Reload buffer")
    "f" '(projectile-find-file :wk "Open file picker")
    "i" '(:ignore t :wk "Init")
    "l" '(:ignore t :wk "LSP")
    "lw" '(:ignore t :wk "Workspace")
    "lF" '(:ignore t :wk "Folder")
    "l=" '(:ignore t :wk "Formatting")
    "lT" '(:ignore t :wk "Toggles")
    "lg" '(:ignore t :wk "Goto")
    "lh" '(:ignore t :wk "Help")
    "lr" '(:ignore t :wk "Refactor")
    "la" '(:ignore t :wk "Action")
    "lG" '(:ignore t :wk "Peek")
    "io" '(open-init :wk "Open init")
    "ir" '(reload-init :wk "Reload init")
    ;;"l" lsp-command-map
    "p" projectile-command-map
    "v" '(vterm-toggle :wk "Vterm")
    )
  )

(use-package direnv
  :config
  (direnv-mode))

(use-package vterm
  :config
  (setq
   vterm-max-scrollback 5000))

(use-package vterm-toggle
  :after vterm
  :config
  (setq vterm-toggle-fullscreen-p nil)
  (setq vterm-toggle-scope 'project)
  (add-to-list 'display-buffer-alist
               '((lambda (buffer-or-name _)
                   (let ((buffer (get-buffer buffer-or-name)))
                     (with-current-buffer buffer
                       (or (equal major-mode 'vterm-mode)
                           (string-prefix-p vterm-buffer-name (buffer-name buffer))))))
                 (display-buffer-reuse-window display-buffer-at-bottom)
                 ;;(display-buffer-reuse-window display-buffer-in-direction)
                 ;;display-buffer-in-direction/direction/dedicated is added in emacs27
                 ;;(direction . bottom)
                 ;;(dedicated . t) ;dedicated is supported in emacs27
                 (reusable-frames . visible)
                 (window-height . 0.3))))

;; CUSTOM
(defun open-init ()
  (interactive)
  (find-file user-init-file))

(defun reload-init ()
  (interactive)
  (load-file user-init-file))

(global-set-key (kbd "<home>") 'beginning-of-line)
(global-set-key (kbd "<end>") 'end-of-line)
(global-set-key (kbd "<escape>") 'keyboard-escape-quit)

(defun set-exec-path-from-shell-PATH ()
  "Set up Emacs' `exec-path' and PATH environment variable to match
that used by the user's shell.

This is particularly useful under Mac OS X and macOS, where GUI
apps are not started from a shell."
  (interactive)
  (let ((path-from-shell (replace-regexp-in-string
			  "[ \t\n]*$" "" (shell-command-to-string
					  "$SHELL --login -c 'echo $PATH'"
					  ))))
    (setenv "PATH" path-from-shell)
    (setq exec-path (split-string path-from-shell path-separator))))

(set-exec-path-from-shell-PATH)
