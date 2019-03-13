sum(is.na(combi$Item_Weight))


# Imputing Missing Value

# missing_index <- which(is.na(combi$Item_Weight))
# for(i in missing_index) {
#   item = combi$Item_Identifier[i]
#   combi$Item_Weight[i] = mean(combi$Item_Weight[combi$Item_Identifier == item],
#                               na.rm = T)
# }

str(combi)

# changing data type

# combi$Item_Fat_Content <- as.factor(combi$Item_Fat_Content)
# combi$Item_Type <- as.factor(combi$Item_Type)
# combi$Outlet_Size <- as.factor(combi$Outlet_Size)
# combi$Outlet_Type <- as.factor(combi$Outlet_Type)

# replace zero with NA
# civ <- which(combi$Item_Visibility == 0)

# combi$Item_Visibility[combi$Item_Visibility == 0] <- NA

# combi <- setDF(combi)
# 
# # imputing values 
# combi <- impute(combi, classes = list(integer = imputeMean(), 
#                              factor = imputeMode()))
# 
# n <- combi$data

## setDF()


missing_index = which(is.na(combi$Item_Weight)) 
for(i in missing_index){    
  item = combi$Item_Identifier[i]  
  combi$Item_Weight[i] = mean(combi$Item_Weight[combi$Item_Identifier == item], 
                              na.rm = T) }

sum(is.na(combi$Item_Weight))


zero_index = which(combi$Item_Visibility == 0) 
for(i in zero_index){    
  item = combi$Item_Identifier[i]  
  combi$Item_Visibility[i] = mean(combi$Item_Visibility[combi$Item_Identifier == item], 
                                  na.rm = T)  }

ggplot(combi$data) + geom_histogram(aes(combi$Item_Visibility), bins = 100)