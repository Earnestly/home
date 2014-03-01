;; ~/.emacs.d/init.el

(package-initialize)
(add-to-list 'package-archives 
             '("melpa" . "http://melpa.milkbox.net/packages/")
             '("marmalade" . "http://marmalade-repo.org/packages/"))

;; Annoyances
(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; Mostly stolen from better-defaults
(evil-mode t)
(ido-mode t)

(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-s") 'isearch-forward-regexp)
(global-set-key (kbd "C-r") 'isearch-backward-regexp)
(global-set-key (kbd "C-M-s") 'isearch-forward)
(global-set-key (kbd "C-M-r") 'isearch-backward)
(global-set-key (kbd "C-h") 'delete-backward-char)

;; haskell-mode for .hs and .lhs (literate)
(add-to-list 'auto-mode-alist '("^\\.?hs" . haskell-mode))
(add-to-list 'auto-mode-alist '("^\\.?lhs" . haskell-mode))

(load-theme 'wombat t)

(setq vc-follow-symlinks t
      backup-inhibited t
      auto-save-default nil
      x-select-enable-primary t
      mouse-autoselect-window t
      inhibit-splash-screen t
      ido-enable-flex-matching t
      ido-save-directory-list-file "~/.emacs.d/cache/ido.last"
      default-frame-alist '((font . "Inconsolatazi4-12")))
