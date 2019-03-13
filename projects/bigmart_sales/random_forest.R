set.seed(1237) 

my_control = trainControl(method="cv", number=5) # 5-fold CV 

tgrid = expand.grid(
  .mtry = c(3:10),
  .splitrule = "variance",
  .min.node.size = c(10,15,20)
)

rf_mod = train(x = train[, -c("Item_Identifier", "Item_Outlet_Sales")],
               y = train$Item_Outlet_Sales,
               method='ranger',
               trControl= my_control,
               tuneGrid = tgrid,
               num.trees = 400,
               importance = "permutation")

# Best Model Parameters

plot(rf_mod)

# Variable Importance

plot(varImp(rf_mod))



