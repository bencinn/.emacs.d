(add-to-list 'load-path "~/.emacs.d/lisp")
(defvar bootstrap-version)
(let ((bootstrap-file
       (expand-file-name
        "straight/repos/straight.el/bootstrap.el"
        (or (bound-and-true-p straight-base-dir)
            user-emacs-directory)))
      (bootstrap-version 7))
  (unless (file-exists-p bootstrap-file)
    (with-current-buffer
        (url-retrieve-synchronously
         "https://raw.githubusercontent.com/radian-software/straight.el/develop/install.el"
         'silent 'inhibit-cookies)
      (goto-char (point-max))
      (eval-print-last-sexp)))
  (load bootstrap-file nil 'nomessage))

(straight-use-package 'use-package)
(use-package straight
  :custom
  (straight-use-package-by-default t))

(use-package svg-lib)
(straight-use-package
  '(svg-tag-mode :type git :host github :repo "rougier/svg-tag-mode":after svg-lib))
; (straight-use-package 'mini-frame)
(straight-use-package
  '(nano :type git :host github :repo "bencinn/nano-emacs"))

(setq svg-tag-tags
      '((":TODO:" . ((lambda (tag) (svg-tag-make "TODO"))))))
(require 'svg-tag-mode)
(svg-tag-mode-on)

(defun my/load-config-file (file)
  "Load elisp FILE."
  (load (expand-file-name file "~/.emacs.d/lisp/")))

(my/load-config-file "settings")

(require 'nano)
(require 'nano-layout)
(require 'nano-defaults)
(require 'nano-session)
(require 'nano-modeline)
(require 'nano-faces)
(require 'nano-bindings)
(require 'nano-colors)
(require 'nano-splash)
(require 'nano-help)
; (require 'nano-minibuffer)
(require 'nano-command)

(setq evil-want-keybinding nil)
(use-package evil
	     :config (evil-mode 1))
(use-package evil-collection
	     :after (evil)
	     :straight (evil-collection :type git
	     :host github
             :repo "emacs-evil/evil-collection")) 
(defun nano-theme-set-chimame ()
  (setq frame-background-mode 'light)
  (setq nano-color-foreground "#5451A6")
  (setq nano-color-background "#F2F2F2")
  (setq nano-color-highlight  "#B3D5F2")
  (setq nano-color-critical   "#BF3952")
  (setq nano-color-salient    "#D96A88")
  (setq nano-color-strong     "#5451A6")
  (setq nano-color-popout     "#C9E2F2")
  (setq nano-color-subtle     "#162759")
  (setq nano-color-faded      "#4C4673"))
; (load "~/.cache/wal/colors")
; (nano-theme-set-pywal)
(nano-theme-set-chimame)
(require 'nano-theme)
(nano-theme)

(defun my/reload-init-file ()
  (interactive)
  (load-file user-init-file))

(global-set-key (kbd "<f5>") 'my/reload-init-file)

(use-package magit)

(setq company-text-icons-mapping
 '((array "ARRY" font-lock-type-face)
 (boolean "BOOL" font-lock-builtin-face)
 (class "CLASS" font-lock-type-face)
 (color "#" success)
 (constant "CNST" font-lock-constant-face)
 (constructor "CRST" font-lock-function-name-face)
 (enum-member "EMEM" font-lock-builtin-face)
 (enum "ENUM" font-lock-builtin-face)
 (field "S->f" font-lock-variable-name-face)
 (file "F" font-lock-string-face)
 (folder "D" font-lock-doc-face)
 (interface "INTF" font-lock-type-face)
 (keyword "KEWD" font-lock-keyword-face)
 (method "MTHD" font-lock-function-name-face)
 (function "FN()" font-lock-function-name-face)
 (module "{" font-lock-type-face)
 (numeric "NUMR" font-lock-builtin-face)
 (operator "OP()" font-lock-comment-delimiter-face)
 (property "PROP" font-lock-variable-name-face)
 (reference "REFR" font-lock-doc-face)
 (snippet "S" font-lock-string-face)
 (string "str" font-lock-string-face)
 (struct "%" font-lock-variable-name-face)
 (text "w" shadow)
 (type-parameter "PRMT" font-lock-type-face)
 (unit "UNIT" shadow)
 (value "VALU" font-lock-builtin-face)
 (variable "VARB" font-lock-variable-name-face)
 (t "." shadow)))
(setq company-icon-margin 3)
(use-package company
  :init (global-company-mode))
(use-package yasnippet
  :after (company)
  :init (add-hook 'prog-mode-hook #'yas-global-mode 1))
(use-package eglot
  :after (yasnippet)
  :init (add-hook 'prog-mode-hook #'eglot-ensure))

(defalias 'start-lsp-server #'eglot)

(add-hook 'prog-mode-hook #'flymake-mode)
(straight-use-package 'go-mode)
(straight-use-package 'rust-mode)
(straight-use-package 'ada-mode)

(setq rcirc-default-nick "rori")
(add-hook 'rcirc-mode-hook #'rcirc-track-minor-mode)
(add-hook 'rcirc-mode-hook #'rcirc-omit-mode)

(setq projectile-completion-system 'ivy)
(setq projectile-project-search-path '("~/code/"))
(use-package vertico
  :init
  (vertico-mode)

  ;; Different scroll margin
  ;; (setq vertico-scroll-margin 0)
  (keymap-set vertico-map "TAB" #'next-line-or-history-element)
  (keymap-set vertico-map "<backtab>" #'previous-line-or-history-element)
  (keymap-set vertico-map "M-TAB" #'minibuffer-complete)

  ;; Show more candidates
  (setq vertico-count 20)

  ;; Grow and shrink the Vertico minibuffer
  (setq vertico-resize t)

  ;; Optionally enable cycling for `vertico-next' and `vertico-previous'.
  (setq vertico-cycle t)
  )
(use-package consult
  :hook (completion-list-mode . consult-preview-at-point-mode)
  :after (vertico)
  :bind (("C-c s f" . consult-eglot-symbols)
         ("C-c s s" . consult-ripgrep)
         ("C-c s g" . consult-git-grep)
         ("C-c s m" . consult-man)
         ("C-c s b" . consult-buffer)

         )
  :init
  
  ;; Optionally tweak the register preview window.
  ;; This adds thin lines, sorting and hides the mode line of the window.
  (advice-add #'register-preview :override #'consult-register-window)

  ;; Use Consult to select xref locations with preview
  (setq xref-show-xrefs-function #'consult-xref
        xref-show-definitions-function #'consult-xref)

  :config

  ;; Optionally configure preview. The default value
  ;; is 'any, such that any key triggers the preview.
  ;; (setq consult-preview-key 'any)
  ;; (setq consult-preview-key "M-.")
  ;; (setq consult-preview-key '("S-<down>" "S-<up>"))
  ;; For some commands and buffer sources it is useful to configure the
  ;; :preview-key on a per-command basis using the `consult-customize' macro.
  (consult-customize
   consult-theme :preview-key '(:debounce 0.3 any)
   consult-ripgrep consult-git-grep consult-grep
   consult-bookmark consult-recent-file consult-xref
   consult--source-bookmark consult--source-file-register
   consult--source-recent-file consult--source-project-recent-file
   ;; :preview-key "M-."
   :preview-key '(:debounce 0.3 any))

  ;; Optionally configure the narrowing key.
  ;; Both < and C-+ work reasonably well.
  (setq consult-narrow-key "<") ;; "C-+"

  )
(use-package ivy)
(use-package projectile
  :ensure t
  :after (ivy)
  :init (projectile-mode +1)
  :bind (:map projectile-mode-map
              ("s-p" . projectile-command-map)
              ("C-c p" . projectile-command-map)))
(straight-use-package 'consult-eglot)
(menu-bar-mode -1)

(use-package eldoc-box)
(add-hook 'eldoc-mode-hook #'eldoc-box-hover-at-point-mode t)

(setq compilation-finish-functions
      (lambda (buf str)
        (if (null (string-match ".*exited abnormally.*" str))
            ;;no errors, make the compilation window go away in a few seconds
            (progn
              (run-at-time
               "2 sec" nil 'delete-windows-on
               (get-buffer-create "*compilation*"))
              (message "No Compilation Errors!")))))

(setq special-display-buffer-names
      '("*compilation*"))

(setq special-display-function
      (lambda (buffer &optional args)
        (split-window)
        (switch-to-buffer buffer)
        (get-buffer-window buffer 0)))

(use-package markdown-mode)

;; use-package with package.el:
(use-package dashboard
  :ensure t
  :config
  (dashboard-setup-startup-hook))
(setq dashboard-banner-logo-title "> D <")
(setq dashboard-footer-messages '("NOTE: hug chino" "NOTE: pat chino" "NOTE: cuddle chino"))
(setq dashboard-center-content t)
(setq dashboard-projects-backend 'projectile)
(setq dashboard-items          '((recents   . 5)
                                 (projects  . 5)))
(setq dashboard-item-shortcuts '((recents   . "r")
                                 (projects  . "p")))
(setq dashboard-projects-backend )
(setq dashboard-startupify-list '(dashboard-insert-banner
                                  dashboard-insert-newline
                                  dashboard-insert-banner-title
                                  dashboard-insert-newline
                                  dashboard-insert-navigator
                                  dashboard-insert-newline
                                  dashboard-insert-init-info
                                  dashboard-insert-items
                                  dashboard-insert-newline
                                  dashboard-insert-footer))

(provide 'init)
;;; init.el ends here
