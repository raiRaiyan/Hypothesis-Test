args = commandArgs(TRUE)

require("data.table",quietly=TRUE)

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
  cat(levels(data),'\n',file = "tabulatedDataFile")
  cat(tabulatedData,file = "tabulatedDataFile",append = TRUE)
}else{
  data = fread(filepath,select=c(args[3],args[4]),showProgress=FALSE)
  col1 = as.character(data[[args[3]]])
  col2 = as.character(data[[args[4]]])
  rm(data)
  if(args[5] == 'r' || args[5] == 'R'){
      col1 = col1[col1 != '']
    }else{
      col1[col1 == ''] = args[5]
    }
    if(args[6] == 'r' || args[6] == 'R'){
      col2 = col2[col2 != '']
    }else{
      col2[col2 == ''] = args[6]
    }
  col1 = as.factor(col1)
  col2 = as.factor(col2)
  tabulatedData = table(col1,col2)
  cat(levels(col1),'\n',file = "tabulatedDataFile")
  cat(levels(col2),'\n',file = "tabulatedDataFile", append=TRUE)
  cat(tabulatedData,file = "tabulatedDataFile",append = TRUE)
}