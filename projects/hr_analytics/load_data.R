library("mlr")
library("readr")
library("ggplot2")
library("dplyr")

train.hr <- read_csv("./data/hr_analytics/train_hra.csv")
test.hr <- read_csv("./data/hr_analytics/test_hra.csv")

# dim(train.hr)
# dim(test.hr)

# combine data
# colnames(train.hr)
# 
# View(train.hr)
# 
# Mode <- function(x) {
#   ux <- unique(x)
#   ux[which.max(tabulate(match(x, ux)))]
# }
# 
# Mean(comb.hr$department)