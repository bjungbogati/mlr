## Pre-processing

## transformation applied to data before feeding to algorithms
## involves further cleaning, data transformation, data scaling and more..



# removing skewness
combi[, Item_Visibility := log(Item_Visibility + 1)]
combi[, price_per_unit_wt := log(price_per_unit_wt + 1)]

# Scaling numeric predictors

num_vars <- which(sapply(combi, is.numeric))

num_vars_names <- names(num_vars)

combi_numeric <- combi[, setdiff(num_vars_names, "Item_Outlet_Sales"), with = F]

prep_num <- preProcess(combi_numeric, method=c("center", "scale"))

combi_numeric_norm <- predict(prep_num, combi_numeric)

combi[, setdiff(num_vars_names, "Item_Outlet_Sales") := NULL]
combi <- cbind(combi, combi_numeric_norm)


# Splitting the combined data 

train <- combi[1:nrow(train)] 
test <- combi[(nrow(train) + 1):nrow(combi)]
test[, Item_Outlet_Sales := NULL]

## Correlated Variables

cor_train <- cor(train[, -c("Item_Identifier")])

corrplot(cor_train, method = "pie", type = "lower", tl.cex = 0.9)


