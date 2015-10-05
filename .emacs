;;; package --- Summary:

;;;; Commentary:
; jonchan's .emacs configuration

;;;; Code:

; Change go-to-line shortcut
(global-set-key "\M-g" 'goto-line)

; Allow overwriting of highlighted text
(delete-selection-mode 1)

; Line numbering
(global-linum-mode 1)
(setq linum-format "%2d \u2502")

; Tabs
(setq-default indent-tabs-mode nil)
(setq tab-width 4)

; Show matching parentheses
(show-paren-mode 1)

; Show unique file path names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

; For .m files
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))

; Require package
(when (>= emacs-major-version 24)
  (require 'package)
  (package-initialize)
  (add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)
  )

; Universal clipboard
(xclip-mode 1)

; C/C++ stuff

; Flycheck
(add-hook 'after-init-hook #'global-flycheck-mode)

; Enable helm-gtags mode
(setq
 helm-gtags-ignore-case t
 helm-gtags-auto-update t
 helm-gtags-use-input-at-cursor t
 helm-gtags-pulse-at-cursor t
 helm-gtags-prefix-key "\C-cg"
 helm-gtags-suggested-key-mapping t
 )

(require 'helm-gtags)

(add-hook 'dired-mode-hook 'helm-gtags-mode)
(add-hook 'eshell-mode-hook 'helm-gtags-mode)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)

(define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
(define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
(define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
(define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
(define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
(define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; General Helm config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'helm)
(require 'helm-config)
(helm-mode 1)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

; Use helm-M-x
(global-set-key (kbd "M-x") 'helm-M-x)

; Use helm show-kill-ring
(global-set-key (kbd "M-y") 'helm-show-kill-ring)

; Use helm-mini with fuzzy matching
(global-set-key (kbd "C-x b") 'helm-mini)
(setq helm-buffers-fuzzy-matching t
      helm-recentf-fuzzy-match    t)

; Use helm-find-files
(global-set-key (kbd "C-x C-f") 'helm-find-files)

; Live grep in ack-grep buffer
(when (executable-find "ack-grep")
  (setq helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f"
        helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))

; Let helm auto-resize its window for itself
(helm-autoresize-mode nil)

; Company mode
(require 'company)
(add-hook 'after-init-hook 'global-company-mode)

; Setup semantic for system headers
(semantic-mode 1)
(semantic-add-system-include "/usr/local/include/" 'c++-mode)
(semantic-add-system-include "/usr/local/include/ceres/" 'c++-mode)
(semantic-add-system-include "/usr/local/include/eigen3/" 'c++-mode)
(semantic-add-system-include "/usr/local/include/vtk-6.2/" 'c++-mode)

; C-default style
;; Available C style:
;; “gnu”: The default style for GNU projects
;; “k&r”: What Kernighan and Ritchie, the authors of C used in their book
;; “bsd”: What BSD developers use, aka “Allman style” after Eric Allman.
;; “whitesmith”: Popularized by the examples that came with Whitesmiths C, an early commercial C compiler.
;; “stroustrup”: What Stroustrup, the author of C++ used in his book
;; “ellemtel”: Popular C++ coding standards as defined by “Programming in C++, Rules and Recommendations,” Erik Nyquist and Mats Henricson, Ellemtel
;; “linux”: What the Linux developers use for kernel development
;; “python”: What Python developers use for extension modules
;; “java”: The default style for java-mode (see below)
;; “user”: When you want to define your own style
(setq
 c-default-style "linux" ;; set style to "linux"
 )

;(add-to-list 'load-path "~/.emacs.d/elpa")
;(require 'xclip)
;(load "xclip")
;(setq x-select-enable-clipboard t)
;(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
;(setq x-select-enable-primary nil)
