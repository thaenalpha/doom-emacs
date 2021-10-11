;;; ui/modeline/+nyan.el -*- lexical-binding: t; -*-

(defun +nyan-fit-bar-length ()
    (setq nyan-bar-length
     (/ (* (- (window-width)
              (apply '+ (mapcar (lambda (p)
                                 (string-width
                                  (format-mode-line `("" ,p))))
                         '(+modeline-format-left +modeline-format-right)))) 7) 8)))

(+nyan-fit-bar-length)
(nyan-mode 1)
