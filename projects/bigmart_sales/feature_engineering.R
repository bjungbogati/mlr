
# features in dataset are not sufficient for satisfoactory predictions

# Here, we create new features

# Item_Type_New
# Item_Category
# Outlet_Years
# Price_Per_Unit_Wt
# Item_MRP_Clusters


perishable <- c("Breads", "Breakfast", "Diary", "Fruits and Vegetables", 
                "Meat", "Seafood")

non_perishable <- c("Baking Goods", "Canned", "Frozen Foods", "Hards Drinks", 
                    "Health and Hygiene", "Household", "Soft DRinks")

# setDT - covert to data.table

combi <- setDT(combi$data)

# combi <- setDT(combi)

str(combi)

# create a new feature "Item_Type_New"

combi[, Item_Type_New := ifelse(Item_Type %in% perishable, "perishable", 
                        ifelse(Item_Type %in% non_perishable, 
                               "non_perishable", "not_sure"))]

table(combi$Item_Type, substr(combi$Item_Identifier, 1, 2))


combi[, Item_category := substr(combi$Item_Identifier, 1, 2)]

###

combi$Item_Fat_Content[combi$Item_category == "NC"] = "Non-Edible" 

combi[,Outlet_Years := 2013 - Outlet_Establishment_Year] 

combi$Outlet_Establishment_Year = as.factor(combi$Outlet_Establishment_Year) 

combi[, price_per_unit_wt := Item_MRP/Item_Weight]



combi[,Item_MRP_clusters := ifelse(Item_MRP < 69, "1st",                                    
                            ifelse(Item_MRP >= 69 & Item_MRP < 136, "2nd",                                          
                            ifelse(Item_MRP >= 136 & Item_MRP < 203, "3rd", "4th")))]



combi[,Outlet_Size_num := ifelse(Outlet_Size == "Small", 0, 
                                 ifelse(Outlet_Size == "Medium", 1, 2))] 

combi[,Outlet_Location_Type_num := ifelse(Outlet_Location_Type == "Tier 3", 0, 
                                          ifelse(Outlet_Location_Type == "Tier 2", 1, 2))] 

# removing categorical variables after label encoding 

combi[, c("Outlet_Size", "Outlet_Location_Type") := NULL]



ohe <- caret::dummyVars("~.", data = combi[, -c("Item_Identifier", "Outlet_Establishment_Year", "Item_Type")], fullRank = T)
ohe_df <- data.table(predict(ohe, combi[, -c("Item_Identifier", "Outlet_Establishment_Year", "Item_Type")]))
combi <- cbind(combi[, "Item_Identifier"], ohe_df)