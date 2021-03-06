;;;

(require 'package)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Package management
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/"))
(add-to-list 'package-archives '("melpa" . "http://melpa.org/packages/"))
(add-to-list 'package-archives '("melpa-stable" . "http://stable.melpa.org/packages/"))

(setq package-enable-at-startup nil)
(package-initialize)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-names-vector
   ["#242424" "#e5786d" "#95e454" "#cae682" "#8ac6f2" "#333366" "#ccaa8f" "#f6f3e8"])
 '(custom-enabled-themes (quote (wombat)))
 '(package-selected-packages
   (quote
    (evil company terraform-mode auto-complete rust-mode fiplr helm use-package))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))

(eval-when-compile
  (require 'use-package))

(use-package helm
  :ensure t)

(use-package fiplr
  :ensure t)

(setq fiplr-ignored-globs '((directories (".git" ".svn" "target" ".vagrant"))
                            (files ("*.log" "*.jpg" "*.png" "*.zip" "*~"))))
(use-package rust-mode
  :ensure t)

(use-package cider
  :ensure t)

(use-package neotree
  :ensure t)

(use-package monokai-theme
  :ensure t)

(use-package flycheck
  :ensure t)
(global-flycheck-mode)

(use-package exec-path-from-shell
  :ensure t)
(exec-path-from-shell-initialize)

(load-theme 'monokai t)

(use-package auto-complete
  :ensure t)

(use-package terraform-mode
  :ensure t)

(use-package company
  :ensure t)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Editor Preferences
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-hook 'before-save-hook 'delete-trailing-whitespace)

(setq-default tab-width 4)
(setq-default indent-tabs-mode nil)
(global-linum-mode t)
(show-paren-mode 1)
(setq next-screen-context-lines 2)
(global-set-key (kbd "C-x f") 'fiplr-find-file)
(global-set-key (kbd "C-x t") 'neotree-toggle)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Language Specific Hooks
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'emacs-lisp-mode-hook
  (lambda ()
    (setq tab-width 2)))

(add-hook 'c-mode-hook
          (lambda ()
            (set-key (kbd "C-x C-k") 'compile)))

(setq-default c-basic-offset 4)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Clojure
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(add-hook 'cider-repl-mode-hook
      '(lambda () (define-key cider-repl-mode-map (kbd "C-x c")
                    'cider-repl-clear-buffer)))

(add-hook 'cider-repl-mode-hook #'eldoc-mode)

(add-hook 'cider-repl-mode-hook #'company-mode)
(add-hook 'cider-mode-hook #'company-mode)


(provide 'init)
;;;
