;;; term-title.el --- Synchronize Emacs frame title with terminal title

;; Copyright (C) 2021 Vladimir Panteleev
;; Copyright (C) 2004 Noah S. Friedman

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation; either version 2, or (at your option)
;; any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program; if not, you can either send email to this
;; program's maintainer or write to: The Free Software Foundation,
;; Inc.; 59 Temple Place, Suite 330; Boston, MA 02111-1307, USA.

;;; Commentary:

;; Loosely based on xterm-title by Noah S. Friedman.

;; Please see the README.md file accompanying this file for
;; documentation.

;;; Code:

(defcustom term-title-format nil
  "Window title string to use for terminal windows.

This variable takes precedence over the usual manner of setting
frame titles in Emacs (see variables `frame-title-format' and
`mode-line-format').  If nil, it is ignored."
  :group 'terminals
  :type '(choice
          (string :tag "Literal text")
          (sexp   :tag "Dynamic title (see variable `mode-line-format')")))


(define-minor-mode term-title-mode
  "Synchronize terminal window titles with the selected Emacs tty frame.

Note that if the mode is later disabled, or emacs is exited
normally, the original title is not restored."
  :global t
  :group 'terminals
  :init-value nil
  (if term-title-mode
      (add-hook 'post-command-hook 'term-title--update)
    (remove-hook 'post-command-hook 'term-title--update)))

(defun term-title--update ()
  "Synchronize terminal window title with the selected Emacs frame, if it is a tty."
  (when (eq (framep-on-display) t)
    (let ((title (format-mode-line (or term-title-format
				       (frame-parameter nil 'title)
				       ;; This would mimic the semantics in X but since
				       ;; frame ttys always have a name (even if just
				       ;; the default "F<n>"), don't bother.
				       ;;
				       ;;(frame-parameter nil 'name)
				       frame-title-format)))
	  (frame (selected-frame)))
      (unless (string-equal title (frame-parameter frame 'term-title-last-title))
	(term-title--set title)
	(set-frame-parameter frame 'term-title-last-title title)))))

(defun term-title--set (title)
  "Unconditionally set the current TTY terminal's title."

  (send-string-to-terminal (format "\e]0;%s\a" title)))

(provide 'term-title)

;;; term-title.el ends here