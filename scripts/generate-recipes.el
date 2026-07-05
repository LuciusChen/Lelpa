;;; generate-myelpa-recipes.el --- Generate MyELPA recipes from straight cache -*- lexical-binding: t; -*-

(require 'cl-lib)
(require 'package)

(defvar myelpa-init-file (expand-file-name "~/.emacs.d/init.el"))
(defvar myelpa-build-cache-file (expand-file-name "~/.emacs.d/straight/build-cache.el"))
(defvar myelpa-output-dir nil)

(defvar myelpa-bootstrap-packages
  '("straight" "org-elpa" "melpa" "gnu-elpa-mirror" "nongnu-elpa"
    "el-get" "emacsmirror-mirror" "package-build")
  "Packages that support package management itself, not the user archive.")

(defvar myelpa-supported-recipe-keys
  '(:files :branch :tag :commit :version-regexp :old-names
    :shell-command :make-targets :org-exports))

(defvar myelpa-package-renames
  '(("emacs-smart-input-source" . "sis")
    ("mu" . "mu4e"))
  "Map straight/repository package names to package.el package names.")

(defvar myelpa-recipe-key-removals
  '(("clutch" . (:branch)))
  "Recipe keys to drop for specific package.el package names.")

(defvar myelpa-extra-recipes
  '((ace-jump-mode
     :fetcher github
     :repo "winterTTr/ace-jump-mode")
    (async
     :fetcher github
     :repo "jwiegley/emacs-async")
    (terminal-focus-reporting
     :fetcher github
     :repo "veelenga/terminal-focus-reporting.el"))
  "Additional recipes needed by generated package metadata.")

