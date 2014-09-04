(setq inhibit-startup-screen 1)

;; Disable menu bar except for GUI emacs
;; (if (not window-system)
;;   (add-hook 'term-setup-hook #'(lambda () (menu-bar-mode -1))))

(if (not window-system)
    (menu-bar-mode -1))

(custom-set-variables
 '(gud-gdb-command-name "gdb --annotate=1")
 '(large-file-warning-threshold nil))

;; command line args
(when (cdr command-line-args)
  (setcdr command-line-args (cons "--no-splash" (cdr command-line-args))))

;; 添加子目录到 load-path 中
;; (if (fboundp 'normal-top-level-add-subdirs-to-load-path)
;;     (normal-top-level-add-subdirs-to-load-path))


