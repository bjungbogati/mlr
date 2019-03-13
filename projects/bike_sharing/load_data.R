
library(mlr)
library(readr)
library(data.table)
library(parallelMap)
set.seed(1)

# load data
train = read_csv("./data/bike_sharing_demand/train.csv")
test = read_csv("./data/bike_sharing_demand/test.csv")
dateTest = test$datetime

# Feature Engineering
# Feature engineering

featureEngineer = function(df) {
  # convert holiday, workingday and weather into factors
  names = c("season", "holiday", "workingday", "weather")
  df[,names] = lapply(df[,names], factor)
  # convert datetime into timestamps (in order to split it into day and hour)
  df$datetime = strptime(as.character(df$datetime), format = "%Y-%m-%d %T", tz = "EST")
  # convert hours to factors in separate feature
  df$hour = as.factor(format(df$datetime, format = "%H"))
  # add day of the week as new feature
  df$weekday = as.factor(format(df$datetime, format = "%u"))
  # extract year from date and convert to factor
  df$year = as.factor(format(df$datetime, format = "%Y"))
  # remove duplicated information
  df$datetime = df$casual = df$registered = NULL
  return(df)
}
train = featureEngineer(train)
test = featureEngineer(test)

# convert target feature 

train$count = log1p(train$count)

# create task and learner

trainTask = makeRegrTask(data = train, target = "count")
lrn = makeLearner("regr.xgboost", nrounds = 400, 
                  nthread = 1, base_score = mean(train$count))

# define hyperparameter

ps = makeParamSet(
  makeNumericParam("eta", lower = 0.01, upper = 0.08), 
  makeNumericParam("susample", lower = 0.7, upper = 1), 
  makeNumericParam("colsample_bytree", lower = 0.5, upper = 1), 
  makeIntegerParam("max_depth", lower = 5, upper = 12), 
  makeIntegerParam("min_child_weight", lower = 1, upper = 50)
)


# using random search with maxit iteration

ctrol = makeTuneControlRandom(maxit = 48)
rdesc = makeResampleDesc("CV", iters = 4)

# parallelStartSocket(4L)
# parallelStop()
(res = tuneParams(lrn, trainTask, rdesc, par.set = ps, control = ctrol))
parallelStop()



# Train the model with best hyperparameters
mod = train(setHyperPars(lrn, par.vals = c(res$x, nthread = 16, verbose = 1)), trainTask)


# Make prediction

pred = expm1(getPredictionResponse(predict(mod, newdata = test)))
submit = data.frame(datetime = dateTest, count = pred)

write.csv(submit, file = "./data/bike_sharing_demand/script.csv", row.names = FALSE)












