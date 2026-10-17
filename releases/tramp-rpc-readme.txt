This package provides a TRAMP backend that uses a custom RPC server
instead of parsing shell command output.  This significantly improves
performance for remote file operations.

Once installed, just access files using the "rpc" method:
  /rpc:user@host:/path/to/file

The package autoloads automatically - no (require 'tramp-rpc) needed.

FEATURES:
- Fast file operations via binary RPC protocol
- Async process support (make-process, start-file-process)
- VC mode integration works (git, etc.)

HOW ASYNC PROCESSES WORK:
Remote processes are started via RPC and polled periodically for output.
A local pipe process serves as a relay to provide Emacs process semantics.
Process filters, sentinels, and signals all work as expected.

OPTIONAL CONFIGURATION:
If you experience issues with diff-hl in dired, you can disable it:
  (setq diff-hl-disable-on-remote t)

AUTHENTICATION:
When ControlMaster is enabled (default), tramp-rpc establishes the SSH
ControlMaster connection first, which supports both key-based and password
authentication.  If your SSH key isn't available, you'll be prompted for
a password.  Subsequent operations reuse this connection without prompting.
