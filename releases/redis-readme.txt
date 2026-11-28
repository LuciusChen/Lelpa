Minimal native Redis client for Emacs Lisp.

This package intentionally exposes a small protocol surface: RESP2 over one
TCP connection, one command/response at a time, AUTH, SELECT, and structured
Redis errors.  Bulk strings are returned as unibyte byte strings; callers
should decode them for display with `redis-decode-string'.
