library("mlr")

set.seed(2019)

train.upvote <- read.csv("./data/upvotes/train_upvote.csv", stringsAsFactors = F)
test.upvote <- read.csv("./data/upvotes/test_upvote.csv", stringsAsFactors = F)

# ind <- caret::createDataPartition(upvote$ID, p = 0.7, list = FALSE)
# train.upvote <- upvote[ind,]
# test.upvote <- upvote[-ind,]


# data cleaning

train.upvote$ID <- NULL
train.upvote$Username <- NULL
train.upvote$Tag <- as.factor(train.upvote$Tag)


# train.upvote <- gather(train.upvote, "Var", "Num", -Upvotes, -Answers, -Tag)




trainTask <- normalizeFeatures(train.upvote, method = "standardize", range = c(0,1))
train.upvote <- NULL

testTask <- normalizeFeatures(test.upvote, method = "standardize", range = c(0,1))


testTask$ID <- NULL

testTask$Upvotes <- 0L
testTask$Tag <- as.factor(testTask$Tag)

testTask <- makeRegrTask(id = "upvote", data = testTask, target = "Upvotes")

## creating a task

trainTask <- makeRegrTask(id = "upvote", data = trainTask, target = "Upvotes")
trainTask


# testTask <- makeClassifTask(data = test.upvote, target = "Upvote")


regr.lrn = makeLearner("regr.gbm", par.vals = list(n.trees = 500, interaction.depth = 3))

mod =  train(regr.lrn, trainTask)
getLearnerModel(mod)

rfmodel <-predict(mod, testTask)

performance(rfmodel, measures = list(rmse))

