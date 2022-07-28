;;; $DOOMDIR/config.el -*- lexical-binding: t; -*-

;; Place your private configuration here! Remember, you do not need to run 'doom
;; sync' after modifying this file!


;; Some functionality uses this to identify you, e.g. GPG configuration, email
;; clients, file templates and snippets.
(setq user-full-name "Jon Barksdale"
      user-mail-address "jon.barksdale@gmail.com")

;; Doom exposes five (optional) variables for controlling fonts in Doom. Here
;; are the three important ones:
;;
;; + `doom-font'
;; + `doom-variable-pitch-font'
;; + `doom-big-font' -- used for `doom-big-font-mode'; use this for
;;   presentations or streaming.
;;
;; They all accept either a font-spec, font string ("Input Mono-12"), or xlfd
;; font string. You generally only need these two:
;; (setq doom-font (font-spec :family "monospace" :size 12 :weight 'semi-light)
;;       doom-variable-pitch-font (font-spec :family "sans" :size 13))
;;
(if (x-family-fonts "VictorMono Nerd Font")
    (setq doom-font (font-spec :family "VictorMono Nerd Font" :size 14))
  (if (x-family-fonts "Victor Mono")
      (setq doom-font (font-spec :family "Victor Mono" :size 14))
    ))

(if (x-family-fonts "Symbola")
    (setq doom-unicode-font (font-spec :family "Symbola" :size 14)))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function.
(setq doom-theme 'doom-monokai-machine)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; May want to separate org dir?
(setq org-directory (file-truename "~/org/"))

(after! org
  (setq org-todo-keywords
        '((sequence
           "TODO(t)"  ; A task that needs doing & is ready to do
           "NEXT(n)"  ; Next action for a project
           "STRT(s)"  ; A task that is in progress
           "WAIT(w)"  ; Something external is holding up this task
           "HOLD(h)"  ; This task is paused/on hold because of me
           "IDEA(i)"  ; An unconfirmed and unapproved task or notion
           "PROJ(p)"  ; A project, which usually contains other tasks
           "LOOP(r)"  ; A recurring task
           "|"
           "DONE(d)"  ; Task successfully completed
           "KILL(k)") ; Task was cancelled, aborted or is no longer applicable
          (sequence
           "[ ](T)"   ; A task that needs doing
           "[-](S)"   ; Task is in progress
           "[?](W)"   ; Task is being held up or paused
           "|"
           "[X](D)")  ; Task was completed
          )
        org-todo-keyword-faces
        '(("[-]"  . +org-todo-active)
          ("STRT" . +org-todo-active)
          ("[?]"  . +org-todo-onhold)
          ("WAIT" . +org-todo-onhold)
          ("HOLD" . +org-todo-onhold)
          ("PROJ" . +org-todo-project)
          ("KILL" . +org-todo-cancel)))
  )

;; org-roam config
(setq org-roam-directory (file-truename "~/org/roam/"))
(setq org-roam-dailies-directory (file-truename "~/org/roam/dailies/"))

(setq org-roam-mode-section-functions
      (list
       'org-roam-backlinks-section
       'org-roam-reflinks-section
       ;; this is busted right now
       'org-roam-unlinked-references-section
       ))
;; org-roam-capture-templates for captures - maybe a separate file/dir?
;; (setq org-roam-directory "~/Dropbox/org-roam/")
;;

;;(setq! citar-bibliography `(,(file-truename "~/org/roam/zotero.bib")))
(setq! citar-bibliography (file-truename "~/org/roam/zotero.bib"))

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; projectile search path
;; magic - ` for invoking a template system, then , preceding expressions to evaluate
(setq projectile-project-search-path `( ,(file-truename "~/workspace/")))

;; Set fill colum to something more reasonable than 80
(setq-default fill-column 120)

(setq ispell-personal-dictionary "~/.aspell.en.pws")

(setq plantuml-indent-level 4)

(after! plantuml-mode
  (set-company-backend! 'plantuml-mode 'plantuml-complete-symbol ))

(use-package! ox-gfm
  :after org)

;; start edit server, so it can be used with the browser plugins "edit with emacs"
;; Don't do this automatically - if there is no plugin waiting (in firefox, for example) - it eats all keystrokes
;;(edit-server-start)

;; allow visual mark mode to be toggled
(map! :leader
      :desc "Visual marks"
      "t `" #'evil-visual-mark-mode)

(use-package! evil-owl
  :after evil
  :custom
  (evil-owl-idle-delay 0.5)
  (evil-owl-max-string-length 100)
  :config
  (evil-owl-mode))

;; enable quickscope
(use-package! evil-quickscope
  :config
  (global-evil-quickscope-mode 1))

;; Attempt to fix cleverparens mode
(add-hook 'emacs-lisp-mode-hook #'evil-cleverparens-mode)
(add-hook 'clojure-mode-hook #'evil-cleverparens-mode)
(add-hook 'clojurescript-mode-hook #'evil-cleverparens-mode)
(add-hook 'cider-repl-mode-hook #'evil-cleverparens-mode)

;; adds text objects (f) for form, (d) for defun, (c) for comment (emacs style)
(use-package! evil-cleverparens-text-objects)

(map! :leader
      :desc "cleverparens mode"
      "t (" #'evil-cleverparens-mode)


;; Here are some additional functions/macros that could help you configure Doom:
;;
;; - `load!' for loading external *.el files relative to this one
;; - `use-package!' for configuring packages
;; - `after!' for running code after a package has loaded
;; - `add-load-path!' for adding directories to the `load-path', relative to
;;   this file. Emacs searches the `load-path' when you load packages with
;;   `require' or `use-package'.
;; - `map!' for binding new keys
;;
;; To get information about any of these functions/macros, move the cursor over
;; the highlighted symbol at press 'K' (non-evil users must press 'C-c c k').
;; This will open documentation for it, including demos of how they are used.
;;
;; You can also try 'gd' (or 'C-c c d') to jump to their definition and see how
;; they are implemented.

;; enable confluence exporter for org
(use-package! ox-confluence)

(use-package! org-transclusion
  :defer
  :after org
  :init
  (map!
   :map global-map "<f12>" #'org-transclusion-add
   :leader
   :prefix "n"
   :desc "Org Transclusion Mode" "t" #'org-transclusion-mode)
  (map!
   :map org-mode-map
   :localleader
   (:prefix "l"
    :desc "Add excerpt - Org Transclusion " "e" #'org-transclusion-add
    :desc "Make excerpt from link - org-transclusion" "E" #'org-transclusion-make-from-link
    )))

;; add org roam files for id scanning
(setq org-id-extra-files (directory-files-recursively org-roam-directory "org$"))

(use-package! org-ql
  :after org)

(after! org
  (defun my/hook (hook)
    "Create an org-link target string using `hook://` url scheme."
    (shell-command (concat "open hook:\"" hook "\"")))
  (org-add-link-type "hook" 'my/hook))

(global-set-key (kbd "s-j") #'scroll-other-window-down)
(global-set-key (kbd "s-k") #'scroll-other-window)

(let ((local-config "~/.emacs.local.el")) (when (file-exists-p local-config) (load local-config)))
