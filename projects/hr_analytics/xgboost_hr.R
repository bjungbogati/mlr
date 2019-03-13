
# source("./projects/hr_analytics/load_clean_data.R")
# set.seed(2019)

# tsk.train <- normalizeFeatures(train.hr, method = "range")
# tsk.test <- normalizeFeatures(test.hr, method = "range")
# 
# View(tsk.test)

# # create a task
# 
# tsk.train <- makeClassifTask(id = "HR train", data = tsk.train , target = "is_promoted")
# tsk.test <- makeClassifTask(id = "HR test", data = tsk.test, target = "is_promoted")

library(parallelMap)

# parallelStart(mode = "multicore", cpus = 2)
parallelStartSocket(4L)

# parallelStop()

# create learner

lrn <- makeLearner("classif.xgboost", nrounds = 5,  predict.type = "prob")
cv <- makeResampleDesc("CV", iters = 10)

res <- resample(lrn, tsk.train, cv, acc)

# hyperparameter 

ps <- makeParamSet(makeNumericParam("eta",0,1),
             makeNumericParam("lambda",0,200),
             makeIntegerParam("max_depth",1,20))

tc <- makeTuneControlMBO(budget=100)
# tc <- makeTuneControlRandom(maxit = 100L)

tr <- tuneParams(lrn,tsk.train,cv5,acc,ps,tc)

lrn <- setHyperPars(lrn,par.vals=tr$x)

# train model
mdl = train(lrn, tsk.train)

saveRDS(mdl, file="./projects/hr_analytics/xgboost_hra.Rds")

prd = predict(mdl, tsk.test)

calculateConfusionMatrix(prd)

performance(prd,measures = list(acc, mmce))


im_feat <- generateFilterValuesData(tsk.train, method = c("information.gain","chi.squared"))

im_feat

plotFilterValues(im_feat,n.show = 20)
