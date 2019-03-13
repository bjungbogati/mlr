# building model
linear_reg_mod <- lm(Item_Outlet_Sales ~ ., data = train[,-c("Item_Identifier")])

# making predictions on test data
submission$Item_Outlet_Sales <- predict(linear_reg_mod, test[, -c("Item_Identifier")])

# write submission
write.csv(submission, "Linear_Reg_submit.csv", row.names = F)
