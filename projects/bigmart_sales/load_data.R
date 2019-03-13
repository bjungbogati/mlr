# loading packages

library(data.table)
library(dplyr)
library(caret)
library(corrplot)
library(cowplot)

# load the data
train <- fread("./data/bigmart_sales/train_bigmart.csv")
test <- fread("./data/bigmart_sales/test_bigmart.csv")

# dimension
dim(train);dim(test)

# features
names(train)
names(test)

# structure
str(train)
str(test)

# combining train test data

# test[, Item_Outlet_Sales :=NA]

test$Item_Outlet_Sales <- NA

combi <- rbind(train, test)
dim(combi)
