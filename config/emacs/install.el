;; 1. Open this file with emacs
;; 2. Navigate to the buffer with this file open
;; 3. M-x eval-buffer

(require 'package)
(add-to-list 'package-archives
             '("marmalade" . "http://marmalade-repo.org/packages/"))
(add-to-list 'package-archives
             '("melpa" . "https://melpa.org/packages/"))
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize)

(setq packagesToInstall (list
                         'helm
                         'vlf
                         'company
                         'cc-mode
                         'semantic
                         'function-args
                         'iedit
                         'fzf
                         'flycheck
                         'auto-complete
                         'helm-ag
                         'powershell
                         'helm-swoop
                         'yasnippet
                         'visual-regexp
                         'visual-regexp-steroids
                         'anaconda-mode
                         'company-jedi
                         'csharp-mode
                         'swift3-mode
                         ))

(defun ensure-package-installed (packages)
  "Assure every package is installed, ask for installation if it’s not.

Return a list of installed packages or nil for every skipped package."
  (mapcar
   (lambda (package)
     ;; (package-installed-p 'evil)
     (if (package-installed-p package)
         nil
       (if (y-or-n-p (format "Package %s is missing. Install it? " package))
           (package-install package)
         package)))
   packages))

;; make sure to have downloaded archive description.
;; Or use package-archive-contents as suggested by Nicolas Dudebout
(or (file-exists-p package-user-dir)
    (package-refresh-contents))

(ensure-package-installed packagesToInstall)

