vars <- commandArgs(trailingOnly = TRUE);

test <- as.numeric(vars[1])
path <- vars[2]
col1 <- vars[3]
repl <- as.numeric(vars[4])

if(test!=0)
{
  col2 <- vars[5]
  repl2 <- as.numeric(vars[6])
}

data <- read.csv(path,stringsAsFactors = FALSE,na.strings = c(NULL,'null',''))

if(test==0)
{
  colData1 <- data[,col1]
  colData1[is.na(colData1)] <- repl
  mean1 <- mean(colData1)
  mean1 <- round(mean1,digits = 4)
  SD1 <- sd(colData1)
  SD1 <- round(SD1,digits = 4)
  size1 <- length(colData1)
  size1 <- round(size1,digits = 4)
  cat(paste0(mean1,',',SD1,',',size1))
}

if(test==1)
{
  colData1 <- data[,col1]
  colData1[is.na(colData1)] <- repl
  mean1 <- mean(colData1)
  mean1 <- round(mean1,digits = 4)
  SD1 <- sd(colData1)
  SD1 <- round(SD1,digits = 4)
  size1 <- length(colData1)
  size1 <- round(size1,digits = 4)
  
  colData2 <- data[,col2]
  colData2[is.na(colData2)] <- repl2
  mean2 <- mean(colData2)
  mean2 <- round(mean2,digits = 4)
  SD2 <- sd(colData2)
  SD2 <- round(SD2,digits = 4)
  size2 <- length(colData2)
  size2 <- round(size2,digits = 4)
  
  cat(paste0(mean1,',',SD1,',',size1,',',mean2,',',SD2,',',size2))
}

if(test==2)
{
  colData1 <- data[,col1]
  colData1[is.na(colData1)] <- repl
  
  colData2 <- data[,col2]
  colData2[is.na(colData2)] <- repl2
  
  mean1 <- mean(colData1-colData2)
  mean1 <- round(mean1,digits = 4)
  SD1 <- sd(colData1-colData2)
  SD1 <- round(SD1,digits = 4)
  size1 <- length(colData1)
  size1 <- round(size1,digits = 4)
  
  cat(paste0(mean1,',',SD1,',',size1))
}
rm(list = ls())