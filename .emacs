; Detect OS
;(setq IS_LINUX (eq system-type `gnu/linux))

; Change go-to-line shortcut
(global-set-key "\M-g" 'goto-line)

; Allow overwriting of highlighted text
(delete-selection-mode 1)

; Line numbering
(global-linum-mode 1)
(setq linum-format "%d  ")

; Tabs
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)

; Show unique file path names
(require 'uniquify)
(setq uniquify-buffer-name-style 'forward)

; Save backup files to a single location instead of current directory
(setq backup-directory-alist `(("." . ,"C:\\Users\\jonchan\\AppData\\Roaming\\.emacs.d\\.saves")))

;(add-to-list 'load-path "~/.emacs.d/elpa")
;(require 'xclip)
;(load "xclip")
;(xclip-mode 1)
;(setq x-select-enable-clipboard t)
;(setq interprogram-paste-function 'x-cut-buffer-or-selection-value)
;(setq x-select-enable-primary nil)
