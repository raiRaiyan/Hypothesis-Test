args = commandArgs(TRUE)

if(args[1]=="goodfittest"){
  contingencyTable = read.csv(args[2])
   
  obs = as.vector(contingencyTable[[2]])
  obs = obs[!is.na(obs)]
  prob = as.vector(as.numeric(contingencyTable[[3]]))
  prob = prob[!is.na(prob)]
  
  
  result = chisq.test(x=obs,p=prob,correct=F)
  cat(result$p.value)
  
}
df1 = result$parameter

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

p <- ggplot(data.frame(x=c(0,20)),aes(x=x)) + 
  stat_function(fun=CDist, geom="area", fill="white", colour="black") 

p <- p + stat_function(fun =upperTail, geom="area", fill='#b14025')


p <- p + theme(panel.grid.major=element_blank(), 
               panel.grid.minor=element_blank(),
               panel.background=element_rect(fill="#eae9c8") )
plot(p)
ggsave("chiSquare.png",width = 8,height = 8)