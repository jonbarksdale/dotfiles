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

;; trigger install of all the fonts if they are not already there.
(unless (member "Symbols Nerd Font Mono" (font-family-list))
    (nerd-icons-install-fonts t))


;; remove the binding for scroll line up, because I never use it and want to try getting used to emacs yank binding
(define-key evil-motion-state-map (kbd "C-y") nil)


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

(setq org-roam-mode-section-functions
      (list
       'org-roam-backlinks-section
       'org-roam-reflinks-section
       ;; this is busted right now
       'org-roam-unlinked-references-section
       ))
;; org-roam-capture-templates for captures - maybe a separate file/dir?
;; (setq org-roam-directory "~/Dropbox/org-roam/")

;; close property drawer after capturing
(add-hook 'org-capture-after-finalize-hook
          (lambda ()
            (org-cycle-hide-drawers 'children)))


(setq capture-head
      (with-temp-buffer
        (insert-file-contents "~/.dotfiles/emacs/org/capture-templates/daily.org")
        (buffer-string)))
(defvar daily-file-template "%<%Y-%m-%d>.org" )

;; Set the head of the daily note to be my actual template
(setq org-roam-dailies-capture-templates
      `(("d" "default" entry
          "* %?"
         ;;(file "~/.dotfiles/emacs/org/capture-templates/daily.org")
         :target (file+head ,daily-file-template ,capture-head))
        ))

(defun my/org-roam-dailies-today-file ()
  "Get today's daily notes file path without visiting it"
  (let* ((today (string-trim-right (org-capture-fill-template daily-file-template)))
         (file-path (expand-file-name org-roam-dailies-directory org-roam-directory)))
    (expand-file-name today file-path)))

(setq org-capture-templates
      '(("t" "Daily todo" entry
         (file+headline my/org-roam-dailies-today-file "Actions")
         "* [ ] %?\n%i\n%a" :prepend t :unnarrowed t)

        ("m" "Meeting Notes" entry
         (file+olp my/org-roam-dailies-today-file "Meetings")
         (file "~/.dotfiles/emacs/org/capture-templates/meeting.org")
         :unnarrowed t
         :jump-to-captured t
         )))

(setq org-roam-dailies-directory (file-truename "~/org/roam/dailies/"))

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

;; Enable graphviz/DOT file suport
(org-babel-do-load-languages
 'org-babel-load-languages
 '((dot . t)))

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

;; Allow bind keywords in org export, so I can set per file org-md-toplevel-hlevel to control the heading level
(setq org-export-allow-bind-keywords t)

;; Set default org export settings because i keep forgetting them
(setq org-export-headline-levels 3)
(setq org-export-with-smart-quotes nil)
(setq org-export-with-toc nil)
(setq org-export-with-section-numbers nil)
(setq org-export-with-todo-keywords nil)

;; disabling auto completion, suspecting crashes related to autocompleting.
(after! corfu
  (setq corfu-auto nil))

(use-package! bazel)

(custom-set-variables
 '(conda-anaconda-home "/usr/local/Caskroom/miniconda/base/"))

(add-to-list 'auto-mode-alist '("/BUILD\\(\\..*\\)?\\'" . bazel-mode))
(add-to-list 'auto-mode-alist '("/WORKSPACE\\'" . bazel-mode))
(add-to-list 'auto-mode-alist '("\\.\\(BUILD\\|WORKSPACE\\|bzl\\)\\'" . bazel-mode))

;; add org roam files for id scanning
(setq org-id-extra-files (directory-files-recursively org-roam-directory "org$"))

(use-package! org-ql
  :after org)

;; set it so occur style search results show local context
(add-to-list 'org-show-context-detail '(occur-tree . local))

(after! org
  (defun my/hook (hook)
    "Create an org-link target string using `hook://` url scheme."
    (shell-command (concat "open hook:\"" hook "\"")))
  (org-add-link-type "hook" 'my/hook))


(let ((local-config "~/.emacs.local.el")) (when (file-exists-p local-config) (load local-config)))

;; jq configuration, set up for yaml
(use-package! jq-mode
  :defer t
  :mode ("\\.yq\\'" "\\.jq\\'")
  :config
  (setq jq-interactive-command "yq")
  (setq jq-interactive-font-lock-mode t)
  )

(map! :after (yaml-mode json-mode)
      :map (yaml-mode-map json-mode-map)
      :localleader
      :desc "Start jq-mode" "j" #'jq-interactively)

(org-babel-do-load-languages
 'org-babel-load-languages
 '((jq. t)))

;; enable the ts.el library for time functions, used in snippets
(use-package! ts)

(map! :after evil
      :map (evil-normal-state-map evil-visual-state-map evil-insert-state-map)
      "s-k" #'scroll-other-window-down
      "s-j" #'scroll-other-window
      )
