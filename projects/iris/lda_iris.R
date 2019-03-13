
source("./projects/iris/preprocess_iris.R")

# source("./projects/iris/load_iris.R")

# tsk = makeClassifTask(data = iris, target = "Species")
# ind = makeResampleInstance("Holdout", tsk)
# 
# 
# tsk.train = subsetTask(tsk, ind$train.inds[[1]])
# tsk.test = subsetTask(tsk, ind$test.inds[[1]])

lrn = makeLearner("classif.lda")

mdl = train(lrn, tsk.train)
prd = predict(mdl, tsk.test)

performance(prd, measures = list(acc, mmce))
