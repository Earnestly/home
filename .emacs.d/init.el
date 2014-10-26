;; ~/.emacs.d/init.el

(package-initialize)
(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)

;; Annoyances
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(load-theme 'wombat t)

;; Mostly stolen from better-defaults
(ido-mode t)

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
(global-set-key (kbd "C-h") 'delete-backward-char)

(setq vc-follow-symlinks t
      backup-inhibited t
      auto-save-default nil
      x-select-enable-primary t
      mouse-autoselect-window t
      inhibit-splash-screen t
      ido-enable-flex-matching t
      eyebrowse-wrap-around-p t
      eyebrowse-switch-back-and-forth-p t
      ido-save-directory-list-file "~/.emacs.d/cache/ido.last"
      default-frame-alist '((font . "Inconsolatazi4-12")))
