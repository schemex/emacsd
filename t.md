Time-stamp: <2014-09-07 21:02:38 jason>

### emacs 的获取 ###

可以直接下载现成的编译好的版本 或者 下载源码自己进行编译
* 编译的方法:
1. `./configure` 通过 __configure__，确定相关的系统变量和需求`
2. `./make`

编译好后有 `temacs` 和 `emacs` 的区分
temacs 由C文件编译而来， `emacs` 是 `temacs` + 预加载的elisp __dump__ 而来
所谓的 __dumped emacs__

`loadup.el`

### emacs 内部实现 ###

emacs 的功能由 __C__ 和 __emacs lisp__ 写成
C 的部分为 emacs lisp 解释器 和 io 这些核心功能
Emacs Lisp 实现上层的编辑功能

### emacs 启动 ###
what Emacs does when it is started and how can it be customized.

#### Init File ####

emacs's dumped image

PATH_DUMPLOADSEARCH is just "../lisp"

TODO: 搞清楚 dumped image 的意义
`site-run-file` 默认为 `site-start.el`
`.emacs or init.el`
`default.el`

;;; 启动的初始化过程主要在 startup.el 中定义
;; 搞清楚以下的几个 hook 运行的时机、区别以及应用
;; before-init-hook
;; after-init-hook
;; emacs-starup-hook
;; term-setup-hook
;; window-setup-hook


;;; 通过 initialization 这个group，可以对启动过程进行一些定制
;; initailization 的定义主要在 startup.el 这个脚本中
;; inhibit-startup-hooks
;; inhibit-default-init


### Entering & Exiting ###
* Session 的保存

### Inserting Text ###

### Emacs Server ###

### 代码加载的逻辑 ###

`Preloaded` & `Autoloaded` 这两种情况
对于运行时来说，代码的加载有两种情况
核心的代码在启动时就加载执行
一般的功能代码在被调用时再自动加载

### Coding System ###

### Lisp Macro From Custom.el ###

### Completion & Abbrevs ###

* Hippie Expansion
* Dabbrev

global & mode specific
`add-global-abbrev`
`add-mode-abbrev`
`expand-abbrev`
`expand-region-abbrevs`

`dabbrev-check-all-buffers`

* abbrev-mode

'all abbrevs must be defined explicitly'

`C-M-/` (dabbrev-completion)


### Misc ###

Emacs 的设计是 Customizable Software 的一个很好的例子
学习 Emacs 的使用，然后进阶进行配置，定制
学习其设计理念，一些实现的细节，并在其基础上进行练习

Any Functions You Want In Any Language.
They Just Fit Together In The End.

A System Can Be Consist Of Simple Parts.
Those Parts Are Easy To Comprehend By Human Brain

Emacs can be treated as the programmer's interface which are more
efficient for manipulation of text.

#### If Lines Are Too Long ####
Logical Line vs Screen Line
truncate long lines: lines that are too long are truncated(not shown
on the screen)
* line wrapping
* word wrapping
* truncate line
* auto filling
* Visual line mode

#### Mark ####

(set-mark-command)
(exchange-point-and-mark)
(mark-word)
(mark-sexp)
(mark-defun)
(mark-page)
(mark-paragraph)
(mark-whole-buffer)

* mark ring
local mark ring: belongs to each buffer
pop-mark

global mark ring:
pop-global-mark

#### Font Lock Mode ####
* font-lock-mode
* global-font-lock-mode

#### Imenu ####
* imenu-sort-function
* imenu-add-menubar-index
* imenu-auto-rescan


#### Term ####

* characters
* words
* lines
* sentences
* paragraphs
* pages

## 几种需要的帮助形式

* find what your options are
* find out what any command does
* find all commands that pertain to a given topic

### 软件灵活配置的几种可行方案: ###

* 使用 key value 形式的简单配置文件
* 发明或者使用现有的脚本引擎，使用脚本来做配置
 （很多高级功能都可以直接用脚本实现了)

### File ###

* 文件的打开、保存、备份
* 使用 `C-x C-f` 时，是否: insert-default-directory

* find-file
* find-file-literally
* find-file-wildcards
* find-file-run-dired

### Screen ###

* frame
* window
* scroll bar
* mode-line

terminal or graphical

`CS:CH-FR  BUF      POS LINE   (MAJOR MINOR)`
1. mouse sensitive Mode Line Mouse
2. optional mode line

* menu-bar
* toolbar
* echo area & minibuffer
* selected window
* current buffer
* point cursor & cursor display

* display custom

optional editing modes that provide additional features on top of the
major mode.

#### special buffers ####
* `*Message*`
  message-log-max: 用来限制 `*Message*` 的最大行数

Most Emacs comands implicitly apply to the current buffer.

_recursive editing mode_

* simple character
* control

### ISSUES ###

#### key sequence ####
* prefix key
* complete key
a key that invokes a command are collectively
referred to as "input events"

The window manaer might block some keyboard input
1. customize window manager to not block those keys.
2. rebind emacs commands

#### Register ####

Register 用来保存一些信息, 可以包括以下这些:
* Position
* Text
* Rectangle
* Configuration
* Number
* File
  (set-register ?z '(file . "/gd/gnu/emacs/19.0/src/ChangeLog"))
* Bookmark

### Info Document ###

* textinfo documeting system
  read info format with the info reader
* documention tree
* directory : directory of documents
* table of contents
* topic
* go back and forth/sequence of nodes
* up/down and prev/next
* info reader & how to use it to browse the documents

emacs 的NB之处在于其文档的完备性
作为一款开源软件，有完整的文档体系是很可贵的
gnu 的很多文档都使用了 info 的格式

在进行开发和设计时，往往需要有很多的参考，比如 API 文档等
不同的语言和系统可能有不同的文档格式以及文档reader，
比如java 和 java doc，ruby 和 rdoc等
通过统一的界面把这些参考文档统一起来进行 浏览、搜索对于production的提升是很重要的
emacs 的 info reader 的设计和操作就很优秀，可以借鉴一下

### Controlling Dispaly ###

### Environment ###
process-environment : 记录了 environment
可以使用 getenv 和 setenv 来获取和设置 env

### Text Faces ###
Font Lock


```
(getenv "HOME")
```

### Codeing ###
locale-coding-system : Coding system to use with system messages.
