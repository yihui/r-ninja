#!/usr/bin/Rscript

## call me with three possible options: epub (default), html or pdf

input = paste(list.files(pattern = '^\\d{2}-.*\\.md$'), collapse = ' ')
fmt = commandArgs(TRUE)
if (length(fmt) == 0L) fmt = 'epub'
if (!(fmt %in% c('epub', 'html', 'pdf'))) q()

cmd = sprintf('pandoc -S -o knitr-book%s %s', 
              switch(fmt, 
                epub = '.epub --epub-metadata=metadata.xml',
                html = '.html -N --standalone --toc --mathjax',
                pdf = '.pdf -N --latex-engine=xelatex --toc --chapters --template=template.tex'), 
              input)
message(cmd)
system(cmd)

