This package provides Han word segmentation support for Meow modal editing.
It uses the EMT backend, which is backed by jieba-rs.

Usage:

  (require 'meow-cjk)
  (meow-cjk-mode 1)

Or with use-package:

  (use-package meow-cjk
    :after meow
    :config
    (meow-cjk-mode 1))
