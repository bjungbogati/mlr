library(mlr)
library(data.table)
library(here)
library(ggplot2)

c.train <- readRDS(here("data", "black_friday", "c_train.RDS"))
c.test <- readRDS(here("data", "black_friday", "c_test.RDS"))


c <- list(c.train, c.test)
combin <- rbindlist(c)
c <- NULL

# remove train test
ntrain <- nrow(c.train)
c.train <- c.test <- NULL

# combin_uid <- combin$User_ID
# combin_pid  <- combin$Product_ID
class(combin$User_ID)

saveRDS(combin$User_ID, here("data", "black_friday", "c-uid.rds"))
saveRDS(combin$Product_ID, here("data", "black_friday", "c-pid.rds"))


combin$User_ID = combin$Product_ID = NULL

combin = normalizeFeatures(setDF(combin), method = "range")

tsk = createDummyFeatures(combin, target = "Purchase")
combin <- NULL
tsk = makeRegrTask(data = tsk, target = "Purchase")



ho = makeFixedHoldoutInstance(train.inds = 1:545915, 
                              test.inds = 545916:779514, 
                              size = 779514)
tsk.train = subsetTask(tsk,  ho$train.inds[[1]])
tsk.test = subsetTask(tsk, ho$test.inds[[1]])

tsk = ho = NULL



# create learner

lrn = makeLearner("regr.xgboost", nrounds = 10)
cv = makeResampleDesc("CV", iters = 5)
res = resample(lrn, tsk.train, cv, rmse)

# tune hyperparameter



ps = makeParamSet(makeNumericParam("eta",0,1),
                  makeNumericParam("lambda",0,200),
                  makeIntegerParam("max_depth",1,20))

tc = makeTuneControlMBO(budget=100)

# parallelization
library(parallelMap)
parallelStartSocket(4L)

tr = tuneParams(lrn,tsk.train,cv5,rmse,ps,tc)
lrn = setHyperPars(lrn,par.vals=tr$x)




# train_user_id <- c.train$User_ID
# train_prd_id <- c.train$Product_ID 
# 
# test_user_id <- c.test$User_ID
# test_prd_id <- c.test$Product_ID
# 
# c.train$User_ID = c.train$Product_ID = NULL
# c.test$User_ID =  c.test$Product_ID = NULL
# 
# c.train[] <- lapply(c.train, as.numeric)
# c.test[] <- lapply(c.test, as.numeric)
# 
# c.train$Purchase <- as.factor(c.train$Purchase)
# c.test$Purchase <- as.factor(c.test$Purchase)
# # creating learners
# set.seed(2019)
# 
# tsk = makeClassifTask(data = c.train, target = "Purchase")
# ho = makeResampleInstance("Holdout", tsk)
# 
# tsk.train = subsetTask(tsk, ho$train.inds[[1]])
# tsk.test = subsetTask(tsk, ho$test.inds[[1]])
# 
# lrn = makeLearner("classif.xgboost", nrounds = 10)
# cv = makeResampleDesc("CV", iters = 5)
# res = resample(lrn, tsk.train, cv, acc)
# 
