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

; Define ctag functionality (not yet working)
(defun create-tags (dir-name)
  "Create tags file."
  (interactive "DDirectory: ")
  (shell-command
   (format "ctags %s"(directory-file-name dir-name)))
;   (format "ctags -f %s -e -R %s" path-to-ctags (directory-file-name dir-name)))
  )
