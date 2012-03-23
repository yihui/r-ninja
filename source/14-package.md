# 程序包

## Profiling

> 颐和园在我家北面，假如没有北这个方向的话，我就只好向南走，越过南极和北极，行程四万余公里到达那里。
> 
> —— 王小波，《革命时期的爱情》

> 怎么做对是科学，怎么做好则是艺术；前者有判断真伪的法则，后者则没有；艺术的真谛就是要叫人感到好，甚至是完美无缺。
> 
> —— 王小波，《用一生来学习艺术》

### 剖析与Profiling

要提高R程序的运行速度，不仅仅需要剽悍的机器（单核高频、多核并行、GPU计算）和高效的代码（向量化、混合编程），寻找程序中的性能瓶颈并进行有针对的优化也是很重要的。“找到北这个方向”，就是profiling的意义所在。当然，找到优化的方向只是第一步，最终能够实现多大幅度的优化，则更多地属于艺术的范畴。

R中其实自带了几个最简单的profiling工具，我们或多或少都接触过：

  * `base::system.time()` —— 简陋的计时秒表
  * `utils::Rprof()` —— 针对CPU的简易profile工具
  * `utils::Rprofmem()` —— 针对内存的简易profile工具

关于这些函数的使用，可以参看Ross Ihaka的说明[2]。与此同时，CRAN上[profr](http://cran.r-project.org/web/packages/profr/">)（Hadley Wickham）和[proftools](http://cran.r-project.org/web/packages/proftools/)（Luke Tierney）两个微型包均提供了可视化`Rprof()`函数输出结果的能力。但是，这类简单的profiling只将程序拆解了到了单个R运算的层次，没有提供更深一层，即profiling compiled code的功能。R原生支持这个特性，但需要在编译时对默认选项进行简单的修改[4]。

### 安装Google Perftools

由Google员工开发的Google Perftools可以profiling compiled code。配合kcachegrind，还可以将结果进行可视化。

测试环境: Arch Linux x86_64

AUR上已有一位大人在维护google-perftools(源代码安装):

        sudo yaourt -S google-perftools


Fedora:

        sudo yum install google-perftools


Ubuntu:

        sudo apt-get install google-perftools

不过Ubuntu/Fedora仓库中的二进制包可能比较陈旧了，无妨直接自行编译最新版本：

        svn checkout http://google-perftools.googlecode.com/svn/trunk/


在Arch Linux x86_64下，google-perftools的默认安装路径为

        /usr/bin


库文件libprofiler.so位于

        /usr/lib

Google Perftools工具集中除了名为pprof的CPU profiler以外，还提供了堆内存泄漏检测/使用情况统计等工具。这里我们只关注pprof就可以了：它通过CPU中断采样的方式统计每个函数被采样的次数、占总采样次数的百分比、调用的子函数的被采样次数等等（可以说，“剖析”在此处还是比较恰当的）。最后通过这些信息寻找程序的（CPU）性能瓶颈。

### 使用Google Perftools

要和R一起使用，pprof有两种可行的运行方式，第一种比较硬朗：在编译选项中直接加入对libprofiler.so的引用，R在运行时就会自动加载libprofiler库：

        wget http://cran.r-project.org/src/base/R-2/R-2.13.1.tar.gz
        tar -xf R-2.13.1.tar.gz
        cd R-2.13.1
        
        export MAIN_CFLAGS="-pg"
        export MAIN_FFLAGS="-pg"
        export MAIN_LDFLAGS="-pg"
        export LDFLAGS="-lprofiler"
        # 也可显式指定路径:
        # export LDFLAGS="-L/usr/lib -lprofiler"
        ./configure --enable-R-shlib

参数 `-pg` 打开R的profiling支持，设定`LDFLAGS`用以连接libprofiler库。

configure完成:


        R is now configured for x86_64-unknown-linux-gnu

        Source directory:          .
        Installation directory:    /usr/local

        C compiler:                gcc -std=gnu99  -g -O2
        Fortran 77 compiler:       gfortran  -g -O2

        C++ compiler:              g++  -g -O2
        Fortran 90/95 compiler:    gfortran -g -O2
        Obj-C compiler:

        Interfaces supported:      X11
        External libraries:        readline, ICU, lzma
        Additional capabilities:   PNG, JPEG, TIFF, NLS, cairo
        Options enabled:           shared R library, shared BLAS, R profiling, Java

        Recommended packages:      yes

结果无误，开始编译安装：

        make && sudo make install

这样，连接了libprofiler.so的R编译成功。

第二种使用pprof的方式则相对委婉：使用时动态预加载库文件就可以了。Dirk大人的RhpcTutorial[3]中给出了说明，此略。

选取《Wringting R Extension》 3.2节中给出的一个例子进行测试，假设以下为保存在当前目录的profiling.R：

        #!/usr/local/lib64/R/bin/Rscript
        suppressMessages(library(MASS))
        suppressMessages(library(boot))
        storm.fm <- nls(Time ~ b*Viscosity/(Wt - c), stormer, 
                        start = c(b=29.401, c=2.2183))
        st <- cbind(stormer, fit=fitted(storm.fm))
        storm.bf <- function(rs, i) {
            st$Time <-  st$fit + rs[i]
            tmp <- nls(Time ~ (b * Viscosity)/(Wt - c), st, start = coef(storm.fm))
            tmp$m$getAllPars()
        }
        rs <- scale(resid(storm.fm), scale = FALSE)
        storm.boot <- boot(rs, storm.bf, R = 500)

将profiling结果记录到文件：

        chmod 755 profiling.R
        CPUPROFILE=rprof.out ./profiling.R

这里在写R文件时用了一点点技巧，使得它能够支持类Unix系统的Shebang特性而直接执行，参考[7]、[8]。

执行完毕后，我们即可使用pprof来分析输出的结果文件（一个二进制文件！）了。pprof可以将此文件解析成你想要的各种可读的形式。其参数如下：

        pprof --option [ --focus=< regexp > ] [ --ignore=< regexp > ] 
                       [--line or addresses or functions] 可执行文件路径 结果文件路径

方括号为可选项目，`< regexp >`为正则表达式。

具体的选项分为几组。其中输出格式的基本可选项为：

        text, callgrind, gv, evince, web, symbols, dot, ps, pdf, svg, 
        gif, raw, list=< regexp >, disasm=< regexp >. 

  * `text` 表示字符统计输出形式，其它均对应各自的图形格式；
  * `list=< regexp >` 表示输出匹配正则表达式的函数的源代码；
  * `diasm=< regexp >` 表示输出匹配正则表达式的函数的反汇编代码。

其他比较重要的参数：

  * `--focus=< regexp >` 表示只统计函数名匹配正则表达式的函数的采样；
  * `--ignore=< regexp >` 表示不统计函数名匹配正则表达式的函数的采样；
  * `[--line or addresses or functions]` 表示生成的统计是基于代码行，指令地址还是函数的，默认是函数。

这里仅输出文字型结果：

        pprof --cum --text /usr/local/lib64/R/bin/Rscript rprof.out | less

结果中的前15位：

        Total: 254 samples
               2   0.8%   0.8%      213  83.9% Rf_applyClosure
              24   9.4%  10.2%      213  83.9% Rf_eval
               0   0.0%  10.2%      213  83.9% do_begin
               0   0.0%  10.2%      212  83.5% do_set
               0   0.0%  10.2%      206  81.1% do_internal
               0   0.0%  10.2%      148  58.3% do_lapply
               7   2.8%  13.0%      123  48.4% Rf_evalList
               0   0.0%  13.0%      107  42.1% Rf_ReplIteration
               0   0.0%  13.0%      104  40.9% R_ReplConsole
               0   0.0%  13.0%      102  40.2% Rf_usemethod
               0   0.0%  13.0%      100  39.4% run_Rmainloop
               0   0.0%  13.0%       96  37.8% main
               0   0.0%  13.0%       92  36.2% __libc_start_main
               0   0.0%  13.0%       85  33.5% do_usemethod
               1   0.4%  13.4%       85  33.5% forcePromise


输出结果中，每行对应着一个函数的统计：

  * 第1、2列是该函数的本地采样(不包括被该函数调用的函数中的采样次数)次数和比例；
  * 第3列是该函数本地采样次数占当前所有已统计函数的采样次数之和的比例；
  * 第4、5列是该函数的累计采样次数(包括其调用的函数中的采样次数)和比例。

如果你的系统中安装了gnu-gv或evince，即可直接即刻显示一幅无码清晰大图（ps/pdf）：

        pprof --gv /usr/local/lib64/R/bin/Rscript rprof.out
        pprof --evince /usr/local/lib64/R/bin/Rscript rprof.out

![Profiling结果的简单展示](http://www.road2stat.com/cn/wp-content/attachments/2011/07/rprof.gif)

其他几个比较常用的选项可能是

生成PDF：

        pprof --pdf /usr/local/lib64/R/bin/Rscript rprof.out > rprof.pdf

生成SVG：

        pprof --svg /usr/local/lib64/R/bin/Rscript rprof.out > rprof.svg

生成GraphViz所支持的dot格式：

        pprof --dot /usr/local/lib64/R/bin/Rscript rprof.out > rprof.dot

当然，要想读懂图中的内容，从而针对某些部分进行优化，还需要对R的底层比较熟悉才行：最起码要了解涉及到的C函数的具体功能。

### 配合kcachegrind可视化profiling结果

pprof可将输出转化为强大的Valgrind工具集中的组件Callgrind可采用的格式，配合KCachegrind这个图形前端，即可对结果进行简单的可视化，能够交互哦亲：

        # For Arch Linux
        # sudo pacman -S kdesdk-kcachegrind
        pprof --callgrind /usr/local/lib64/R/bin/Rscript rprof.out > rprof.callgrind
        kcachegrind rprof.callgrind

![配合kcachegrind可视化profiling结果](http://www.road2stat.com/cn/wp-content/attachments/2011/07/kcachegrind.jpg)

其实看上去KCachegrid就是做了一个最普通的树可视化。不过有了交互式图形的支持，进一步的分析就变得十分方便了，读者可以自己进一步体验。

### 其他工具

Writing R Extensions[6]提到另外两个可供Linux用户选择的工具：sprof和oprofile。感兴趣的同学不妨实践一下。

### 参考

  1. [Wikipedia - Profiling (computer programming)](http://en.wikipedia.org/wiki/Profiling_(computer_programming))
  2. Ross Ihaka. [Writing Efficient Programs in R (and Beyond)](http://www.stat.auckland.ac.nz/~ihaka/downloads/Taupo.pdf).
  3. Dirk Eddelbuettel. [Introduction to High-Performance Computing with R](http://dirk.eddelbuettel.com/papers/useR2010hpcTutorial.pdf). pp. 29-35
  4. R Installation and Administration. Version 2.13.0 (2011-04-13) Appendix B.1, B.7.
  5. 冯文龙. [使用google-perftools剖析程序性能瓶颈](http://www.ibm.com/developerworks/cn/linux/l-cn-googleperf/index.html).
  6. Writing R Extensions. Version 2.13.0 (2011-04-13) pp. 69-71.
  7. [Wikipedia - Shebang](http://zh.wikipedia.org/wiki/Shebang).
  8. [shebang line not working in R script](http://stackoverflow.com/questions/3128122/shebang-line-not-working-in-r-script).

