source("./projects/iris/preprocess_iris.R")

# create learner and evaluate performance

lrn = makeLearner("classif.xgboost", nrounds = 5L)
cv = makeResampleDesc("CV", iters = 5L)
res = resample(lrn, tsk.train, cv, acc)

# tune hyperparameter

ps = makeParamSet(makeNumericLearnerParam("eta", 0, 1), 
                  makeNumericLearnerParam("lambda", 0, 200), 
                  makeIntegerParam("max_depth", 1, 20))

tc = makeTuneControlRandom(maxit = 50L)

tr = tuneParams(lrn, tsk.train, cv, acc, ps, tc)

lrn = setHyperPars(lrn, par.vals = tr$x)

?makeTuneControlRandom
## using tuned hyperparameters

mdl = train(lrn, tsk.train)
prd = predict(mdl, tsk.test)
performance(prd,  measures = list(acc, mmce))
calculateConfusionMatrix(prd)
mdl = train(lrn, tsk)

performance(prd,  measures = list(acc, mmce))
