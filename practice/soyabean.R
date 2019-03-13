library(mlr)
library(mlbench)
data(Soybean)
library("mlrMBO")

#install.packages("mlrMBO")

# devtools::install_github("cran/DiceKriging")

# prepare train-test data
soy = createDummyFeatures(Soybean, target = "Class")
tsk = makeClassifTask(data = soy, target = "Class")
ho = makeResampleInstance("Holdout", tsk)
tsk.train = subsetTask(tsk, ho$train.inds[[1]])
tsk.test = subsetTask(tsk, ho$test.inds[[1]])

# create learner and evaluate performance

lrn = makeLearner("classif.xgboost", nrounds = 10L)
cv = makeResampleDesc("CV", iters = L)
res = resample(lrn, tsk.train, cv, acc)

# tune hyperparameter

ps = makeParamSet(makeNumericLearnerParam("eta", 0, 1), 
                  makeNumericLearnerParam("lambda", 0, 200), 
                  makeIntegerParam("max_depth", 1, 20))

tc = makeTuneControlMBO(budget = 100L)

tr = tuneParams(lrn, tsk.train, cv5, acc, ps, tc)

lrn = setHyperPars(lrn, par.vals = tr$x)


## using tuned hyperparameters


mdl = train(lrn, tsk.train)
prd = predict(mdl, tsk.test)
performance(prd,  measures = list(acc, mmce))
calculateConfusionMatrix(prd)
mdl = train(lrn, tsk)

performance(prd,  measures = list(acc, mmce))