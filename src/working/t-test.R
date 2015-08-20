# Get the inputs
vars = as.numeric(commandArgs(trailingOnly = TRUE))

test = vars[1]
tails = vars[2]
popnMean = vars[3]
mean1 = vars[4]
sd1 = vars[5]
n1 = vars[6]

if(test==1)
{
  mean2 = vars[7]
  sd2 = vars[8]
  n2 = vars[9]
}

#Compute the t-value
if(test==1)
{
  free = pmin(n1,n2) - 1
  tValue = (mean1-mean2-popnMean)/(sqrt(((sd1*sd1)/n1) + ((sd2*sd2)/n2)))
}else
{
  free = n1-1
  tValue = (mean1-popnMean)/(sd1/sqrt(n1))
}

library(ggplot2,quietly = T)

twoTails <- function(x)
{
  y <- dt(x,df = free)
  y[abs(x) < abs(tValue)] <- NA
  return(y)
}

lowerTail = function(x)
{
  y = dt(x,df = free)
  y[x>tValue] = NA
  return(y)
}

upperTail = function(x)
{
  y = dt(x,df = free)
  y[x<tValue] = NA
  return(y)
}

tDist <- function(x)
{
  dt(x,df = free)
}

p <- ggplot(data.frame(x=c(-6,6)),aes(x=x)) + 
  stat_function(fun=tDist, geom="area", fill="white", colour="black") 

if(tails==0)
{
  pValue = 2*pt(tValue,free,lower.tail = TRUE)
  p <- p + stat_function(fun =twoTails, geom="area", fill='#b14025')
}else if(tails==1)
{
  pValue = pt(tValue,free,lower.tail = TRUE)
  p <- p + stat_function(fun =lowerTail, geom="area", fill='#b14025')
}else
{
  pValue = pt(tValue,free,lower.tail = FALSE)
  p <- p + stat_function(fun =upperTail, geom="area", fill='#b14025')
}

p <- p + theme(panel.grid.major=element_blank(), 
               panel.grid.minor=element_blank(),
               panel.background=element_rect(fill="#eae9c8") )
ggsave("outputImg.png",width = 8,height = 8)

cat(paste0(pValue))