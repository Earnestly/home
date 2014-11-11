;; HOME/.emacs.d/init.el

(setq package-enable-at-startup nil)
(package-initialize)

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(add-to-list 'package-archives '("melpa" . "http://melpa.milkbox.net/packages/") t)

(add-to-list 'load-path (concat user-emacs-directory "setup"))

(require 'setup-keybinds)

;; evil-mode
(evil-mode t)
(global-evil-matchit-mode)

;; Annoyances.
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(load-theme 'wombat t)

;; Mostly stolen from better-defaults.
(ido-mode t)

(setq vc-follow-symlinks t
      backup-inhibited t
      auto-save-default nil
      x-select-enable-primary t
      mouse-autoselect-window t
      inhibit-splash-screen t
      ido-enable-flex-matching t
      ido-save-directory-list-file "~/.emacs.d/cache/ido.last"
      default-frame-alist '((font . "Inconsolatazi4-12")))
