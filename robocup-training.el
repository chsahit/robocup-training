;;; robocup-training.el --- generation scripts for robocup-training

;; Copyright (C) 2016-2017 Jay Kamat
;; Author: Jay Kamat <jaygkamat@gmail.com>
;; Version: 1.0
;; Keywords: robocup,training,revealjs
;; URL: https://github.com/RoboJackets/robocup-training
;; Package-Requires: ((emacs "25.0") (ox-gfm) (htmlize) (ox-reveal))
;;; Commentary:
;;; Creates and builds org project files for robocup training.

;; To run: cask eval "(progn (require 'robocup-training) (my-org-publish))" in the root of the project.

(require 'ox-reveal)
(require 'ox-publish)
(require 'ox-gfm)

;;; Code:

;; Force htmlize to activate even in nogui mode:
;; https://stackoverflow.com/questions/3591337/emacs-htmlize-in-batch-mode
;; http://sebastien.kirche.free.fr/emacs_stuff/elisp/my-htmlize.el
;; Get fancy colors! (but this will screw up your native emacs install)
(when noninteractive
  ;; Don't run in interactive mode to avoid breaking your colors
  (custom-set-faces
    ;; Draculized minimal: https://github.com/jgkamat/darculized
    ;; TODO find out why default face is not applying.
    '(default                      ((t (:foreground "#909396" :background "#262626"))))
    '(font-lock-builtin-face       ((t (:foreground "#598249"))))
    '(font-lock-comment-face       ((t (:foreground "#5e6263"))))
    '(font-lock-constant-face      ((t (:foreground "#15968D"))))
    '(font-lock-function-name-face ((t (:foreground "#2F7BDE"))))
    '(font-lock-keyword-face       ((t (:foreground "#598249"))))
    '(font-lock-string-face        ((t (:foreground "#15968D"))))
    '(font-lock-type-face		       ((t (:foreground "#598249"))))
    '(font-lock-variable-name-face ((t (:foreground "#2F7BDE"))))
    '(font-lock-warning-face       ((t (:foreground "#bd3832" :weight bold)))))

  (setq htmlize-use-rgb-map 'force)
  (require 'htmlize))

(let ((proj-base (file-name-directory load-file-name)))
  (setq org-publish-project-alist
    `(("rc-slides"
        :recursive t
        :base-directory ,(concat proj-base "./src")
        :publishing-directory ,(concat proj-base "/html/slides/")
        :publishing-function org-reveal-publish-to-reveal
        :exclude-tags ("docs"))
       ("rc-docs"
         :recursive t
         :base-directory ,(concat proj-base "./src")
         :publishing-directory ,(concat proj-base "/html/docs/")
         :publishing-function org-gfm-publish-to-gfm
         :exclude-tags ("slides")))
    org-reveal-root "https://cdn.jsdelivr.net/reveal.js/3.0.0/"
    org-reveal-margin "0.22"))


(defun my-org-publish ()
  "Overwrite's my (jay's) personal publishing file to publish everything.
Also provides a script to run to publish this project."
  (interactive)
  ;; Don't make backup files when generating (cask)
  (let ((make-backup-files nil))
    (org-publish-all t)))

(require 'ob-python)
(setq org-babel-python-command "python3")
;; Make indentation actually matter in org src blocks
(setq org-src-preserve-indentation t)

(when noninteractive
  ;; Don't ask for evaluation
  (defun my-org-confirm-babel-evaluate (lang body)
    "Stop org mode from complaining about python.
LANG language input
BODY code body"
    (not (string= lang "python")))
  (setq org-confirm-babel-evaluate 'my-org-confirm-babel-evaluate))

(provide 'robocup-training)

;;; robocup-training.el ends here