(defun myelpa--read-use-package-list ()
  "Read `USE-PACKAGE-LIST' roots from `myelpa-init-file'."
  (with-temp-buffer
    (insert-file-contents myelpa-init-file)
    (goto-char (point-min))
    (let (found)
      (while (and (not found) (not (eobp)))
        (let ((form (ignore-errors (read (current-buffer)))))
          (when (and (consp form)
                     (eq (car form) 'defvar)
                     (eq (cadr form) 'USE-PACKAGE-LIST))
            (setq found (eval (caddr form) t)))))
      (unless found
        (error "Could not find USE-PACKAGE-LIST in %s" myelpa-init-file))
      (cl-remove-duplicates
       (mapcar (lambda (entry)
                 (symbol-name (if (consp entry) (car entry) entry)))
               found)
       :test #'string=))))

(defun myelpa--read-straight-cache ()
  "Read straight's package recipe hash from `myelpa-build-cache-file'."
  (with-temp-buffer
    (insert-file-contents myelpa-build-cache-file)
    (goto-char (point-min))
    (read (current-buffer))
    (read (current-buffer))
    (read (current-buffer))))

(defun myelpa--builtin-p (name)
  "Return non-nil when package NAME is built into this Emacs."
  (or (member name '("emacs" "cl-lib"))
      (package-built-in-p (intern name))))

(defun myelpa--entry-deps (entry)
  (nth 1 entry))

(defun myelpa--entry-recipe (entry)
  (nth 2 entry))

(defun myelpa--target-name (name)
  "Return package.el package name for straight package NAME."
  (or (cdr (assoc name myelpa-package-renames))
      name))

(defun myelpa--source-name (name cache)
  "Return the straight cache key for package.el package NAME.
This keeps recipe generation stable while the Emacs configuration is
being migrated from repository names to package.el names."
  (cond
   ((gethash name cache)
    name)
   ((car (rassoc name myelpa-package-renames)))
   (t name)))

(defun myelpa--closure (roots cache)
  "Return (PACKAGES SKIPPED-BUILTINS MISSING) for ROOTS using CACHE."
  (let ((queue roots)
        packages skipped missing seen)
    (while queue
      (let ((name (myelpa--source-name (pop queue) cache)))
        (unless (member name seen)
          (push name seen)
          (cond
           ((member name myelpa-bootstrap-packages))
           ((myelpa--builtin-p name)
            (push name skipped))
           (t
            (let ((entry (gethash name cache)))
              (if (not entry)
                  (push name missing)
                (push name packages)
                (dolist (dep (myelpa--entry-deps entry))
                  (let ((dep (myelpa--source-name dep cache)))
                    (unless (or (member dep seen)
                                (member dep myelpa-bootstrap-packages))
                      (push dep queue)))))))))))
    (list (sort packages #'string<)
          (sort (cl-remove-duplicates skipped :test #'string=) #'string<)
          (sort (cl-remove-duplicates missing :test #'string=) #'string<))))

(defun myelpa--plist-copy-supported (name plist)
  "Copy package-build-supported keys from PLIST."
  (let ((removed-keys (cdr (assoc name myelpa-recipe-key-removals)))
        out)
    (dolist (key myelpa-supported-recipe-keys)
      (when (and (not (memq key removed-keys))
                 (plist-member plist key))
        (let ((value (plist-get plist key)))
          (when (eq key :files)
            (setq value (myelpa--normalize-files value)))
          (when value
            (setq out (plist-put out key value))))))
    out))

(defun myelpa--normalize-files (files)
  "Convert straight FILES specs to package-build-compatible specs."
  (cond
   ((equal files '("*" (:exclude ".git")))
    nil)
   ((and (listp files) (member "*" files))
    (let ((filtered (cl-remove-if
                     (lambda (entry)
                       (or (equal entry "*")
                           (equal entry '(:exclude ".git"))))
                     files)))
      (and filtered
           (if (eq (car filtered) :defaults)
               filtered
             (cons :defaults filtered)))))
   (t files)))

(defun myelpa--repo-url-p (repo)
  (and (stringp repo)
       (string-match-p "\\`\\(?:[a-z]+://\\|[^:/ ]+:\\)" repo)))

(defun myelpa--straight-to-package-build-recipe (name straight-recipe)
  "Convert STRAIGHT-RECIPE for NAME to a package-build recipe sexp."
  (let* ((host (plist-get straight-recipe :host))
         (repo (plist-get straight-recipe :repo))
         (url (plist-get straight-recipe :url))
         (type (or (plist-get straight-recipe :type) 'git))
         (recipe (list (intern name))))
    (cond
     ((memq host '(github gitlab codeberg sourcehut))
      (setq recipe (append recipe (list :fetcher host :repo repo))))
     ((or url (myelpa--repo-url-p repo))
      (setq recipe (append recipe (list :fetcher type :url (or url repo)))))
     ((and (eq type 'git) repo)
      (setq recipe (append recipe (list :fetcher 'git :url repo))))
     (t
      (error "Cannot convert recipe for %s: %S" name straight-recipe)))
    (append recipe (myelpa--plist-copy-supported name straight-recipe))))

(defun myelpa--write-recipe (dir name recipe)
  (with-temp-file (expand-file-name name dir)
    (let ((print-length nil)
          (print-level nil)
          (print-quoted t))
      (pp recipe (current-buffer)))))

(defun myelpa-generate (&optional dry-run)
  "Generate recipes unless DRY-RUN is non-nil."
  (let* ((roots (myelpa--read-use-package-list))
         (cache (myelpa--read-straight-cache))
         (closure (myelpa--closure roots cache))
         (packages (nth 0 closure))
         (skipped (nth 1 closure))
         (missing (nth 2 closure)))
    (when missing
      (message "Missing packages: %s" (mapconcat #'identity missing ", ")))
    (message "Root packages: %d" (length roots))
    (message "Generated packages: %d" (length packages))
    (message "Skipped built-ins: %d" (length skipped))
    (message "Skipped built-ins: %s" (mapconcat #'identity skipped ", "))
    (unless dry-run
      (unless myelpa-output-dir
        (error "myelpa-output-dir is not set"))
      (make-directory myelpa-output-dir t)
      (dolist (old (directory-files myelpa-output-dir t "^[^.]"))
        (delete-file old))
      (dolist (name packages)
        (let ((entry (gethash name cache)))
          (myelpa--write-recipe
           myelpa-output-dir
           (myelpa--target-name name)
           (myelpa--straight-to-package-build-recipe
            (myelpa--target-name name)
            (myelpa--entry-recipe entry)))))
      (dolist (recipe myelpa-extra-recipes)
        (myelpa--write-recipe
         myelpa-output-dir
         (symbol-name (car recipe))
         recipe))
      (with-temp-file (expand-file-name "../PACKAGES.md" myelpa-output-dir)
        (insert "# Generated package set\n\n")
        (insert "Generated from `~/.emacs.d/init.el` and `~/.emacs.d/straight/build-cache.el`.\n\n")
        (insert (format "- Root packages: %d\n" (length roots)))
        (insert (format "- Generated non-built-in packages: %d\n" (length packages)))
        (insert (format "- Extra dependency recipes: %d\n" (length myelpa-extra-recipes)))
        (insert (format "- Skipped built-in packages: %d\n\n" (length skipped)))
        (insert "## Packages\n\n")
        (dolist (name packages)
          (insert "- `" (myelpa--target-name name) "`")
          (unless (string= name (myelpa--target-name name))
            (insert " (from straight package `" name "`)"))
          (insert "\n"))
        (insert "\n## Renamed packages\n\n")
        (dolist (entry myelpa-package-renames)
          (when (member (car entry) packages)
            (insert "- `" (car entry) "` -> `" (cdr entry) "`\n")))
        (insert "\n## Extra dependency recipes\n\n")
        (dolist (recipe myelpa-extra-recipes)
          (insert "- `" (symbol-name (car recipe)) "`\n"))
        (insert "\n## Built-ins skipped\n\n")
        (dolist (name skipped)
          (insert "- `" name "`\n"))
        (when missing
          (insert "\n## Missing from straight cache\n\n")
          (dolist (name missing)
            (insert "- `" name "`\n")))))
    (when missing
      (kill-emacs 2))))

(provide 'generate-myelpa-recipes)
;;; generate-myelpa-recipes.el ends here
