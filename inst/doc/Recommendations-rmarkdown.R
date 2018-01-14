## ----setup, include=FALSE------------------------------------------------
library(summarytools)
library(knitr)
opts_chunk$set(comment=NA, prompt=FALSE, cache=FALSE, echo=TRUE)

## ----freq_default, results='asis'----------------------------------------
freq(tobacco$gender)

## ----freq_default2, results='asis'---------------------------------------
freq(tobacco$gender, plain.ascii = FALSE)

## ----freq_rm, results='asis'---------------------------------------------
freq(tobacco$gender, style = 'rmarkdown')
freq(tobacco$gender, style = 'rmarkdown', omit.headings = TRUE)

## ----descr_default, results='asis'---------------------------------------
descr(tobacco)

## ----descr_default2, results='asis'--------------------------------------
descr(tobacco, plain.ascii = FALSE)
descr(tobacco$BMI, plain.ascii = FALSE)

## ----descr_rm, results='asis'--------------------------------------------
descr(tobacco, style = 'rmarkdown')
descr(tobacco$BMI, style = 'rmarkdown')
descr(tobacco$BMI, style = 'rmarkdown', omit.headings = TRUE)

## ----descr_html, results='asis'------------------------------------------
print(descr(tobacco), method = 'render')
print(descr(tobacco$BMI), method = 'render')
print(descr(tobacco, omit.headings = TRUE), method = 'render')

## ----ctable_html, results='asis'-----------------------------------------
print(ctable(tobacco$gender, tobacco$smoker), method = 'render')
print(ctable(tobacco$gender, tobacco$smoker, omit.headings = TRUE), method = 'render')

## ----dfs_grid, results='asis'--------------------------------------------
dfSummary(tobacco, style = 'grid', plain.ascii = FALSE, graph.col = FALSE)
dfSummary(tobacco, style = 'grid', plain.ascii = FALSE, graph.col = FALSE, omit.headings = TRUE)

