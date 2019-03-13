
library(data.table)
library(here)


# load data 

train <- fread(here("data", "black_friday", "train_bf.csv"), stringsAsFactors = T)
test <- fread(here("data", "black_friday", "test_bf.csv"), stringsAsFactors = T)

# dimensions

dim(train)
dim(test)

str(train)
str(test)

names(train)
names(test)

# first prediction using mean

sub_mean <- data.frame(User_ID = test$User_ID, 
                       Product_ID = test$Product_ID, 
                       Purchase = mean(train$Purchase))


summary(train)
summary(test)


# combine data set

test[, Purchase := mean(train$Purchase)]
c <- list(train, test)
combin <- rbindlist(c)

# remove train test
train <- nrow(train)
test <- NULL

# train <- test <- NULL 


# Data Exploration

names(combin)
dim(combin)

# View(combin)

# analyzing gender variable

combin[, prop.table(table(Gender))]

# Age variable

combin[, prop.table(table(Age))]


# City wise variable

combin[, prop.table(table(City_Category))]


#City Category Variable
combin[,prop.table(table(Stay_In_Current_City_Years))]

#unique values in ID variables
length(unique(combin$Product_ID))

length(unique(combin$User_ID))

#missing values
colSums(is.na(combin))

library(ggplot2)

#Age vs Gender
ggplot(combin, aes(Age, fill = Gender)) + geom_bar()

#Age vs City_Category
ggplot(combin, aes(Age, fill = City_Category)) + geom_bar()


library(gmodels)
CrossTable(combin$Occupation, combin$City_Category)


#create a new variable for missing values

combin[,Product_Category_2_NA := ifelse(sapply(combin$Product_Category_2, is.na) ==    TRUE,1,0)]
combin[,Product_Category_3_NA := ifelse(sapply(combin$Product_Category_3, is.na) ==  TRUE,1,0)]

#impute missing values
combin[,Product_Category_2 := ifelse(is.na(Product_Category_2) == TRUE, "-999",  Product_Category_2)]
combin[,Product_Category_3 := ifelse(is.na(Product_Category_3) == TRUE, "-999",  Product_Category_3)]

#set column level
levels(combin$Stay_In_Current_City_Years)[levels(combin$Stay_In_Current_City_Years) ==  "4+"] <- "4"

#recoding age groups
levels(combin$Age)[levels(combin$Age) == "0-17"] <- 0
levels(combin$Age)[levels(combin$Age) == "18-25"] <- 1
levels(combin$Age)[levels(combin$Age) == "26-35"] <- 2
levels(combin$Age)[levels(combin$Age) == "36-45"] <- 3
levels(combin$Age)[levels(combin$Age) == "46-50"] <- 4
levels(combin$Age)[levels(combin$Age) == "51-55"] <- 5
levels(combin$Age)[levels(combin$Age) == "55+"] <- 6

#convert age to numeric
combin$Age <- as.numeric(combin$Age)


#convert Gender into numeric
combin[, Gender := as.numeric(as.factor(Gender)) - 1]

#convert age to numeric
combin$Age <- as.numeric(combin$Age)

#convert Gender into numeric
combin[, Gender := as.numeric(as.factor(Gender)) - 1]

#User Count
combin[, User_Count := .N, by = User_ID]

#Product Count
combin[, Product_Count := .N, by = Product_ID]


#Mean Purchase of Product
combin[, Mean_Purchase_Product := mean(Purchase), by = Product_ID]

#Mean Purchase of User
combin[, Mean_Purchase_User := mean(Purchase), by = User_ID]


library(dummies)
combin <- dummy.data.frame(combin, names = c("City_Category"), sep = "_")

#converting Product Category 2 & 3
combin$Product_Category_2 <- as.integer(combin$Product_Category_2)
combin$Product_Category_3 <- as.integer(combin$Product_Category_3)

#Divide into train and test
c.train <- combin[1:train,]
c.test <- combin[-(1:train),]

combin <- NULL


# fwrite(c.train, file = here("data", "black_friday", "c_train.csv"))
# fwrite(c.test, file = here("data", "black_friday", "c_test.csv"))

saveRDS(c.train, here("data", "black_friday", "c_train.RDS"))
saveRDS(c.test, here("data", "black_friday", "c_test.Rds"))

