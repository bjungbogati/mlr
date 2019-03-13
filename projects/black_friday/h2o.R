
library(data.table)
library(here)



c.train <- readRDS(here("data", "black_friday", "c_train.RDS"))
c.test <- readRDS(here("data", "black_friday", "c_test.RDS"))

c.train <- c.train[c.train$Product_Category_1 <= 18,]

library(h2o)
localH2O <- h2o.init(nthreads = -1)


#data to h2o cluster
train.h2o <- as.h2o(c.train)
test.h2o <- as.h2o(c.test)

#dependent variable (Purchase)
y.dep <- 14

#independent variables (dropping ID variables)
x.indep <- c(3:13,15:20)




colnames(train.h2o)


# Multiple Regression in H2O
regression.model <- h2o.glm( y = y.dep, x = x.indep, training_frame = train.h2o, family = "gaussian")

h2o.performance(regression.model)


#make predictions
predict.reg <- as.data.frame(h2o.predict(regression.model, test.h2o))
sub_reg <- data.frame(User_ID = test$User_ID, Product_ID = test$Product_ID, Purchase =  predict.reg$predict)

write.csv(sub_reg, file = here("data", "black_friday", "sub_reg.csv"), row.names = F)

# -----------------------------------------------------------------------

# Random Forest in H20

system.time(rforest.model <- h2o.randomForest(y=y.dep, x=x.indep, training_frame = train.h2o, ntrees = 1000, mtries = 3, max_depth = 4, seed = 1122))


h2o.performance(rforest.model)

#making predictions on unseen data
system.time(predict.rforest <- as.data.frame(h2o.predict(rforest.model, test.h2o)))


#writing submission file
sub_rf <- data.frame(User_ID = test$User_ID, Product_ID = test$Product_ID, Purchase =  predict.rforest$predict)
write.csv(sub_rf, file = here("data", "black_friday", "sub_rf.csv"), row.names = F)



# ----------------------------------------------------------------------------------

#GBM

system.time(
  gbm.model <- h2o.gbm(y=y.dep, x=x.indep, training_frame = train.h2o, ntrees = 1000, max_depth = 4, learn_rate = 0.01, seed = 1122)
)

h2o.performance (gbm.model)



#making prediction and writing submission file
predict.gbm <- as.data.frame(h2o.predict(gbm.model, test.h2o))

sub_gbm <- data.frame(User_ID = test$User_ID, Product_ID = test$Product_ID, Purchase = predict.gbm$predict)
write.csv(sub_gbm, file = here("data", "black_friday", "sub_gbm.csv"), row.names = F)

# - ------------------------------

## Deep Learning in H2O


#deep learning models
system.time(
  dlearning.model <- h2o.deeplearning(y = y.dep,
                                      x = x.indep,
                                      training_frame = train.h2o,
                                      epoch = 60,
                                      hidden = c(100,100),
                                      activation = "Rectifier",
                                      seed = 1122
  )
)

h2o.performance(dlearning.model)


predict.dl2 <- as.data.frame(h2o.predict(dlearning.model, test.h2o))

#create a data frame and writing submission file
sub_dlearning <- data.frame(User_ID = test$User_ID, Product_ID = test$Product_ID, Purchase = predict.dl2$predict)
write.csv(sub_dlearning, file = here("data", "black_friday", "sub_dlearning_new.csv"), row.names = F)









