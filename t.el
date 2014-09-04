;; emacs lisp 学习

;; defvar 
;; 事先声明变量，好处是可以定义变量的初始值以及文档
(defvar hx-var1 (concat "var1" "/" "xx") "def var 变量文档")

;; defgroup
;; 定制选项
;; 定制项的名称， 定制的方式，所属的group
(defgroup hx-practice 
  '((var1 custom-varible))
  "defgroup 练习"
  :group 'environment)

;; defcustom

(defcustom hx-custom-choice1 nil
  "定制选项1"  
  :type '(choice
	  (const :tag "X1" nil)
	  (file  :tag "文件" :value "~/.emacs"))
  :version "23.1"
  :group 'hx-practice)


(defvaralias 'hx-c-c1 'hx-custom-choice1)

;; 以下是启动时设置的hook

(defun hx-hook1 ()
  (message "hello"))



;; 搞清楚以下的几个 hook 运行的时机、区别以及应用
;; before-init-hook
(add-hook 'after-init-hook 'hx-hook)

;; after-init-hook

;; emacs-starup-hook

;; term-setup-hook


;; window-setup-hook


;; inhibit-startup-hooks
;; inhibit-default0init

;; emacs 启动时加载的文件顺序
;; emacs's dumped image 
;; TODO: 搞清楚 dumped image 的意义 
;; site-run-file 默认为 site-start.el
;; .emacs or init.el
;; default.el

;; preloaded & autoloaded 这两种情况

;; 对于运行时来说，代码的加载有两种情况
;; 核心的代码在启动时就加载执行
;; 一般的功能代码在被调用时再自动加载


;; 创建一个 buffer，并对该 buffer 进行一些编辑
(with-current-buffer (get-buffer-create "*hx-test*")
  ;; (point-min)
  (erase-buffer)
  ;; (org-mode)
  (insert "\n")
  (insert "---------------")
  (insert "伟大的编辑器")  
  (insert "---------------")
  (insert "\n"))

;; default-directory command-line-default-directory

;; quit-window 函数的使用
(defun exit-splash-screen ()
  "Stop displaying the splash screen buffer."
  (interactive)
  (quit-window t))

(window-width (selected-window))

;; 
(fancy-about-screen)
(fancy-startup-screen 'concise)

;;;; 软件灵活配置的几种可行方案:
;; * 使用 key value 形式的简单配置文件
;; * 发明或者使用现有的脚本引擎，使用脚本来做配置（很多高级功能都可以直接用脚本实现了）

;; ./configure
;; 通过configure，确定相关的系统变量和需求





