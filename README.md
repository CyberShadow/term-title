term-title
==========

This is a simple Emacs package which synchronizes frame titles with
Xterm-compatible terminal emulators.

It is loosely based on Noah S. Friedman's [`xterm-title`](http://www.splode.com/~friedman/software/emacs-lisp/src/xterm-title.el).
Creating `term-title` was motivated by `xterm-title` being unmaintained and no longer working on Emacs 28.

Unlike `xterm-title`, `term-title` uses a simpler, more universal method of setting the window title.
As such, it does not have the capability to separately set the icon title, or to restore the old title upon exit.


Usage
-----

```emacs-lisp
(require 'term-title)
(term-title-mode)
```
