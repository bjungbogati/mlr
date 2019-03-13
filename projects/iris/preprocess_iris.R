#preprocess 

source("./projects/iris/load_iris.R")

# iris = select(iris, c("Petal.Width", "Petal.Length", "Sepal.Length", "Species"))

set.seed(2019)

iris = normalizeFeatures(iris, target = "Species", method = "range")
tsk = makeClassifTask(data = iris, target = "Species")

ind = makeFixedHoldoutInstance(train.inds = 1:120, test.inds = 121:150, size = 150)

# ind = makeResampleInstance("Holdout", tsk)

tsk.train = subsetTask(tsk, ind$train.inds[[1]])
tsk.test = subsetTask(tsk, ind$test.inds[[1]])