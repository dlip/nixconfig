;;; init-programming --- programming settings

(add-hook 'prog-mode-hook #'rainbow-delimiters-mode)

(use-package flycheck
  :after org
  :hook
  (org-src-mode . disable-flycheck-for-elisp)
  :custom
  (flycheck-emacs-lisp-initialize-packages t)
  (flycheck-display-errors-delay 0.1)
  :config
  (global-flycheck-mode)
  (flycheck-set-indication-mode 'left-margin)

  (defun disable-flycheck-for-elisp ()
    (setq-local flycheck-disabled-checkers '(emacs-lisp-checkdoc)))

  (add-to-list 'flycheck-checkers 'proselint)
  (setq-default flycheck-disabled-checkers '(haskell-stack-ghc)))

(use-package projectile
  :config
  (define-key projectile-mode-map (kbd "C-c C-p") 'projectile-command-map)
  (setq projectile-enable-caching t)
  (setq projectile-project-search-path '("~/code/"))
  (setq magit-revision-show-gravatars t)
  (projectile-mode 1))

(use-package magit
  :diminish magit-auto-revert-mode
  :diminish auto-revert-mode
  :config
  (add-to-list 'magit-no-confirm 'stage-all-changes))

(use-package forge
  :after magit)

(add-hook 'prog-mode-hook 'display-line-numbers-mode)

(setenv "TSSERVER_LOG_FILE" "/tmp/tsserver.log")

(use-package lsp-mode
  :defer t
  :hook ((lsp-mode . (lambda ()
                       (let ((lsp-keymap-prefix "C-c l"))
                         (lsp-enable-which-key-integration))))
	 (go-mode . lsp-deferred)
	 (typescript-mode . lsp-deferred)
	 (web-mode . lsp-deferred))
  :commands (lsp lsp-deferred)
  :init (setq lsp-keep-workspace-alive nil ;; Auto kill LSP server
              lsp-enable-indentation nil
              lsp-enable-on-type-formatting nil
              lsp-auto-guess-root nil
              lsp-enable-snippet t)
  :config
  (define-key lsp-mode-map (kbd "C-c l") lsp-command-map))

(use-package lsp-ui
  :after lsp-mode
  :hook (lsp-mode . lsp-ui-mode)
  :init (setq lsp-ui-doc-enable t
              lsp-ui-doc-use-webkit nil
              lsp-ui-doc-delay 0
              lsp-ui-doc-include-signature t
              lsp-ui-doc-position 'at-point
              lsp-eldoc-enable-hover nil ;; Disable eldoc displays in minibuffer
              lsp-ui-sideline-enable t
              lsp-ui-sideline-show-hover nil
              lsp-ui-sideline-show-diagnostics nil
              lsp-ui-sideline-ignore-duplicate t)
  :config (setq lsp-ui-flycheck-enable t)
  :commands lsp-ui-mode)


(use-package lsp-treemacs :commands lsp-treemacs-errors-list)

(use-package company
  :after lsp-mode
  :hook (lsp-mode . company-mode)
  :bind (:map company-active-map
         ("<tab>" . company-complete-selection))
        (:map lsp-mode-map
         ("<tab>" . company-indent-or-complete-common))
  :custom
  (company-minimum-prefix-length 1)
  (company-idle-delay 0.0))

(use-package dap-mode
  :diminish
  :hook ((lsp-mode . dap-mode)
         (dap-mode . dap-ui-mode)
         (dap-mode . dap-tooltip-mode)
         (go-mode . (lambda() (require 'dap-go)))))

(provide 'init-programming)
;;; init-programming.el ends here
