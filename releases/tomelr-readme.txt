tomelr.el is a library for converting Lisp data expressions or
S-expressions to TOML format (https://toml.io/en/).

It has one entry point `tomelr-encode' which accepts a Lisp data
expression, usually in an alist or plist form, and return a string
representing the TOML serializaitno format.

Example using an alist as input:

    (tomelr-encode '((title . "My title")
                     (author . "Me")
                     (params . ((foo . 123)))))

 Output:

    title = "My title"
    author = "Me"
    [params]
      foo = 123

Example using an plist as input:

    (tomelr-encode '(:title "My title"
                     :author "Me"
                     :params (:foo 123)))

 Above snippet will give as the same TOML output shown above.

See the README.org on https://github.com/kaushalmodi/tomelr/ for
more examples and package details.
