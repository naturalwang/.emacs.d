;;; init-frame-hooks.el --- Provide specific hooks for GUI/TTY frame creation -*- lexical-binding: t -*-
;;; Commentary:
;;; Code:

(defvar after-make-console-frame-hooks '()
  "Hooks to run after creating a new TTY frame")
(defvar after-make-window-system-frame-hooks '()
  "Hooks to run after creating a new window-system frame")

(defun run-after-make-frame-hooks (frame)
  "Run configured hooks in response to the newly-created FRAME.
Selectively runs either `after-make-console-frame-hooks' or
`after-make-window-system-frame-hooks'"
  (with-selected-frame frame
    (run-hooks (if window-system
                   'after-make-window-system-frame-hooks
                 'after-make-console-frame-hooks))))

(add-hook 'after-make-frame-functions 'run-after-make-frame-hooks)

(defconst sanityinc/initial-frame (selected-frame)
  "The frame (if any) active during Emacs initialization.")

(add-hook 'after-init-hook
          (lambda () (when sanityinc/initial-frame
                  (run-after-make-frame-hooks sanityinc/initial-frame))))

;; Natural: open new window(frame) in the center of screen
;; Solution from: https://christiantietze.de/posts/2021/06/emacs-center-window/
(defun my/frame-recenter (&optional frame)
  "Center FRAME on the screen.
FRAME can be a frame name, a terminal name, or a frame.
If FRAME is omitted or nil, use currently selected frame."
  (interactive)
  (unless (eq 'maximised (frame-parameter nil 'fullscreen))
    (modify-frame-parameters
     frame '((user-position . t) (top . 0.5) (left . 0.5)))))

(add-hook 'after-make-frame-functions 'my/frame-recenter)

(provide 'init-frame-hooks)
;;; init-frame-hooks.el ends here
