A unified multi-dictionary interface for Emacs.

Features:
- Support for multiple dictionary sources via adapters
- Capability-based rendering (only shows what each dictionary provides)
- Extensible architecture for adding new dictionaries

Quick start:
  (require 'lexdb)
  (require 'lexdb-ldoce)  ; LDOCE adapter

  ;; Configure LDOCE
  (setq lexdb-ldoce-db-file "~/path/to/ldoce.db")
  (setq lexdb-ldoce-audio-directory "~/path/to/audio/")
  (lexdb-ldoce-register)

  ;; Set as default and use
  (setq lexdb-default-adapter 'ldoce)
  (global-set-key (kbd "C-c d") #'lexdb-search)
