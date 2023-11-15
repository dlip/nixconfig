;;; init --- emacs settings

(use-package init-loader
  :defer nil
  :init
  (setq init-loader-show-log-after-init 'error-only)
  (init-loader-load (expand-file-name "init" user-emacs-directory)))

(provide 'init)

;;; init ends here
