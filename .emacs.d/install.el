;; HOME/.emacs.d/install.el

(add-to-list 'package-archives '("org" . "http://orgmode.org/elpa/") t)
(package-refresh-contents)

(if (require 'quelpa nil t)
    (quelpa '(quelpa :repo "qualpa/qualpa" :fetcher github) :upgrade t)
    (with-temp-buffer
      (url-insert-file-contents "https://raw.github.com/quelpa/quelpa/master/bootstrap.el")
      (eval-buffer)))

(setq quelpa-upgrade-p t)

(quelpa 'evil)
(quelpa 'evil-matchit)
(quelpa 'surround)
