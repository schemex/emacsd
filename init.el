;; -*-no-byte-compile: t; -*-

;;; ==================================================================
;;; Personal Info
;;; ==================================================================
(setq user-mail-address "jason_he@me.com")
(setq user-full-name    "jason_he")

;;; ==================================================================
;;; load-path
;;; ==================================================================
(add-to-list 'load-path (expand-file-name "~/.emacs.d"))

;; (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
;;     (normal-top-level-add-subdirs-to-load-path))

;;  add subdirectory to load-path
;; (defun hx-add-subdirs-to-load-path (parent-dir)
;;   "Adds every non-hidden subdir of PARENT-DIR to `load-path'."
;;   (let* ((default-directory parent-dir))
;;     (progn
;;       (setq load-path
;;             (append
;;              (loop for dir in (directory-files parent-dir)
;;                    unless (string-match "^\\." dir)
;;                    collecting (expand-file-name dir))
;;              load-path)))))

;; (hx-add-subdirs-to-load-path "~/.emacs.d/site-lisp/")

;; 一些有用的常量，用来做一些判断
(defconst *is-a-mac* (eq system-type 'darwin))
(defconst *is-carbon-emacs* (eq window-system 'mac))
(defconst *is-cocoa-emacs* (and *is-a-mac* (eq window-system 'ns)))

;;; ==================================================================
;;; sane
;;; ==================================================================
(setq-default
 blink-cursor-delay 0
 blink-cursor-interval 1
 bookmark-default-file "~/.emacs.d/.bookmarks.el"
 buffers-menu-max-size 30
 case-fold-search nil
 column-number-mode t
 compilation-scroll-output t
 cursor-type 'bar
 delete-by-moving-to-trash t
 ediff-split-window-function 'split-window-horizontally
 ediff-window-setup-function 'ediff-setup-windows-plain
 fill-column 80
 frame-title-format "%b (%f)"
 grep-highlight-matches t
 grep-scroll-output t
 indent-tabs-mode nil
 line-spacing 0.25
 make-backup-files nil
 mouse-yank-at-point t
 scroll-conservatively 10000
 set-mark-command-repeat-pop t
 show-trailing-whitespace t
 tooltip-delay 1.5
 truncate-lines nil
 truncate-partial-width-windows nil
 use-dialog-box nil
 use-file-dialog nil
 visible-bell t)

;; 在 create new buffer 之前是否进行确认
;; (setq confirm-nonexistent-file-or-buffer 'after-completion)

(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)
(fset 'yes-or-no-p 'y-or-n-p)
(transient-mark-mode t)
(global-auto-revert-mode)
(put 'upcase-region 'disabled nil)
(put 'downcase-region 'disabled nil)
(put 'narrow-to-region 'disabled nil)
(put 'narrow-to-page 'disabled nil)
(put 'narrow-to-defun 'disabled nil)
(fset 'yes-or-no-p 'y-or-n-p)
(transient-mark-mode t)
(global-auto-revert-mode)
(dolist (hook '(term-mode-hook comint-mode-hook dired-mode-hook eshell-mode-hook))
  (add-hook hook
   (lambda () (setq show-trailing-whitespace nil))))

(setq inhibit-startup-screen t)
(setq inhibit-startup-echo-area-message t)

(when (fboundp 'tool-bar-mode)
  (tool-bar-mode -1))
(when (fboundp 'set-scroll-bar-mode)
  (set-scroll-bar-mode nil))
(when (fboundp 'menu-bar-mode)
  (unless window-system
    (menu-bar-mode -1)))

(add-hook 'before-save-hook (lambda ()
                              (whitespace-cleanup)
                              (time-stamp)))

(add-hook 'text-mode-hook 'turn-on-auto-fill)
(add-hook 'markdown-mode-hook 'turn-on-auto-fill)

;;; ==================================================================
;;; frame setup
;;; ==================================================================

(defvar after-make-console-frame-hooks '()
  "Hooks to run after creating a new TTY frame")
(defvar after-make-window-system-frame-hooks '()
  "Hooks to run after creating a new window-system frame")

(defun run-after-make-frame-hooks (frame)
  "Run configured hooks in response to the newly-created FRAME.
Selectively runs either `after-make-console-frame-hooks' or
`after-make-window-system-frame-hooks'"
  (with-selected-frame frame
    (run-hooks (if window-system
                   'after-make-window-system-frame-hooks
                 'after-make-console-frame-hooks))))

;;  在创建 frame 之后运行
(add-hook 'after-make-frame-functions 'run-after-make-frame-hooks)
(add-hook 'after-make-frame-functions
          (lambda (frame)
            (with-selected-frame frame
              (unless window-system
                (set-frame-parameter nil 'menu-bar-lines 0)))))

;; mode-line modification
(setq-default mode-line-format
              (quote
               (#("-" 0 1
                  (help-echo
                   "mouse-1: select window, mouse-2: delete others ..."))
                mode-line-mule-info
                mode-line-modified
                mode-line-frame-identification
                "    "
                mode-line-buffer-identification
                "    "
                (:eval (substring
                        (system-name) 0 (string-match "\\..+" (system-name))))
                ":"
                default-directory
                #(" " 0 1
                  (help-echo
                   "mouse-1: select window, mouse-2: delete others ..."))
                (line-number-mode " Line %l ")
                global-mode-string
                #("   %[(" 0 6
                  (help-echo
                   "mouse-1: select window, mouse-2: delete others ..."))
                (:eval (mode-line-mode-name))
                mode-line-process
                minor-mode-alist
                #("%n" 0 2 (help-echo "mouse-2: widen" local-map (keymap ...)))
                ")%] "
                (-3 . "%P")
                ;;   "-%-"
                )))

;;; ==================================================================
;;; prog setup
;;; ==================================================================
(add-hook 'prog-mode-hook (lambda () (show-paren-mode)))

;;; ==================================================================
;;; dired setup
;;; ==================================================================
(eval-after-load 'dired
  '(progn
     (require 'dired+)
     (setq dired-recursive-deletes 'top)
     (define-key dired-mode-map [mouse-2] 'dired-find-file)))

;;; ==================================================================
;;; xterm setup
;;; ==================================================================

(defun fix-up-xterm-control-arrows ()
  (let ((map (if (boundp 'input-decode-map)
                 input-decode-map
               function-key-map)))
    (define-key map "\e[1;5A" [C-up])
    (define-key map "\e[1;5B" [C-down])
    (define-key map "\e[1;5C" [C-right])
    (define-key map "\e[1;5D" [C-left])
    (define-key map "\e[5A"   [C-up])
    (define-key map "\e[5B"   [C-down])
    (define-key map "\e[5C"   [C-right])
    (define-key map "\e[5D"   [C-left])))

(add-hook 'after-make-console-frame-hooks
          (lambda ()
            (when (< emacs-major-version 23)
              (fix-up-xterm-control-arrows))
            ;; (xterm-mouse-mode 1)
            ;; (mwheel-install)
            ))

;;; ==================================================================
;;; basic setup
;;; ==================================================================
;;; Tips
;; 通过 system-type 来判断系统类型
;; 通过 window-system 来判断当前使用的窗口系统
;; 通过 getenv 和 setenv 来获取和设置 环境变量

(defun hx-simply ()
  (setq inhibit-startup-screen 1)
  (if (not window-system)
    (menu-bar-mode -1)))
(add-hook 'window-setup-hook 'hx-simply)

;; mode hook list
(setq hx-hooks '(lisp-mode-hook
                 emacs-lisp-mode-hook
                 scheme-mode-hook
                 clojure-mode-hook
                 ruby-mode-hook
                 yaml-mode
                 python-mode-hook
                 shell-mode-hook
                 php-mode-hook
                 css-mode-hook
                 haskell-mode-hook
                 caml-mode-hook
                 nxml-mode-hook
                 crontab-mode-hook
                 perl-mode-hook
                 tcl-mode-hook
                 javascript-mode-hook))

(add-hook 'emacs-lisp-mode-hook
          (lambda () (message "hello emacs lisp mode")))

;;; ==================================================================
;;; spell checking
;;; ==================================================================
(when (executable-find "aspell")
  (setq ispell-program-name "aspell"
        ispell-extra-args '("--sug-mode=ultra")))

;; (add-hook 'tcl-mode-hook 'flyspell-prog-mode)

;; text-faces
;; (add-hook 'nxml-mode-hook
;;           (lambda ()
;;             (add-to-list 'flyspell-prog-text-faces 'nxml-text-face)))

;;; ==================================================================
;;; 一些兼容性方面的问题
;;; ==================================================================
;; string-prefix-p
(unless (fboundp 'string-prefix-p)
  (defun string-prefix-p (str1 str2 &optional ignore-case)
    "Return non-nil if STR1 is a prefix of STR2.
If IGNORE-CASE is non-nil, the comparison is done without paying attention
to case differences."
    (eq t (compare-strings str1 nil nil
                           str2 0 (length str1) ignore-case))))
;; last-command-char
(unless (boundp 'last-command-char)
  (defvaralias 'last-command-char 'last-command-event))

;;; ==================================================================
;;; package
;;; ==================================================================
(let ((package-el-site-lisp-dir (expand-file-name "~/.emacs.d/site-lisp/package")))
  (when (and (file-directory-p package-el-site-lisp-dir)
             (> emacs-major-version 23))
    (message "Removing local package.el from load-path to avoid shadowing bundled version")
    (setq load-path (remove package-el-site-lisp-dir load-path))))

(require 'package)

;;; ==================================================================
;;; misc customize
;;; ==================================================================
(custom-set-variables
 '(gud-gdb-command-name "gdb --annotate=1")
 '(large-file-warning-threshold nil))

;;; ==================================================================
;;; Utils
;;; ==================================================================
(defun add-auto-mode (mode &rest patterns)
  "Add entries to `auto-mode-alist' to use `MODE' for all given file `PATTERNS'."
  (dolist (pattern patterns)
    (add-to-list 'auto-mode-alist (cons pattern mode))))

(defun string-all-matches (regex str &optional group)
  "Find all matches for `REGEX' within `STR', returning the full match string or group `GROUP'."
  (let ((result nil)
        (pos 0)
        (group (or group 0)))
    (while (string-match regex str pos)
      (push (match-string group str) result)
      (setq pos (match-end group)))
    result))

(defun string-rtrim (str)
  "Remove trailing whitespace from `STR'."
  (replace-regexp-in-string "[ \t\n]*$" "" str))

(autoload 'find-library-name "find-func")
(defun directory-of-library (library-name)
  "Return the directory in which the `LIBRARY-NAME' load file is found."
  (file-name-as-directory (file-name-directory (find-library-name library-name))))

(defun rename-this-file-and-buffer (new-name)
  "Renames both current buffer and file it's visiting to NEW-NAME."
  (interactive "sNew name: ")
  (let ((name (buffer-name))
        (filename (buffer-file-name)))
    (unless filename
      (error "Buffer '%s' is not visiting a file!" name))
    (if (get-buffer new-name)
        (message "A buffer named '%s' already exists!" new-name)
      (progn
        (rename-file filename new-name 1)
        (rename-buffer new-name)
        (set-visited-file-name new-name)
        (set-buffer-modified-p nil)))))

;; 以下的 function 可以用来获取相关的文件
(defun browse-current-file ()
  "Open the current file as a URL using `browse-url'."
  (interactive)
  (browse-url (concat "file://" (buffer-file-name))))

(defmacro with-selected-frame (frame &rest forms)
  (let ((prev-frame (gensym))
        (new-frame (gensym)))
    `(progn
       (let* ((,new-frame (or ,frame (selected-frame)))
              (,prev-frame (selected-frame)))
         (select-frame ,new-frame)
         (unwind-protect
             (progn ,@forms)
           (select-frame ,prev-frame))))))

(defun download-site-lisp-module (name url)
  (let ((dir (site-lisp-dir-for name)))
    (message "Downloading %s from %s" name url)
    (unless (file-directory-p dir)
      (make-directory dir)
      (add-to-list 'load-path dir))
    (let ((el-file (site-lisp-library-el-path name)))
      (url-copy-file url el-file t nil)
      el-file)))

(defun ensure-lib-from-url (name url)
  (unless (site-lisp-library-loadable-p name)
    (byte-compile-file (download-site-lisp-module name url))))

(defun ensure-lib-from-svn (name url)
  (let ((dir (site-lisp-dir-for name)))
    (unless (site-lisp-library-loadable-p name)
      (message "Checking out %s from svn" name)
      (save-excursion
        (shell-command (format "svn co %s %s" url dir) "*site-lisp-svn*"))
      (add-to-list 'load-path dir))))

(defun hx-f1 ()
(let ((html5-el-dir "~/.emacs.d/site-lisp/html5-el"))
 (unless (file-directory-p (expand-file-name "relaxng" html5-el-dir))
   (if (and (executable-find "svn") (executable-find "make"))
       (progn
         (message "Setting up html5-el relaxng schema info")
         (shell-command (format "cd %s && make relaxng" html5-el-dir) "*make relaxng*"))
     (error "Please run 'make relaxng' in %s" html5-el-dir)))))

(defun refresh-site-lisp-submodules ()
  (interactive)
  (message "Updating site-lisp git submodules")
  (shell-command "cd ~/.emacs.d && git submodule foreach 'git pull' &" "*site-lisp-submodules*"))

(defun remove-site-lisp-libs ()
  (shell-command "cd ~/.emacs.d && grep -e '^site-lisp/' .gitignore|xargs rm -rf"))

(defun ensure-site-lisp-libs ()
  (unless (> emacs-major-version 23)
    (ensure-lib-from-url
     'package
     "http://repo.or.cz/w/emacs.git/blob_plain/1a0a666f941c99882093d7bd08ced15033bc3f0c:/lisp/emacs-lisp/package.el")))

(defun refresh-site-lisp ()
  (interactive)
  (refresh-site-lisp-submodules)
  (remove-site-lisp-libs)
  (ensure-site-lisp-libs))

;;; ==================================================================
;;; Proxy Config
;;; ==================================================================
(when (and *is-a-mac* (executable-find "proxy-config"))
  (defun mac-configured-proxy (proto)
    (string-rtrim (shell-command-to-string
                   (concat "proxy-config " (cdr (assoc-string proto '(("http" . "-h") ("https" . "-s"))))))))

  (defun extract-host-and-port (url-string)
    (if (string-match "^[a-z]+://\\([^/]+\\)" url-string)
      (match-string 1 url-string)
      url-string))

  ;; (defun assq-delete-all-with-test (k l &optional test)
  ;;   (let ((test-func (or test #'eq)))
  ;;     (loop for entry in l
  ;;           unless (funcall test-func k (car entry))
  ;;           collect entry)))

  ;; (defun mac-set-proxy-vars ()
  ;;   (interactive)
  ;;   (require 'url)
  ;;   (loop for proto in '("http" "https")
  ;;         for proxy = (mac-configured-proxy proto)
  ;;         do
  ;;         (setenv (concat proto "_proxy" proxy))
  ;;         (setq url-proxy-services
  ;;               (append (assq-delete-all-with-test proto url-proxy-services #'equal)
  ;;                       (if (not (equal "" proxy)) (list (cons proto (extract-host-and-port proxy)))))))
  ;;   (message "proxy variables updated")))
;;; ==================================================================
;;;  键绑定 和 映射
;;; ==================================================================

;; mac
(when *is-a-mac*
  (setq mac-command-modifier 'meta)
  (setq mac-option-modifier 'meta)
  (setq default-input-method "MacOSX")
  (setq mouse-wheel-scroll-amount '(0.001))
  (when *is-cocoa-emacs*
    (global-set-key (kbd "M-`") 'ns-next-frame)
    (global-set-key (kbd "M-h") 'ns-do-hide-emacs)
    (eval-after-load 'nxml-mode
      '(define-key nxml-mode-map (kbd "M-h") nil))
    ;; (global-set-key (kbd "M-藣") 'ns-do-hide-others)
    (global-set-key (kbd "M-c") 'ns-copy-including-secondary)
    (global-set-key (kbd "M-v") 'ns-paste-secondary)))

;; To be able to M-x without meta
;; (global-set-key (kbd "C-x C-m") 'execute-extended-command)

(global-unset-key (kbd "C-m"))
(define-key global-map (kbd "RET") 'newline-and-indent)

(global-set-key (kbd "C-c C-j") 'join-line)
(global-set-key (kbd "C-c C-f") 'find-file-in-project)

;; (global-set-key (kbd "C-c m") 'set-mark-command)
;; (global-set-key (kbd "C-c M") 'pop-global-mark)
;; (global-set-key (kbd "C-c C-f") 'ace-jump-mode)

(global-set-key (kbd "M-j") 'ace-jump-char-mode)
;; multiple-cursors
;; (global-set-key (kbd "C-<") 'mc/mark-previous-like-this)
;; (global-set-key (kbd "C->") 'mc/mark-next-like-this)
(global-set-key (kbd "C-c c SPC") 'mc/mark-all-like-this)

;; From active region to multiple cursors:
(global-set-key (kbd "C-c c r") 'set-rectangular-region-anchor)
(global-set-key (kbd "C-c c c") 'mc/edit-lines)
(global-set-key (kbd "C-c c e") 'mc/edit-ends-of-lines)
(global-set-key (kbd "C-c c a") 'mc/edit-beginnings-of-lines)

;; (global-set-key (kbd "C-c p") 'duplicate-line)
(global-set-key (kbd "C-M-<backspace>") 'kill-back-to-indentation)
(global-set-key (kbd "C-l") 'er/expand-region)

;; Train myself to use M-f and M-b instead
(global-unset-key [M-left])
(global-unset-key [M-right])

(global-set-key (kbd "C-x C-b") 'ibuffer)
(global-set-key "\M-x" 'smex)
(global-set-key (kbd "M-/") 'hippie-expand)
(global-set-key (kbd "C-M-/") 'my-expand-file-name-at-point)

;; Click on fringe to toggle bookmarks, and use mouse wheel to move
;; between them.
(global-set-key (kbd "<left-fringe> <mouse-5>") 'bm-next-mouse)
(global-set-key (kbd "<left-fringe> <mouse-4>") 'bm-previous-mouse)
(global-set-key (kbd "<left-fringe> <mouse-1>") 'bm-toggle-mouse)
;;; (global-set-key (kbd "C-`") 'push-mark-no-activate)


;; (define-key global-map [remap open-line] 'other-window)
(global-unset-key (kbd "C-0"))

(global-set-key (kbd "<f2>") 'bm-toggle)
(global-set-key (kbd "<M-f2>") 'bm-previZous)

(global-set-key (kbd "M-`") 'other-window)

(define-key global-map [remap exchange-point-and-mark] 'exchange-point-and-mark-no-activate)

(global-set-key (kbd "C-0")
                '(lambda () (interactive)
                   (let (kill-buffer-query-functions) (kill-buffer))))
(global-set-key (kbd "C-x k")
                '(lambda () (interactive)
                   (let (kill-buffer-query-functions) (kill-buffer))))
(global-set-key (kbd "M-i") 'imenu)
(global-unset-key (kbd "M-m"))
(global-set-key (kbd "M-m") 'jump-to-mark)
(global-set-key [remap find-tag] 'ido-find-tag)
;;; (global-set-key (kbd "c-.") 'ido-find-file-in-tag-files)
(global-set-key (kbd "M-=") 'hs-toggle-hiding)
(global-set-key (kbd "M--") 'hs-hide-level)
(global-set-key [(meta f12)] 'magit-status)
(global-set-key [(shift meta f12)] 'magit-status-somedir)
(define-key lisp-mode-map (kbd "C-c l") 'lispdoc)
