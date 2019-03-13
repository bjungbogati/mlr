set.seed(1236) 
my_control <- trainControl(method="cv", number=5) 
Grid <- expand.grid(alpha = 0, lambda = seq(0.001,0.1,by = 0.0002)) 
ridge_linear_reg_mod <- train(x = train[, -c("Item_Identifier", "Item_Outlet_Sales")], 
                              y = train$Item_Outlet_Sales, 
                              method='glmnet', trControl= my_control, tuneGrid = Grid)
