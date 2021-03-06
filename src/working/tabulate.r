args = commandArgs(TRUE)

require("data.table",quietly=TRUE)
library("data.table")

filepath = args[2]

if(args[1] == "goodfittest"){
  data = fread(filepath,select=args[3],showProgress=FALSE)
  data = as.character(data[[args[3]]])
  if(args[4] == 'r' || args[4] == 'R'){
    data = data[data != '']
  }else{
    data[data==''] = args[4]
  }
  data = as.factor(data)
  tabulatedData = table(data)
  cat(levels(data),'\n',file = "tabulatedDataFile",sep=",")
  cat(tabulatedData,file = "tabulatedDataFile",sep=",",append = TRUE)
}else{
  data = fread(filepath,select=c(args[3],args[4]),showProgress=FALSE)
  col1 = as.character(data[[args[3]]])
  col2 = as.character(data[[args[4]]])
  rm(data)
      col1[col1 == ''] = args[5]
      col2[col2 == ''] = args[6]
  col1 = as.factor(col1)
  col2 = as.factor(col2)
  tabulatedData = table(col1,col2)
  cat(levels(col1),'\n',file = "tabulatedDataFile",sep=",")
  cat(levels(col2),'\n',file = "tabulatedDataFile", sep=",",append=TRUE)
  cat(tabulatedData,file = "tabulatedDataFile",sep=",",append = TRUE)
}