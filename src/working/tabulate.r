args = commandArgs(TRUE)

require("data.table",quietly=TRUE)

filepath = args[2]

if(args[1] == "goodfittest"){
  data = fread(filepath,select=args[3],showProgress=FALSE)
  data = as.factor(data[[args[3]]])
  tabulatedData = table(data)  
  cat(levels(data),'\n')
  cat(tabulatedData)
}


