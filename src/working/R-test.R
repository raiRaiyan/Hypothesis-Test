cat("cool")
tryCatch(
  {
    library(data.table)
  },
  error = function(e)
  {
    install.packages("data.table")
  }
)
tryCatch(
  {
    library(ggplot2)
  },
  error = function(e)
  {
    install.packages("data.table")
  }
)