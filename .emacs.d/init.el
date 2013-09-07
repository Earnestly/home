(package-initialize)
(add-to-list 'package-archives 
             '("melpa" . "http://melpa.milkbox.net/packages/") t)

(load-theme 'zenburn t)
(menu-bar-mode -1)

(setq vc-follow-symlinks t)
