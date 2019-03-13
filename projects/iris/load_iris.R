# load the data
# sssh <- suppressMessages())

PKGs <- c("mlr", "ggplot2", "tidyr", "readr")
suppressWarnings(lapply(PKGs, library, character.only = T, quietly = T))

data(iris) 

