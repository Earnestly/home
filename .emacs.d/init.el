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

(custom-set-faces
 '(default
    ((t (:inherit nil :stipple nil :background "#242424" :foreground "#f6f3e8" :inverse-video nil :box nil :strike-through nil :overline nil 
		  :underline nil :slant normal :weight normal :height 130 :width normal :family "Consolas")))))
