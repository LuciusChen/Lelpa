
An HTTP library that uses curl as a backend.  Inspired by, and some
code copied from, Christopher Wellons's library, elfeed-curl.el.

Why this package?

1.  `url' works well for many things, but it has some issues.
2.  `request' works well for many things, but it has some issues.
3.  Chris Wellons doesn't have time to factor his excellent
    elfeed-curl.el library out of Elfeed.  This will have to do.

Why is it called `plz'?

1.  There's already a package called `http'.
2.  There's already a package called `request'.
3.  Naming things is hard.

;; Usage:

FIXME(v0.10): Remove the following note.

NOTE: In a future version of plz, only one error will be signaled:
`plz-error'.  The existing errors, `plz-curl-error' and
`plz-http-error', inherit from `plz-error' to allow applications to
update their code while using earlier versions (i.e. any
`condition-case' forms should now handle only `plz-error', not the
other two).

Call function `plz' to make an HTTP request.  Its docstring
explains its arguments.  `plz' also supports other HTTP methods,
uploading and downloading binary files, sending URL parameters and
HTTP headers, configurable timeouts, error-handling "else" and
always-called "finally" functions, and more.

Basic usage is simple.  For example, to make a synchronous request
and return the HTTP response body as a string:

  (plz 'get "https://httpbin.org/get")

Which returns the JSON object as a string:

  "{
    \"args\": {},
    \"headers\": {
      \"Accept\": \"*/*\",
      \"Accept-Encoding\": \"deflate, gzip\",
      \"Host\": \"httpbin.org\",
      \"User-Agent\": \"curl/7.35.0\"
    },
    \"origin\": \"xxx.xxx.xxx.xxx\",
    \"url\": \"https://httpbin.org/get\"
  }"

To make the same request asynchronously, decoding the JSON and
printing a message with a value from it:

  (plz 'get "https://httpbin.org/get" :as #'json-read
    :then (lambda (alist) (message "URL: %s" (alist-get 'url alist))))

Which, after the request returns, prints:

  URL: https://httpbin.org/get

;; Credits:

Thanks to Chris Wellons for inspiration, encouragement, and advice.
