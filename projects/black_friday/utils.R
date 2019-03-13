

# The following two commands remove any previously installed H2O packages for R.
if ("package:h2o" %in% search()) { detach("package:h2o", unload=TRUE) }
if ("h2o" %in% rownames(installed.packages())) { remove.packages("h2o") }

# Next, we download packages that H2O depends on.
pkgs <- c("RCurl","jsonlite")
for (pkg in pkgs) {
  if (! (pkg %in% rownames(installed.packages()))) { install.packages(pkg) }
}

# Now we download, install and initialize the H2O package for R.
install.packages("h2o", type="source", repos="http://h2o-release.s3.amazonaws.com/h2o/rel-xu/5/R")


library(data.table)
library(here)

dt_load <- function(x, y){
  
  # start.time <- Sys.time()
  # l <- here("data", "black_friday")
  # x <- paste(l, x, sep="/")
  # y <- paste(l, y, sep="/")
  # 
  # return(x)
  
  train <- fread(x, stringsAsFactors = T)
  test <- fread(y, stringsAsFactors = T)
  
  # end.time <- Sys.time()
  # time.taken <- end.time - start.time
  # time.taken
  
}

dt_load("./data/black_friday/train_bf.csv", "./data/black_friday/test_bf.csv")

df_load <-function(x, y){
  start.time <- Sys.time()
  train <- read.csv(here("data", "black_friday", x), stringsAsFactors = T)
  test <- read.csv(here("data", "black_friday", y), stringsAsFactors = T)
  end.time <- Sys.time()
  time.taken <- end.time - start.time
  time.taken
  
  return(train)
  return(test)
}

df_load("train_bf.csv", "test_bf.csv")
