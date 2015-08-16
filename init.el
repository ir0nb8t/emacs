;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;; Emacs Configuration File ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;    Author: David Harris      ;;;
;;; email: ir0n8t@protonmail.com ;;;
;;;      license: GPLv3          ;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Package management
(require 'package)
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(add-to-list 'package-archives
	     '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives
	     '("marmalade" . "http://marmalade-repo.org/packages/") t)

;;default packages variable
(require 'cl)
(defvar packages-list 
  '(auto-complete
    helm
    org
    org-ac
    magit
    yasnippet
    elpy)
"List of packages needing to be installed at launch")

;; check package installed
(defun has-package-not-installed ()
  (loop for p in packages-list
        when (not (package-installed-p p)) do (return t)
        finally (return nil)))
(when (has-package-not-installed)

;; Check for new packages (package versions)
  (message "%s" "Get latest versions of all packages...")
  (package-refresh-contents)
  (message "%s" " done.")
  ;; Install the missing packages
  (dolist (p packages-list)
    (when (not (package-installed-p p))
      (package-install p))))

;;;;;;;;;;;;;;;;;;;;
;;; Theme config ;;;
;;;;;;;;;;;;;;;;;;;;

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (solarized-dark)))
 '(custom-safe-themes
   (quote
    ("8aebf25556399b58091e533e455dd50a6a9cba958cc4ebb0aab175863c25b9a4" default))))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:inherit nil :stipple nil :background "#002b36" :foreground "#839496" :inverse-video nil :box nil :strike-through nil :overline nil :underline nil :slant normal :weight normal :height 128 :width normal :foundry "unknown" :family "Source Code Pro")))))

;;; splash screen
(setq inhibit-splash-screen t
      initial-scratch-message nil)

;;; Windows mods
(when window-system
  (tooltip-mode -1)
  (tool-bar-mode -1)
  (menu-bar-mode -1)
  (scroll-bar-mode -1))

;;; Shorten Yes and No prompts
(defalias 'yes-or-no-p 'y-or-n-p)

;;; Parethesis Highlighting
(show-paren-mode t)

;;;;;;;;;;;;;;;;;;;
;;; Helm config ;;;
;;;;;;;;;;;;;;;;;;;

(require 'helm)
(require 'helm-config)

;; The default "C-x c" is quite close to "C-x C-c", which quits Emacs.
;; Changed to "C-c h". Note: We must set "C-c h" globally, because we
;; cannot change `helm-command-prefix-key' once `helm-config' is loaded.
(global-set-key (kbd "C-c h") 'helm-command-prefix)
(global-unset-key (kbd "C-x c"))

(define-key helm-map (kbd "<tab>") 'helm-execute-persistent-action) ; rebind tab to run persistent action
(define-key helm-map (kbd "C-i") 'helm-execute-persistent-action) ; make TAB works in terminal
(define-key helm-map (kbd "C-z")  'helm-select-action) ; list actions using C-z

(when (executable-find "curl")
  (setq helm-google-suggest-use-curl-p t))

(setq helm-split-window-in-side-p           t ; open helm buffer inside current window, not occupy whole other window
      helm-move-to-line-cycle-in-source     t ; move to end or beginning of source when reaching top or bottom of source.
      helm-ff-search-library-in-sexp        t ; search for library in `require' and `declare-function' sexp.
      helm-scroll-amount                    8 ; scroll 8 lines other window using M-<next>/M-<prior>
      helm-ff-file-name-history-use-recentf t)

(helm-mode 1)

;;;;;;;;;;;;;;;;;;;;;;;;
;;; Yasnippet config ;;;
;;;;;;;;;;;;;;;;;;;;;;;;

(yas-global-mode 1)
(setq yas-snippet-dirs
      '("~/dotfiles/snippets"                 ;; personal snippets
	))

;;;;;;;;;;;;;;;;;;;;
;;; AutoComplete ;;;
;;;;;;;;;;;;;;;;;;;;

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/ac-dict")
(ac-config-default)

;;; set the trigger key so that it can work together with yasnippet on tab key,
;;; if the word exists in yasnippet, pressing tab will cause yasnippet to
;;; activate, otherwise, auto-complete will

(ac-set-trigger-key "TAB")
(ac-set-trigger-key "<tab>")

;;;;;;;;;;;;;;;;;
;;; elpy mode ;;;
;;;;;;;;;;;;;;;;;
(package-initialize)
(elpy-enable)
(add-to-list 'auto-mode-alist '("\\.\\(pyw\\|py\\)$" . python-mode))

;;;;;;;;;;;;;;;;;;;;;;;
;;; Org-mode Config ;;;
;;;;;;;;;;;;;;;;;;;;;;;

(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(require 'org)
(global-set-key (kbd "C-c c") 'org-capture)
(define-key global-map "\C-cl" 'org-store-link)
(define-key global-map "\C-ca" 'org-agenda)
(setq org-log-done t)

(setq org-agenda-files (list "~/org/org-tasks/home.org"
			     "~/org/org-tasks/work.org"))

;;;;;;;;;;;;;;;;;;;;;;;
;;;Capture Templates;;;
;;;;;;;;;;;;;;;;;;;;;;;
(setq org-capture-templates
      '(("h"                ; hot key
	 "Todo list home"   ; name
	 entry              ; type
	 ; heading type and title
	 (file+datetree "~/org/org-tasks/home.org")
	 "* TODO %?\n %i\n %a") ;template
	 ("i"                ; hot key
	  "Ideas Journal" ; name
	  entry              ; type
	  ; heading type and title
	  (file+headline "~/org/journal/writingJournal.org" "Ideas Journal")
	  "* %?\nEntered on %U\n %i\n %a") ; template
	 ("j"                ; hot key
	  "Personal Journal" ; name
	  entry              ; type
	  ; heading type and title
	  (file+headline "~/org/journal/journal.org" "Personal Journal")
	  "* %?\nEntered on %U\n %i\n %a") ; template
	 ("t"                ; hot key
	  "Tech Notes" ; name
	  entry              ; type
	  ; heading type and title
	  (file+headline "~/org/notes/infoTechNotes.org" "Tech Journal")
	  "* %?\nEntered on %U\n %i\n %a") ; template
	 ("w"               ; hot key
	 "Todo list work"   ; name
	 entry              ; type
	 ; heading type and title
         (file+datetree "~/org/org-tasks/work.org")
	 "* TODO %?\n %i\n %a") ; template
	))
