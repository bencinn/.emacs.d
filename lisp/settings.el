(if (boundp 'after-focus-change-function)
    (add-function :after after-focus-change-function
                  (lambda () (unless (frame-focus-state)
                          (garbage-collect))))
  (add-hook 'after-focus-change-function
            'garbage-collect))


;; If you still experience freezing.
(setq gc-cons-threshold 800000)

(setq user-full-name "Chitsanupong Rongpan")
(setq user-mail-address "pp.rongpan@gmail.com")

(set-language-environment "UTF-8")

(column-number-mode 1)
(global-display-line-numbers-mode 1)
(electric-pair-mode 1)
(setq-default tab-width 2)
(setq-default indent-tabs-mode nil)
(setq-default indent-line-function 'insert-tab)

(savehist-mode 1)
(recentf-mode 1)

(setq backup-directory-alist '(("." . "~/.saves")))
(setq backup-by-copying t)
(setq version-control t)
(setq delete-old-versions t)
(setq create-lockfiles nil)

(setq mouse-wheel-progressive-speed nil)
(setq scroll-conservatively 101)

(setq use-short-answers t)
(setq use-dialog-box nil)

(setq inhibit-startup-message "pyon")
(setq message-log-max nil)
(kill-buffer "*Messages*")

(setq initial-scratch-message nil)
(setq initial-major-mode 'fundamental-mode)

(if (string-equal system-type "darwin")
    (setq dired-use-ls-dired nil))

(setq nano-font-family-monospaced "Iosevka Custom")
(setq nano-font-size 14)
