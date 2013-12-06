;; ~/.emacs.d/init.el

(package-initialize)
(add-to-list 'package-archives 
             '("melpa" . "http://melpa.milkbox.net/packages/")
             '("marmalade" . "http://marmalade-repo.org/packages/"))

(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

;; haskell-mode for .hs and .lhs (literate)
(add-to-list 'auto-mode-alist '("^\\.?hs" . haskell-mode))
(add-to-list 'auto-mode-alist '("^\\.?lhs" . haskell-mode))

(load-theme 'wombat t)

(setq vc-follow-symlinks t
      backup-inhibited t
      auto-save-default nil
      mouse-autoselect-window t)

(set-face-attribute 'default nil :family "CMU Typewriter Text" :height 120)
