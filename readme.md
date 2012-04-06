# R语言忍者秘笈

很久以前我就提议把[COS论坛](http://cos.name/cn/)上的R语言历史问题整理一下，必可成为一本国产经典书籍，但我们一直没动手。一方面我没时间，另一方面我还在等一个合适的写作工具。现在，我还是没太多时间，也没等到工具，所以我只好自己发明了一个工具，就是[knitr](http://yihui.name/knitr/)，自己的工具必然顺手，比那狗血的Sweave灵活很多，它也顺便和GitHub/markdown一起解决了时间稀缺的问题，因为我不必找一大块时间来专注写作，只要我有几分钟时间，我就可以打开记事本写几行，反正GIT可以离线工作，markdown写起来也超级简单，跟写日志似的。最终“压倒骆驼的那根稻草”其实是[pandoc](http://johnmacfarlane.net/pandoc/)，我埋头研究了几天之后决定，以后写东西尽量避免LaTeX，因为有pandoc在，大多数文档格式都不成问题了，我可以从md转HTML，也可以转Word，或LaTeX。LaTeX说让用户专注写作，不管格式，作为有八年经验的LaTeX用户，我认为这是LaTeX最大的谎言，劳资天天在忧心那图片是否浮动有没有？！

所以，我们用markdown写，完稿再排版。knitr使得我们只需要关注源代码，不用管输出，所有输出都是通过运行代码而得到的，这是文学化编程的思想。没有复制没有粘贴，一切自动化。

那么这本书的内容写什么？一个不完整大纲：

1. 安装R
1. 编辑器
  - RStudio
  - Emacs
1. 数据结构
  - 向量，向量化运算
1. 字符数据
  - 编码问题
  - 正则表达式
1. OO特征
  - S3, S4, reference classes
1. 图形
1. 网络数据
  - download.files
  - XML
  - RCurl
  - 社会网络分析
    - 微博
    - 人人
1. 统计模型
1. 数据库
1. 数据挖掘
1. 自动化报告
1. 高性能计算
1. 程序包
  - 嵌C代码
  - 嵌Rcpp代码
  - roxygen(2)写文档
  - Profiling
  - 单元测试
1. Linux
1. 版本控制
  - GIT
  - GitHub
1. Web编程
  - rApache
  - Rserve
  - Rook

希望大家可以想一些更有创意的标题，比如圣斗士体，“死斗！显式循环炼狱之卷”，“集合！分布式与并行计算之卷”，或火影体，等等。

本库中所有内容遵守[CC BY-NC-SA 3.0](http://creativecommons.org/licenses/by-nc-sa/3.0/)协议，请君自重，别没事儿拿去传个什么新浪爱问百度文库以及XX经济论坛。有问题请到[Issues](https://github.com/yihui/r-ninja/issues/)里面报告。

