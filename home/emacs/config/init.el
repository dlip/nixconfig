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

(use-package dap-mode
  :after lsp-mode
  :config
  (dap-auto-configure-mode))

;; UI
(use-package catppuccin-theme
  :config
  (load-theme 'catppuccin :no-confirm)
  (setq catppuccin-flavor 'macchiato)
  (catppuccin-reload))

(set-frame-font "RobotoMono Nerd Font 15" nil t)

(setq inhibit-startup-message t)
(setq initial-scratch-message nil)
(menu-bar-mode -1)
(scroll-bar-mode -1)
(tool-bar-mode -1)
(xterm-mouse-mode 1)

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
  (evil-mode)
  :config
  (evil-set-undo-system 'undo-redo)
  )

(use-package evil-collection
  :after evil
  :config
  ;;(setq evil-collection-mode-list '(dashboard dired ibuffer))
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
   "RET" 'evil-write
   "U" 'evil-redo
   "g a" 'evil-switch-to-windows-last-buffer
   )

  (general-define-key
   "C-<left>" 'evil-window-left
   "C-<right>" 'evil-window-right
   "C-<up>" 'evil-window-up
   "C-<down>" 'evil-window-down
   )

  (general-create-definer space-leader
    :states '(normal insert visual emacs)
    :keymaps 'override
    :prefix "SPC" ;; set leader
    :global-prefix "M-SPC") ;; access leader in insert mode

  (space-leader
    "b" '(:ignore t :wk "buffer")
    "bb" '(switch-to-buffer :wk "Switch buffer")
    "bk" '(kill-this-buffer :wk "Kill this buffer")
    "bn" '(next-buffer :wk "Next buffer")
    "bp" '(previous-buffer :wk "Previous buffer")
    "br" '(revert-buffer :wk "Reload buffer")
    "d" '(dired-jump :wk "Dired")
    "f" '(projectile-find-file :wk "Open file picker")
    "g" '(:ignore t :wk "Git")
    "g /" '(magit-displatch :wk "Magit dispatch")
    "g ." '(magit-file-displatch :wk "Magit file dispatch")
    "g b" '(magit-branch-checkout :wk "Switch branch")
    "g c" '(:ignore t :wk "Create")
    "g c b" '(magit-branch-and-checkout :wk "Create branch and checkout")
    "g c c" '(magit-commit-create :wk "Create commit")
    "g c f" '(magit-commit-fixup :wk "Create fixup commit")
    "g C" '(magit-clone :wk "Clone repo")
    "g f" '(:ignore t :wk "Find")
    "g f c" '(magit-show-commit :wk "Show commit")
    "g f f" '(magit-find-file :wk "Magit find file")
    "g f g" '(magit-find-git-config-file :wk "Find gitconfig file")
    "g a" '(magit-stage-file :wk "Git stage file")
    "g F" '(magit-fetch :wk "Git fetch")
    "g s" '(magit-status :wk "Magit status")
    "g i" '(magit-init :wk "Initialize git repo")
    "g l" '(magit-log-buffer-file :wk "Magit buffer log")
    "g r" '(vc-revert :wk "Git revert file")
    "g t" '(git-timemachine :wk "Git time machine")
    "g u" '(magit-stage-file :wk "Git unstage file")
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
    "i" '(:ignore t :wk "Init")
    "ie" '(open-init :wk "Edit")
    "ir" '(reload-init :wk "Reload")
    ;;"l" lsp-command-map
    "n" '(neotree-toggle :wk "Neotree Toggle")
    "p" projectile-command-map
    "v" '(vterm-toggle :wk "Vterm")
    "x" '(evil-delete-buffer :wk "Close Buffer")
    )
  )

(use-package direnv
  :config
  (direnv-mode))

(use-package vterm
  :config
  (setq
   vterm-max-scrollback 5000)
  (define-key vterm-mode-map (kbd "M-v") #'vterm-toggle-hide)
  (define-key vterm-mode-map (kbd "C-<up>") #'evil-window-up)
  (define-key vterm-mode-map (kbd "C-<down>") #'evil-window-down)
  (define-key vterm-mode-map (kbd "C-<left>") #'evil-window-left)
  (define-key vterm-mode-map (kbd "C-<right>") #'evil-window-right)
  )

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

(use-package magit
  )

(use-package neotree
  :config
  (setq neo-smart-open t
        neo-show-hidden-files t
        neo-window-width 55
        neo-window-fixed-size nil
        inhibit-compacting-font-caches t
        projectile-switch-project-action 'neotree-projectile-action)
  ;; truncate long file names in neotree
  (add-hook 'neo-after-create-hook
            #'(lambda (_)
		(with-current-buffer (get-buffer neo-buffer-name)
                  (setq truncate-lines t)
                  (setq word-wrap nil)
                  (make-local-variable 'auto-hscroll-mode)
                  (setq auto-hscroll-mode nil)))))

(use-package all-the-icons
  :ensure t
  :if (display-graphic-p))

(use-package all-the-icons-dired
  :hook (dired-mode . (lambda () (all-the-icons-dired-mode t))))

(use-package dired-open
  :config
  (setq dired-open-extensions '(("gif" . "sxiv")
                                ("jpg" . "sxiv")
                                ("png" . "sxiv")
                                ("mkv" . "mpv")
                                ("mp4" . "mpv"))))
;; not working
(use-package dired-preview
  :config
  ;; Default values for demo purposes
  (setq dired-preview-delay 0.7)
  (setq dired-preview-max-size (expt 2 20))
  (setq dired-preview-ignored-extensions-regexp
	(concat "\\."
		"\\(mkv\\|webm\\|mp4\\|mp3\\|ogg\\|m4a"
		"\\|gz\\|zst\\|tar\\|xz\\|rar\\|zip"
		"\\|iso\\|epub\\|pdf\\)"))

  ;; Enable `dired-preview-mode' in a given Dired buffer or do it
  ;; globally:
  (dired-preview-global-mode 1)
  )

(use-package evil-mc
  :config
  (global-evil-mc-mode  1)
  )

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
