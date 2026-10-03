This package provides CJK word segmentation support for Meow modal editing.
Currently supports EMT backend for macOS, with plans to support additional
backends for Linux and Windows.

Usage:

  (require 'meow-cjk)
  (meow-cjk-mode 1)

Or with use-package:

  (use-package meow-cjk
    :after meow
    :config
    (meow-cjk-mode 1))
