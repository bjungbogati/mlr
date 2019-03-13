source("./projects/iris/preprocess_iris.R")

rf <- makeLearner("classif.randomForest", id = "randomForest", 
                  predict.type = "prob")

rf$par.vals <- list(
  importance = TRUE
)

rf_param <- makeParamSet(
  makeIntegerParam("ntree", lower = 50, upper = 100),
  makeIntegerParam("mtry", lower = 1, upper = 5),
  makeIntegerParam("nodesize", lower = 10, upper = 50)
)

rancontrol <- makeTuneControlRandom(maxit = 50L)

# set 10 fold cross validation
set_cv <- makeResampleDesc("CV", iters = 10L)

# hypertuning
rf_tune <- tuneParams(learner = rf, resampling = set_cv, task = tsk.train, 
                      par.set = rf_param, control = rancontrol, measures = acc)

# cv accuracy
rf_tune$y

# best parameters
rf_tune$x

### Building model
rf.tree <- setHyperPars(rf, par.vals = rf_tune$x)

## train model
rforest <- train(rf.tree, tsk.train)
getLearnerModel(rforest)


saveRDS(rforest, "./projects/iris/iris_model.rds")

# rforest <- readRDS("iris_model.rds")

# make predict
rfmodel <- predict(rforest, tsk.test)

#performance
performance(rfmodel, measures = list(acc, mmce))