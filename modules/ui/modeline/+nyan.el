;;; ui/modeline/+nyan.el -*- lexical-binding: t; -*-

(defun +nyan-fit-bar-length (&optional window-width)
  (let ((remaining-width
         (- (or window-width (+ (window-total-width)
                                (or scroll-bar-width 0)
                                (or left-fringe-width 0)
                                (or right-fringe-width 0)
                                (or left-margin-width 0)
                                (or right-margin-width 0)))
            (if (featurep! +light)
                (apply '+ (mapcar
                            (lambda (p)
                              (string-width (format-mode-line `("" ,p))))
                            '(+modeline-format-left +modeline-format-right)))
              ;; TODO Add handle for different format modes.
              (- (string-width (format-mode-line (doom-modeline 'main)))
                 nyan-bar-length)))))
    (setq nyan-bar-length (/ (* remaining-width 7) 8))))

(defun +nyan-window-size-change-function (&rest _)
  "Function for `window-size-change-functions'."
  (let ((+window-total-width (+ (window-total-width)
                                (or scroll-bar-width 0)
                                (or left-fringe-width 0)
                                (or right-fringe-width 0)
                                (or left-margin-width 0)
                                (or right-margin-width 0))))
    (unless (featurep! +light)
      (setq doom-modeline-buffer-file-name-style
            (if (<= +window-total-width
                    (+ 8 doom-modeline-window-width-limit))
                'file-name
              'relative-from-project)))
    (+nyan-fit-bar-length +window-total-width)))

(defun +nyan-persp-activated-function (&rest _)
  (+nyan-fit-bar-length))

(use-package! nyan-mode
  :config
  (add-hook 'window-size-change-functions #'+nyan-window-size-change-function)
  (add-hook 'persp-activated-functions #'+nyan-persp-activated-function)
  (unless (featurep! +light)
    (add-hook! doom-modeline-mode #'nyan-mode)
    ;; It's nice to always have `nyan-mode' on to indicates the buffer position.
    (remove-hook! magit-mode #'+modeline-hide-in-non-status-buffer-h)))
