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

; Define ctag functionality (not yet working)
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags %s"(directory-file-name dir-name)))
;   (format "ctags -f %s -e -R %s" path-to-ctags (directory-file-name dir-name)))
  )

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

;(add-to-list 'load-path "~/.emacs.d/elpa")
;(require 'xclip)
;(load "xclip")
;(setq x-select-enable-clipboard t)
;(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
;(setq x-select-enable-primary nil)
