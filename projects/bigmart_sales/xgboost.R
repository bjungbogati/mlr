param_list <- list(objective = "reg:linear", eta=0.01, gamma = 1, max_depth=6, subsample=0.8, colsample_bytree=0.5)

dtrain <- xgb.DMatrix(data = as.matrix(train[,-c("Item_Identifier", "Item_Outlet_Sales")]), 
                      label= train$Item_Outlet_Sales) 

dtest <- xgb.DMatrix(data = as.matrix(test[,-c("Item_Identifier")]))

# Cross Validation

set.seed(112) 

xgbcv <- xgb.cv(params = param_list, data = dtrain, 
                nrounds = 1000, nfold = 5, print_every_n = 10, 
                early_stopping_rounds = 30, maximize = F)

# Model Training

xgb_model <- xgb.train(data = dtrain, params = param_list, nrounds = 430)


# Variable Importance
var_imp = xgb.importance(feature_names = setdiff(names(train), c("Item_Identifier", "Item_Outlet_Sales")), model = xgb_model) 

xgb.plot.importance(var_imp)

