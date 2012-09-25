# Linux

> KISS: Keep It Simple, Stupid.

> 程序员有三大美德：懒惰、自负、浮躁。

关于“Linux”这个题目？

首先，现在OS X大行其道，虽然与Linux诸多相似，但是OS X却不是Linux，更多底层来自FreeBSD。说回来，Linux众多发行版，有的时候单单用Linux这个词来描述略显无力。所以用“类Unix操作系统”描述会更准确，但是显得又是那么词不达意。


## Unix/Linux设计思想

关于Unix/Linux设计思想、设计哲学总结已然很多。（参看Wikipedia相关条目）

1994 年，Mike Gancarz 又给出了如下总结：

- Small is beautiful.
- Make each program do one thing well.
- Build a prototype as soon as possible.
- Choose portability over efficiency.
- Store data in flat text files.
- Use software leverage to your advantage.
- Use shell scripts to increase leverage and portability.
- Avoid captive user interfaces.
- Make every program a filter.

比起这些冗长的总结（其实已经不算长了，对于Unix/Linux设计哲学的探讨早已成书）。我更喜欢这一句：

Keep it Simple, Stupid.

从中我们不难梳理出这样一条脉络：

每个程序只处理好一件事情，对于复杂的事情则需要各个程序协同处理，可以协作的基础就是有统一的标准和协议，从人本角度出发选用文本作为信息载体。

## Shell文本处理

好吧，为了让自己的写的动态不那么像胡扯（其实就是），我们来给这章起一个靠谱的标题：

类Unix操作系统中命令行shell下各种字符处理工具综述

刚才我们谈了Unix/Linux设计思想，无疑最能体现这些Unix哲学的地方就是shell中。

那么这种协作的具体实现是什么呢？

管道

语法表现就是简单的竖线“|”

a | b

其意思就是，将a处理后的标准输出作为b处理时的标准输入。

标准的统一为分布处理打下了坚实的基础，文本化使得抽象的计算机处理更加人性化。

当然，文本化也不全是优点，文本化给人类提供了便捷，也给整个系统引入了熵。（参看王垠博客文章） http://blog.sina.com.cn/s/blog_5d90e82f01014k5j.html


### 关于演示的约定

不管是叫命令，还是叫程序都感觉不是非常准确，不妨我们就将这些东西命名未工具。

一下参数中所谓的[文件]，也可以看作是标准输入，某种角度上来说这也反映着Unix设计哲学，即将一切看作文件。

一下所罗列的工具，很多没有给出全部的参数和使用，我只将有关与文本处理相关

因为“大集市”的特性，很多工具都有不同的风格，体现在工具的帮助上就是查看工具的帮助有各种不同的方式。

您可以尝试一下途径获取工具的使用说明：

man [工具名]

[工具名] -h

[工具名] --help

[工具名] --usage

范例文件：

有文件file，内容如下

```
one
two
three
```

#### echo

将一个字符串标准输出，往往作为管道的发起使用

语法

echo [字符串]

标准输出

```
~$ echo "Hello World"
Hello World
```

将“Hello World”利用管道传给“wc -w”处理，关于wc工具我们后文详述。

```
~$ echo "Hello World" | wc -w
2
```

#### cat

语法

cat [参数] [文件]

将文件内容标准输出

所以我们可以将file内容输出：

```
~$ cat file
one
two
three
```

参数

-b 输出行号


```
~$ cat -b file1
 1 one
 2 two
 3 three
```

#### yes

不停的输出字符，默认为“y”。

>读者一定要问，这么会有这样的工具存在？其实不难理解，往往在命令行下操作是，我们总会遇到程序各种交互提问，这些答案往往都是y（因为你毕竟要做一些事情）。根据Unix的哲学，一个工具就干好一件事情，所以懒惰的程序员就编写了一个只帮你输入y的程序。


语法

yes [字符串]

一直输出“y”

```
~$ yes
y
y
…
```

一直输出“no”

```
~$ yes no
no
no
...
```

#### cat

#### tac

#### rev

#### nl

#### head

####tail

### 搜索相关

#### grep

内使用正则表达式搜索文件内匹配的行



#### wc

文本计数

语法

wc [参数] [文件]

参数

-c

按byte计数

```
~$ wc -c file
14 file
```

-m

按字符计数

```
~$ wc -m file
14 file
```

-l

按行计数

```
~$ wc -l file
3 file
```

-w

按单词计数

```
~$ wc -w file
3 file
```

### 排序相关

#### sort

#### tsort

#### uniq

### 比较相关

#### comm

#### diff

### 序列相关

#### shuf

### 文本内容操作

#### cut

#### paste

### 字符操作

#### tr

#### expand
   
### 表格操作
    
#### colrm

### 文本切割

#### split

### 编码转换

#### iconv

### 格式化输出

#### column

### 神器

#### sed

#### awk

## 组合处理演示

## 后记

从这些工具我们可以了解，经过长期的历史积淀。
在Linux下，各种有可能遇到的问题都有了不错的解决方案。

以Linux的设计思想的角度来说，我们站在前人的肩膀上，将这些工具为我所用。

逆向思维的角度来看，如果你遇到的一个问题没法解决，那么十有八九是你的问题不对。
当然也不排除，你在解决前人还没有解决的问题，或者是利用这些工具组合都无法解决的问题。
