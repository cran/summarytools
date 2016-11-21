## ----setup, include=FALSE------------------------------------------------
library(summarytools)
library(knitr)
opts_chunk$set(comment=NA, prompt=TRUE, cache=FALSE)

## ----barebones-----------------------------------------------------------
freq(iris$Species)

## ----descr_md, results='asis'--------------------------------------------
data(exams)
descr(exams, style='rmarkdown')

## ----descr_md2, eval=FALSE-----------------------------------------------
#  descr(exams, style = 'rmarkdown', transpose = TRUE)

## ----dfsum_md, results='asis'--------------------------------------------
data(tobacco)
dfSummary(tobacco, plain.ascii = FALSE)

## ----dfsum_mdgrid, results='asis'----------------------------------------
dfSummary(tobacco, style = 'grid', plain.ascii = FALSE)

## ----redir, eval=FALSE---------------------------------------------------
#  dfSummary(tobacco, file="tobacco.txt", style = "grid")  # Creates tobacco.txt
#  descr(tobacco, file="tobacco.txt", append = TRUE)  # Appends results to tobacco.txt

## ----view_html, eval=FALSE-----------------------------------------------
#  print(dfSummary(tobacco), method = "browser")  # Displays results in default Web Browser
#  print(dfSummary(tobacco), method = "viewer")   # Displays results in RStudio's Viewer
#  view(dfSummary(tobacco))                       # Same as line above -- view() is a wrapper function

## ----create_html, eval=FALSE---------------------------------------------
#  dfSummary(tobacco, file = "~/Documents/tobacco_summary.html")

## ---- warning=FALSE------------------------------------------------------
what.is(iris)

