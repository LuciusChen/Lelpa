This small minor mode boosts eglot with emacs-lsp-booster.
Using it is simple:

1. Download/build a recent emacs-lsp-booster from
   https://github.com/blahgeek/emacs-lsp-booster using the
   instructions there.
2. Enable eglot-booster-mode either in your init or, interactively,
   use M-x eglot-booster-mode.
3. Use eglot like normal.

You can disable boosting by turning the minor mode off; any boosted
eglot servers will need to be restarted.  Note: boosting works only
with local lsp servers programs which communicate via standard
input/output, not remote or network-port LSP servers.
