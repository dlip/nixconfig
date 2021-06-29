;;; init-evil --- evil settings

(use-package evil
  :init
  (setq evil-want-integration t) ;; This is optional since it's already set to t by default.
  (setq evil-want-keybinding nil)
  :config
  (evil-mode 1))

(use-package evil-collection
  :after evil
  :config
  (evil-collection-init)
  ;;(evil-define-key 'normal 'global (kbd "SPC") mode-specific-map)
  )

(use-package hydra
  :after evil
  :config

  (defhydra hydra-space (:color blue :idle 1.0 :hint nil)
    "
_:_ → M-x            _g_ → magit
_b_ → switch buffer  _k_ → kill buffer
_d_ → dired          _p_ → +project
_f_ → find file
"
    ("b" my/switch-to-buffer)
    ("d" dired)
    ("f" my/find-file)
    ("g" magit)
    ("p" hydra-project/body)
    ("k" kill-this-buffer)
    (":" my/M-x))

  (defhydra hydra-project (:color blue :idle 0.5 :hint nil)
    "
+project
_c_ → compile project
_f_ → find project file
_r_ → replace
_R_ → replace regexp
_s_ → search
"
    ("c" projectile-compile-project)
    ("f" projectile-find-file)
    ("r" projectile-replace)
    ("R" projectile-replace-regexp)
    ("s" projectile-ag))

  ;;(evil-global-set-key 'normal (kbd "<SPC>") 'hydra-space/body)
  )

(use-package general
  :after hydra
  :init
  (setq general-override-states '(insert
                                  emacs
                                  hybrid
                                  normal
                                  visual
                                  motion
                                  operator
                                  replace))
  :config
  (general-define-key
   :states '(normal visual motion)
   :keymaps 'override
   "SPC" 'hydra-space/body))

(provide 'init-evil)
;;; init-evil.el ends here
