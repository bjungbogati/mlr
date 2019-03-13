library(digest)
library(mlr)
library(parallelMap)

set.seed(2019)

train <- read.csv("./data/mercedes/train.csv", stringsAsFactors = F)
test <- read.csv("./data/mercedes/test.csv", stringsAsFactors = F)

## remove id and categorical features

remove <- c("ID", "X0", "X1", "X2", "X3", "X4", "X5", "X6", "X8")

train <- train[, setdiff(names(train), remove)]

### convert integer to numeric for xgboost

str(train)
train[] <- lapply(train[, 1:369], as.numeric)

## setting modeling in MLR environment

ml_task <- makeRegrTask(data = train, target = "y")

# make 3-fold cross validation

cv_folds <- makeResampleDesc("CV", iters = 3)

# model tune algorithms 

random_tune <- makeTuneControlRandom(maxit = 5L)

# define model 

model <- makeLearner("regr.xgboost")

# define parameter of model and search grid

model_Params <- makeParamSet(
  makeIntegerParam("nrounds", lower=10, upper = 20), 
  makeIntegerParam("max_depth", lower=1, upper = 5), 
  makeNumericParam("lambda", lower=0.55, upper = 0.60), 
  makeNumericParam("eta", lower = 0.001, upper = 0.5), 
  makeNumericParam("subsample", lower = 0.10, upper = 0.80), 
  makeNumericParam("min_child_weight", lower = 1, upper = 5), 
  makeNumericParam("colsample_bytree", lower = 0.2, upper = 0.8)
)

# define numer of CPU cores for training
parallelStartSocket(4L)




# tune model with best parameters

tuned_model <- tuneParams(learner = model, 
                          task = ml_task, 
                          resampling = cv_folds, 
                          measures = rsq, 
                          par.set = model_Params, 
                          control = random_tune, 
                          show.info = F)

# View tuning results

tuned_model

# Apply optimal parameters to model
model <- setHyperPars(learner = model,
                      par.vals = tuned_model$x)

# verify performance on cross validation folds of tune model

resample(model, ml_task, cv_folds, measures = list(rsq, mse))

## train final model with tuned parameters

xgBoost <- train(learner = model, task = ml_task)

## Predict on test set

preds <- predict(xgBoost, newdata = test)

performance(preds, measures = list(fpr, fnr, mmce))


        