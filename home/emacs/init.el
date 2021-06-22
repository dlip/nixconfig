;;; init --- emacs settings

(add-to-list 'load-path (expand-file-name (concat user-emacs-directory "lisp/")))

(require 'init-misc)
(require 'init-completion)
(require 'init-lsp)

(provide 'init)

;;; init ends here
