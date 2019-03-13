# set working directory
library("mlr")

# loading data
wbcd <- read.csv("./data/mlrbook/wisc_bc_data.csv", stringsAsFactors = F)

# seeing head

head(wbcd)

# drop the table
wbcd$id <- NULL

## Train & Test split

# set.seed(2019)
# dt = sort(sample(nrow(wbcd), nrow(wbcd)*.7))
# train<-wbcd[dt,]
# test<-wbcd[-dt,]

set.seed(2019)
ind <- caret::createDataPartition(wbcd$diagnosis, p = 0.7, list = FALSE)
train.wbcd <- wbcd[ind,]
test.wbcd <- wbcd[-ind,]


## creating a task

trainTask <- makeClassifTask(data = train.wbcd, target = "diagnosis")
testTask <- makeClassifTask(data = test.wbcd, target = "diagnosis")

# check if class has postivity or not
class(trainTask)

# deeper view

str(getTaskData(trainTask))

## normalize the variables

trainTask <- normalizeFeatures(trainTask, method = "range", range = c(0,1))
testTask <- normalizeFeatures(testTask, method = "range", range = c(0,1))

rf <- makeLearner("classif.randomForest", id = "randomForest", 
                   predict.type = "prob", 
                   par.vals = list(ntree = 200, mtry = 3))

rf$par.vals <- list(
  importance = TRUE
)

rf_param <- makeParamSet(
  makeIntegerParam("ntree",lower = 50, upper = 500),
  makeIntegerParam("mtry", lower = 3, upper = 10),
  makeIntegerParam("nodesize", lower = 10, upper = 50)
)

rancontrol <- makeTuneControlGrid(resolution=10L)

# set 10 fold cross validation

set_cv <- makeResampleDesc("CV", iters = 10L)

# hypertuning

rf_tune <- tuneParams(learner = rf, resampling = set_cv, task = trainTask, 
                      par.set = rf_param, control = rancontrol, measures = acc)


# cv accuracy
rf_tune$y

# best parameters

rf_tune$x

### Building model

rf.tree <- setHyperPars(rf, par.vals = rf_tune$x)

## train model

rforest <- train(rf.tree, trainTask)
getLearnerModel(rforest)

# saveRDS(rforest, "./wbcd_model.rds")

rforest <- readRDS("wbcd_model.rds")

# make predict
rfmodel <- predict(rforest, testTask)


performance(rfmodel, measures = list(acc, auc, fpr, fnr, mmce))

getFeatureImportance(rforest)

n <- data.frame(getFeatureImportance(rforest)$res)

library(tidyr)
library(dplyr)


n <- n %>% gather(feature, importance) %>% 
  arrange(desc(importance))

n

library(ggplot2)

ggplot(n, aes(x = feature, y = importance)) + geom_boxplot()

# 
# mod <- train(lrn, trainTask)
# 
# task.pred <- predict(mod, task = testTask)
# task.pred


# head(as.data.frame(task.pred))
# calculateConfusionMatrix(task.pred, relative = TRUE, sums = TRUE)
# performance(task.pred)


library(rJava)
library(FSelector)

im_feat <- generateFilterValuesData(trainTask, method = c("information.gain","chi.squared"))


plotFilterValues(im_feat,n.show = 20)


feat <- c("concave.points.worst", "area.worst", "perimeter.wrost", "concave.points.mean", "radiuss.worst")



