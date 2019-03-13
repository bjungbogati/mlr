# load the data

library(mlr)
library(ggplot2)
library(tidyr)

data(iris) 
head(iris)



iris.val <- iris %>% gather(Feature, Value, -Species)
ggplot(iris.val, aes(x = Value, fill = Species)) + 
  facet_wrap(~Feature, scales = "free_x") + 
  geom_histogram(bins = 30) 

ggplot(iris.val, aes(x = Species, y = Value, fill = Species)) +
  facet_wrap(~Feature) + 
  geom_violin()
# 
# ggplot(iris, aes(x = Petal.Length, y = Petal.Width, color = Species)) + geom_point()
# ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) + geom_point()

corrplot::corrplot(cor(iris[, -5]))

tsk = makeClassifTask(data = iris, target = "Species")

ho = makeResampleInstance("Holdout", tsk)

tsk.train = subsetTask(tsk, ho$train.inds[[1]])

tsk.test = subsetTask(tsk, ho$test.inds[[1]])

lrn = makeLearner("classif.lda")

# cv = makeResampleDesc("CV",iters=5)
# 
# res = resample(lrn,tsk.train,cv,acc)

mdl = train(lrn,tsk.train)
prd = predict(mdl,tsk.test)

performance(prd, measures = list(acc, mmce))

