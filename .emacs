;;; package --- Summary:

;;;; Commentary:
; jonchan's .emacs configuration

;;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; General stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq USING_WINDOWS (eq system-type 'windows-nt))
(setq USING_LINUX (eq system-type 'gnu/linux))

; Windows specific settings
(when USING_WINDOWS
  ; Color theme
  (add-to-list 'custom-theme-load-path "~/.emacs.d/themes")
  (load-theme 'solarized t)

  ; Use light color themes for emacs GUI, dark for terminal
  (add-hook 'after-make-frame-functions
            (lambda (frame)
              (let ((mode (if (display-graphic-p frame) 'light 'dark)))
                (set-frame-parameter frame 'background-mode mode)
                (set-terminal-parameter frame 'background-mode mode))
              (enable-theme 'solarized)))

  ; Save backup files to a single location instead of current directory
  (setq backup-directory-alist
        `(("." . ,(concat (getenv "APPDATA") "\\.emacs.d\\.saves"))))
  )

(when USING_LINUX
  ; Save backup files to a single location instead of current directory
  (setq backup-directory-alist `(("." . ,"~/.emacs.d/.saves")))
  )

; Set default major mode to text-mode
(setq-default major-mode 'text-mode)

; Disable tool-bar in GUI mode
(tool-bar-mode -1)

; Show matching parentheses
(show-paren-mode 1)

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
(setq indent-line-function 'insert-tab)
(setq c-default-style "linux"
      c-basic-offset 4)

; .cmd and .bat files
(add-hook 'bat-mode-hook (lambda ()
  (setq indent-tabs-mode nil)
  (setq tab-stop-list (number-sequence 0 200 4))
  (setq tab-width 4)
  (setq indent-line-function 'indent-relative)
  (setq tab-always-indent nil) ))

; .ini files
(add-hook 'conf-windows-mode-hook (lambda ()
  (setq indent-tabs-mode nil)
  (setq tab-stop-list (number-sequence 0 200 4))
  (setq tab-width 4)
  (setq indent-line-function 'indent-relative)
  (setq tab-always-indent nil) ))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; General C/C++ stuff
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;; Assume headers are going to be c++ mode
(add-to-list 'auto-mode-alist '("\\.h\\'" . c++-mode))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; Semantic
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(require 'semantic)
(require 'semantic/analyze/debug)

(global-semanticdb-minor-mode 1)
(global-semantic-idle-scheduler-mode 1)
(semantic-mode 1)
;; Case insensitivity
(set-default 'semantic-case-fold t)
(when USING_LINUX
  (semantic-add-system-include "/usr/local/include/" 'c++-mode)
  (semantic-add-system-include "/usr/include/" `c++-mode)
  (semantic-add-system-include "/usr/include/c++/4.8/bits/" `c++-mode)
  (semantic-add-system-include "/usr/local/include/ceres/" 'c++-mode)
  (semantic-add-system-include "/usr/local/include/eigen3/" 'c++-mode)
  (semantic-add-system-include "/usr/local/include/vtk-6.2/" 'c++-mode)
  )

    
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; el-get
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(add-to-list 'load-path "~/.emacs.d/el-get/el-get")

(unless (require 'el-get nil 'noerror)
  (with-current-buffer
      (url-retrieve-synchronously
       "https://raw.githubusercontent.com/dimitri/el-get/master/el-get-install.el")
    (goto-char (point-max))
    (eval-print-last-sexp)))

(add-to-list 'el-get-recipe-path "~/.emacs.d/el-get-user/recipes")
;; (el-get 'sync)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;; package
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;; xclip - Universal clipboard
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;(require 'xclip)
;; ;(xclip-mode 1)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;; vlf - Very large file optimizations
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (require 'vlf-setup)
;; (custom-set-variables
;;  ;; custom-set-variables was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  '(ede-project-directories (quote ("/home/analog/sandbox/src/hello/app")))
;;  '(inhibit-startup-screen t)
;;  '(vlf-application (quote dont-ask)))

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;; C/C++ stuff
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;; Flycheck
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (add-hook 'after-init-hook #'global-flycheck-mode)

;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; ;;;;; helm-gtags
;; ;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;; (setq
;; ;;  helm-gtags-ignore-case t
;; ;;  helm-gtags-auto-update t
;; ;;  helm-gtags-use-input-at-cursor t
;; ;;  helm-gtags-pulse-at-cursor t
;; ;;  helm-gtags-prefix-key "\C-cg"
;; ;;  helm-gtags-suggested-key-mapping t
;; ;;  )

;; ;; (require 'helm-gtags)

;; ;; (add-hook 'dired-mode-hook 'helm-gtags-mode)
;; ;; (add-hook 'eshell-mode-hook 'helm-gtags-mode)
;; ;; (add-hook 'c-mode-hook 'helm-gtags-mode)
;; ;; (add-hook 'c++-mode-hook 'helm-gtags-mode)
;; ;; (add-hook 'asm-mode-hook 'helm-gtags-mode)

;; ;; (define-key helm-gtags-mode-map (kbd "C-c g a") 'helm-gtags-tags-in-this-function)
;; ;; (define-key helm-gtags-mode-map (kbd "C-j") 'helm-gtags-select)
;; ;; (define-key helm-gtags-mode-map (kbd "M-.") 'helm-gtags-dwim)
;; ;; (define-key helm-gtags-mode-map (kbd "M-,") 'helm-gtags-pop-stack)
;; ;; (define-key helm-gtags-mode-map (kbd "C-c <") 'helm-gtags-previous-history)
;; ;; (define-key helm-gtags-mode-map (kbd "C-c >") 'helm-gtags-next-history)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; emacs-async (must come before Helm)
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle!
    async
    ;; :url "https://github.com/jwiegley/emacs-async.git"
    (add-to-list 'load-path "~/.emacs.d/el-get/async")
    )

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;; General Helm config
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle!
  helm
  :features (helm helm-config)
  )
(with-eval-after-load 'helm
  (helm-mode 1)

  ;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
  ;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
  ;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
  (global-set-key (kbd "C-c h") 'helm-command-prefix)
  (global-unset-key (kbd "C-x c"))

  ;; Use helm-M-x
  (global-set-key (kbd "M-x") 'helm-M-x)

  ;; Use helm show-kill-ring
  (global-set-key (kbd "M-y") 'helm-show-kill-ring)

  ;; Use helm-mini with fuzzy matching
  (global-set-key (kbd "C-x b") 'helm-mini)
  (setq helm-buffers-fuzzy-matching t
        helm-recentf-fuzzy-match    t)

  ;; Use helm-find-files
  (global-set-key (kbd "C-x C-f") 'helm-find-files)

  ;; Live grep in ack-grep buffer
  (when (executable-find "ack-grep")
    (setq helm-grep-default-command "ack-grep -Hn --no-group --no-color %e %p %f"
          helm-grep-default-recurse-command "ack-grep -H --no-group --no-color %e %p %f"))

  ;; Let helm auto-resize its window for itself
  (helm-autoresize-mode nil)

  ;; Increase helm-buffer-max-length
  (setq helm-buffer-max-length 45)
  )


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;; Company mode
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle!
    company)
(with-eval-after-load 'company
    (add-hook 'after-init-hook 'global-company-mode)
    )

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;;; Company-jedi backend
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; (defun my/python-mode-hook ()
;;   (add-to-list 'company-backends 'company-jedi))

;; (add-hook 'python-mode-hook 'my/python-mode-hook)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;; function-args
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle!
    function-args
    :url "https://github.com/abo-abo/function-args.git"
    )
(with-eval-after-load 'function-args
    (fa-config-default)
    (define-key c-mode-map  [(control tab)] 'moo-complete)
    (define-key c++-mode-map  [(control tab)] 'moo-complete)
    (define-key c-mode-map (kbd "M-o")  'fa-show)
    (define-key c++-mode-map (kbd "M-o")  'fa-show)
    )


;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;; auto-complete
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(el-get-bundle! auto-complete)
(ac-config-default)

;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ;;;; uniquify
;; ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; ; Show unique file path names
;; (require 'uniquify)
;; (setq uniquify-buffer-name-style 'forward)


; For .m files
(autoload 'octave-mode "octave-mod" nil t)
(setq auto-mode-alist
      (cons '("\\.m$" . octave-mode) auto-mode-alist))
(add-hook 'octave-mode-hook (lambda ()
  (setq indent-tabs-mode nil)
  (setq tab-stop-list (number-sequence 4 200 4))
  (setq tab-width 4)
  (setq indent-line-function 'insert-tab)
  (setq tab-always-indent nil) ))

;; (custom-set-faces
;;  ;; custom-set-faces was added by Custom.
;;  ;; If you edit it by hand, you could mess it up, so be careful.
;;  ;; Your init file should contain only one such instance.
;;  ;; If there is more than one, they won't work right.
;;  )
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(inhibit-startup-screen t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )
