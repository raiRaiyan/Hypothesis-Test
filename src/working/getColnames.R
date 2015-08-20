vars = commandArgs(trailingOnly = TRUE)
path = vars[1]
dat = read.csv(path,na.strings = c(NULL,'null',''),stringsAsFactors = FALSE)
nums = sapply(dat,is.numeric)
cols = colnames(dat[,nums])
cat(paste0(cols,collapse = ','))
rm(list=ls())