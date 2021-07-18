;;; init-org --- org settings

(defun dlip/org-font-setup ()
  ;; Replace list hyphen with dot
  (font-lock-add-keywords 'org-mode
                          '(("^ *\\([-]\\) "
                             (0 (prog1 () (compose-region (match-beginning 1) (match-end 1) "•"))))))

  ;; Set faces for heading levels
  (dolist (face '((org-level-1 . 1.2)
                  (org-level-2 . 1.1)
                  (org-level-3 . 1.05)
                  (org-level-4 . 1.0)
                  (org-level-5 . 1.1)
                  (org-level-6 . 1.1)
                  (org-level-7 . 1.1)
                  (org-level-8 . 1.1)))
    (set-face-attribute (car face) nil :font "Noto Sans" :weight 'regular :height (cdr face)))

  ;; Ensure that anything that should be fixed-pitch in Org files appears that way
  (set-face-attribute 'org-block nil    :foreground nil :inherit 'fixed-pitch)
  (set-face-attribute 'org-table nil    :inherit 'fixed-pitch)
  (set-face-attribute 'org-formula nil  :inherit 'fixed-pitch)
  (set-face-attribute 'org-code nil     :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-table nil    :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-verbatim nil :inherit '(shadow fixed-pitch))
  (set-face-attribute 'org-special-keyword nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-meta-line nil :inherit '(font-lock-comment-face fixed-pitch))
  (set-face-attribute 'org-checkbox nil  :inherit 'fixed-pitch)
  (set-face-attribute 'line-number nil :inherit 'fixed-pitch)
  (set-face-attribute 'line-number-current-line nil :inherit 'fixed-pitch))

(defun dlip/org-mode-setup ()
  (org-indent-mode)
  (variable-pitch-mode 1)
  (visual-line-mode 1))

(use-package org
  :commands (org-capture org-agenda)
  :hook (org-mode . dlip/org-mode-setup)
  :config
  (setq org-ellipsis " ▾")
  (setq org-directory "~/notes/org/")
  ;; set org-link-frame-setup
  ;; so that you can open file in current window
  (setq org-link-frame-setup '((file . find-file)))
  (dlip/org-font-setup))

(setq org-roam-v2-ack t)
(use-package org-roam
  :config
  (setq org-roam-dailies-directory "daily/")
  (setq org-roam-dailies-capture-templates
	'(("d" "default" entry
           "* %<%H:%M> %?"
           :if-new (file+head "%<%Y-%m-%d>.org"
                              "#+title: %<%Y-%m-%d>\n"))))
  (org-roam-setup)
  ;; If using org-roam-protocol
  (require 'org-roam-protocol)
  :custom
  (org-roam-directory (file-truename "~/notes/org/roam/"))
  :bind (("C-c n l" . org-roam-buffer-toggle)
         ("C-c n f" . org-roam-node-find)
         ("C-c n g" . org-roam-graph)
         ("C-c n i" . org-roam-node-insert)
         ("C-c n c" . org-roam-capture)
         ;; Dailies
         ("C-c n j" . org-roam-dailies-capture-today)))

(use-package org-bullets
  :hook (org-mode . org-bullets-mode)
  :custom
  (org-bullets-bullet-list '("◉" "○" "●" "○" "●" "○" "●")))


(use-package org-agenda
  :bind (("C-c a" . org-agenda))
  :config
  (setq org-agenda-files '("~/notes/org/roam/")))


(defun dlip/org-mode-visual-fill ()
  (setq visual-fill-column-width 100
        visual-fill-column-center-text t)
  (visual-fill-column-mode 1))

(use-package visual-fill-column
  :hook (org-mode . dlip/org-mode-visual-fill))

(use-package org-journal
  :after org
  :defer t
  :init
  ;; Change default prefix key; needs to be set before loading org-journal
  (setq org-journal-prefix-key "C-c C-j ")
  :config
  (setq org-journal-dir "~/notes/org/journal/"
        org-journal-date-format "%A, %d %B %Y"))

(use-package org-drill
  :after org
  :commands (org-drill)
  :init
  (setq
   org-drill-spaced-repetition-algorithm  'sm2
   org-drill-learn-fraction                0.4
   ;; https://orgmode.org/worg/org-contrib/org-drill.html#text-org42a64b5
   ;; 0.4 means 5 times in the first month, and 10 times in five months

   org-drill-leech-method             'warn
   org-drill-leech-failure-threshold   5

   org-drill-maximum-duration                     nil
   org-drill-maximum-items-per-session            nil
   org-drill-add-random-noise-to-intervals-p      t
   org-drill-save-buffers-after-drill-sessions-p  nil
   org-drill-hide-item-headings-p                 nil
   org-drill-overdue-interval-factor              1.2
   org-drill-days-before-old                      10
   ;; org-drill-failure-quality                      2

   ;; org-drill-adjust-intervals-for-early-and-late-repetitions-p t    ; doesn't have any effect on sm2

   org-drill-scope 'file-no-restriction     ; https://orgmode.org/worg/org-contrib/org-drill.html#orgf1d69c8
   ;; TODO: write functions: ym-drill-file, ym-drill-math, ym-drill-eng, ym-drill-list
   ;; or within each file, set org-drill-scope to 'directory'

   ;; defaults
   ;; org-drill-days-before-old 7
   org-drill--help-key ?`   ; the key to the left of the 1 key
   )
  :config
  (defun org-drill-entry-empty-p () nil)   ; don't ignore "empty" cards -- https://emacs.stackexchange.com/questions/38440/make-org-drill-allow-reviewing-empty-cards/58568#58568
  )

(provide 'init-org)
;;; init-org.el ends here
