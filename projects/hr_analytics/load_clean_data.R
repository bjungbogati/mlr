library("mlr")
library("readr")
library("ggplot2")
library("dplyr")

train.hr <- read_csv("./data/hr_analytics/clean/clean_train_hra.csv")
test.hr <- read_csv("./data/hr_analytics/clean/clean_test_hra.csv")


# is.integer(test.hr$department)
# # 
# 
# 
# train.hr[] <- lapply(train.hr[, 1:12], as.numeric)
# test.hr[] <- lapply(test.hr, as.numeric)
# 
# 
# 
# train.hr$is_promoted <- as.factor(train.hr$is_promoted)
# 
# train.hr$recruitment_channel <- NULL
# test.hr$recruitment_channel <- NULL
# 
# train.hr$awards_won. <- NULL
# test.hr$awards_won. <- NULL
# 
# test.hr$is_promoted <- NULL
# 
