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
(setq doom-font (font-spec :family "Victor Mono" :size 14))

;; There are two ways to load a theme. Both assume the theme is installed and
;; available. You can either set `doom-theme' or manually load a theme with the
;; `load-theme' function. This is the default:
(setq doom-theme 'doom-one)

;; If you use `org' and don't want your org files in the default location below,
;; change `org-directory'. It must be set before org loads!
;; May want to separate org dir?
(setq org-directory "~/Dropbox/org-roam/")


;; org-roam config
(setq org-roam-directory "~/Dropbox/org-roam/")
(setq org-roam-dailies-directory "~/Dropbox/org-roam/dailies/")

(setq org-roam-mode-section-functions
      (list
       'org-roam-backlinks-section
       'org-roam-reflinks-section
       ;; this is busted right now
       ;; 'org-roam-unlinked-references-section
      ))
;; org-roam-capture-templates for captures - maybe a separate file/dir?
;; (setq org-roam-directory "~/Dropbox/org-roam/")

;; This determines the style of line numbers in effect. If set to `nil', line
;; numbers are disabled. For relative line numbers, set this to `relative'.
(setq display-line-numbers-type t)

;; projectile search path
;;
(setq projectile-project-search-path '("/Volumes/Unix/workplace/"))

;; Set fill colum to something more reasonable than 80
(setq-default fill-column 120)

(setq ispell-personal-dictionary "~/.aspell.en.pws")

(setq plantuml-indent-level 4)

(after! plantuml-mode
  (set-company-backend! 'plantuml-mode 'plantuml-complete-symbol ))

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

(use-package! ox-gfm
  :after org)
