(float-time (current-time))

;; string matching function
(string-match "=" "HOME=home1")
(match-beginning 0)
(match-end 0)
(match-data)

(with-current-buffer (get-buffer-create "*hx-test*")
  (let* ((f1 '(lambda (s) (format "entered: %s\n" s))))
    (erase-buffer)
    (insert "========== NOTE ==========")
    (insert "\n")
    (insert (format "length of the undo list: %s\n" (length buffer-undo-list)))
    (insert "|||||||||||||||||||||||||||||")))

(progn
  (set-buffer (other-buffer))
  (buffer-name)
  (buffer-size)
  (save-excursion
    (point-max)
    (backward-char 11)
    (message "%s" (point))
    (what-cursor-position)))

;; register 相关的应用
(set-register ?z '(file . "/gd/gnu/emacs/19.0/src/ChangeLog"))
(number-to-register 10 ?n)
(increment-register 1 ?n)

;; 环境变量列表 var=val
(append process-environment)
(setenv "mvar1" "hhh")

(let ((buf (set-buffer (read-buffer "buf: "))))
  (shell-command (read-shell-command "把结果保存到:") buf))

(message "hello, %s" (char-to-string (read-char "char: ")))
(buffer-size (set-buffer (read-buffer "buf: ")))
(completing-read "input: " '("t1" "t2" "t3") nil nil "t" )

;; locole and coding system
(getenv "LC_CTYPE")
(getenv "LC_LANG")
(memq (coding-system-base locale-coding-system)
      (find-coding-systems-string "你好"))

(coding-system-base locale-coding-system)
(time-since )
(let ((str "你好"))
  (if (multibyte-string-p str)
      (decode-coding-string str locale-coding-system t)))

(when (eq system-type 'windows-nt)
  (set-frame-font "courier new"))

;; tmp file directory
(find-file temporary-file-directory)

;; 批量创建文件 和 编写文件
(mapc (lambda (n)
  (let ((fname (concat n ".txt")))
    (with-current-buffer (get-buffer-create "*hx-test*")
      (insert (format "%s" (float-time)))
      (write-file fname)))) '("a" "b" "c" "d"))

(format-time-string "%Y-%m-%d %H:%M")

(setq default-directory "d:/workspace/emacsd/test/")
(mapc (lambda (f) (delete-file f))
      (cddr (directory-files default-directory t)))

(message "locale system is: %s" locale-coding-system)

(defun insert-date ()
    "Insert date at point."
      (interactive)
        (insert (format-time-string "%Y-%m-%d - %H:%M")))

;; preloaded-file-list
;; 预加载的 el 文件
(setq 'hx-to-preload (reverse preloaded-file-list))
(find-file-read-only-other-window (buffer-file-name))
