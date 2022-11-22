(unless (package-installed-p 'use-package)
  (package-refresh-contents)
  (package-install 'use-package))
(eval-and-compile
  (setq use-package-always-ensure t
        use-package-expand-minimally t))


;; auto complete
(use-package company
  :hook (after-init . global-company-mode)
  :config (setq company-minimum-prefix-length 1
                company-show-quick-access t))


;; better org mode appearance
(use-package org-bullets
    :config
    (add-hook 'org-mode-hook (lambda () (org-bullets-mode 1))))


;; better window jump
;; (use-package ace-window 
;;     :bind (("M-o" . 'ace-window)))


;; set font size
(set-face-attribute 'default nil :height 180)

;; Add shortcut 'C-d' to duplicate line
(defun duplicate-line (arg)
  "Duplicate current line, leaving point in lower line."
  ; TODO: what *p means?
  ; Set Default argument: p means 1, P means nil
  ; but not sure what * means
  (interactive "*p")

  ;; save the point for undo
  ; Natural: setq buffer-undo-list == set 'buffer-undo-list
  (setq buffer-undo-list (cons (point) buffer-undo-list))

  ;; local variables for start and end of line
  (let ((bol (save-excursion (beginning-of-line) (point)))
        eol)
    (save-excursion

      ;; don't use forward-line for this, because you would have
      ;; to check whether you are at the end of the buffer
      (end-of-line)
      (setq eol (point))

      ;; store the line and disable the recording of undo information
      (let ((line (buffer-substring bol eol))
            (buffer-undo-list t)
            (count arg))
        ;; insert the line arg times
        (while (> count 0)
          (newline)         ;; because there is no newline in 'line'
          (insert line)
          (setq count (1- count)))
        )

      ;; create the undo information
      (setq buffer-undo-list (cons (cons eol (point)) buffer-undo-list)))
    ) ; end-of-let

;; put the point in the lowest line and return
(next-line arg))
(global-set-key (kbd "C-c d") 'duplicate-line)


;; show line numbers
(global-display-line-numbers-mode)

;; autosave package
(use-package super-save
  :ensure t
  :config
  (super-save-mode +1))
(super-save-mode +1)


;; export
(provide 'natural)