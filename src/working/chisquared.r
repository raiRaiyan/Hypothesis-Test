args = commandArgs(TRUE)

contingencyTable = read.csv(args[2])

if(args[1]=="goodfittest"){
   
  obs = as.vector(contingencyTable[[2]])
  prob = as.vector(as.numeric(contingencyTable[[3]]))
  
  range =c(0,20)
  
  result = chisq.test(x=obs,p=prob,correct=F)
  cat(result$p.value)
  
}else{
  #remove the row names and pass the table to chisq.tests
  contingencyTable[[1]] = NULL;
  tab = as.matrix.data.frame(contingencyTable)
  
  range = c(0,20)
  result = chisq.test(x=tab,correct = F)
  cat(result$p.value)
}
df1 = result$parameter
if(df1>4){
  range = c(0,60)
}

library(ggplot2,quietly = T)

upperTail = function(x)
{
  y = dchisq(x,df = df1)
  y[x<result$statistic] = NA
  return(y)
}

CDist <- function(x)
{
  dchisq(x,df = df1)
}

p <- ggplot(data.frame(x=range),aes(x=x)) + 
  stat_function(fun=CDist, geom="area", fill="white", colour="black") 

p <- p + stat_function(fun =upperTail, geom="area", fill='#b14025')


p <- p + theme(panel.grid.major=element_blank(), 
               panel.grid.minor=element_blank(),
               panel.background=element_rect(fill="#eae9c8") )
plot(p)
ggsave("chiSquare.png",width = 8,height = 8)