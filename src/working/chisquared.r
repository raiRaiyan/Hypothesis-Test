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