
source("./projects/iris/preprocess_iris.R")

tsk = makeClassifTask(data = iris, target = "Species")

ho = makeResampleInstance("Holdout", tsk)

tsk.train = subsetTask(tsk, ho$train.inds[[1]])
tsk.test = subsetTask(tsk, ho$test.inds[[1]])

lrn = makeLearner("classif.lda")

# cv = makeResampleDesc("CV",iters=5)
# 
# res = resample(lrn,tsk.train,cv,acc)

mdl = train(lrn, tsk.train)
prd = predict(mdl, tsk.test)

performance(prd, measures = list(acc, mmce))
