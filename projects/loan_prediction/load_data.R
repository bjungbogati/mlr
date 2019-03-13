
# load library

library(mlr)
# library(parallelMap)
# parallelStartSocket(4L)

train <- read.csv("./data/loan_prediction/train_loan.csv", na.strings = c(""," ",NA))
test <- read.csv("./data/loan_prediction/test_loan.csv", na.strings = c(""," ",NA))

# explore data

summarizeColumns(train)

# histogram
hist(train$ApplicantIncome, breaks = 300, main = "Applicant Income Chart",xlab = "ApplicantIncome")
hist(train$CoapplicantIncome, breaks = 100, main = "Coapplicant Income Chart",xlab = "CoapplicantIncome")

# Change to factor

str(train)
str(test)

# factorize categorical values

train$Credit_History <- as.factor(train$Credit_History)
test$Credit_History <- as.factor(test$Credit_History)

class(train$Credit_History) 

## Summarize

summary(train)
summary(test)

# rename level of Dependents

levels(train$Dependents)[4] <- "3"
levels(test$Dependents)[4] <- "3"


# Missing value imputation

imp <- impute(train, classes = list(factor = imputeMode(), 
                                    integer = imputeMean()), 
              dummy.classes = c("integer","factor"), 
              dummy.type = "numeric")

imp1 <- impute(test, classes = list(factor = imputeMode(), 
                                    integer = imputeMean()), 
               dummy.classes = c("integer","factor"), 
               dummy.type = "numeric")

imp_train <- imp$data
imp_test <- imp1$data


summarizeColumns(imp_train)
summarizeColumns(imp_test)

listLearners("classif", check.packages = TRUE, properties = "missings")[c("class","package")]


rpart_imp <- impute(train, target = "Loan_Status",
                    classes = list(numeric = imputeLearner(makeLearner("regr.rpart")),
                                   factor = imputeLearner(makeLearner("classif.rpart"))),
                    dummy.classes = c("numeric","factor"),
                    dummy.type = "numeric")


# 4. Feature Engineering

# remove outliers

cd <- capLargeValues(imp_train, target = "Loan_status", 
                     cols = c("ApplicantIncome"), 
                     threshold = 40000)

cd <- capLargeValues(cd, target = "Loan_Status", 
                     cols = c("CoapplicantIncome"), 
                     threshold = 21000)

cd <- capLargeValues(cd, target = "Loan_Status", 
                     cols = c("LoanAmount"), 
                     threshold = 520)


# rename the train data

cd_train <- cd

#add a dummy Loan_Status column in test data
imp_test$Loan_Status <- sample(0:1,size = 367,replace = T)

cde <- capLargeValues(imp_test, target = "Loan_Status",cols = c("ApplicantIncome"),threshold = 33000)
cde <- capLargeValues(cde, target = "Loan_Status",cols = c("CoapplicantIncome"),threshold = 16000)
cde <- capLargeValues(cde, target = "Loan_Status",cols = c("LoanAmount"),threshold = 470)

#renaming test data
cd_test <- cde

#convert numeric to factor - train
for (f in names(cd_train[, c(14:20)])) {
  if( class(cd_train[, c(14:20)] [[f]]) == "numeric"){
    levels <- unique(cd_train[, c(14:20)][[f]])
    cd_train[, c(14:20)][[f]] <- as.factor(factor(cd_train[, c(14:20)][[f]], levels = levels))
  }
}

#convert numeric to factor - test
for (f in names(cd_test[, c(13:18)])) {
  if( class(cd_test[, c(13:18)] [[f]]) == "numeric"){
    levels <- unique(cd_test[, c(13:18)][[f]])
    cd_test[, c(13:18)][[f]] <- as.factor(factor(cd_test[, c(13:18)][[f]], levels = levels))
  }
}


#Total_Income
cd_train$Total_Income <- cd_train$ApplicantIncome + cd_train$CoapplicantIncome
cd_test$Total_Income <- cd_test$ApplicantIncome + cd_test$CoapplicantIncome

#Income by loan
cd_train$Income_by_loan <- cd_train$Total_Income/cd_train$LoanAmount
cd_test$Income_by_loan <- cd_test$Total_Income/cd_test$LoanAmount

#change variable class
cd_train$Loan_Amount_Term <- as.numeric(cd_train$Loan_Amount_Term)
cd_test$Loan_Amount_Term <- as.numeric(cd_test$Loan_Amount_Term)

#Loan amount by term
cd_train$Loan_amount_by_term <- cd_train$LoanAmount/cd_train$Loan_Amount_Term
cd_test$Loan_amount_by_term <- cd_test$LoanAmount/cd_test$Loan_Amount_Term


#splitting the data based on class
az <- split(names(cd_train), sapply(cd_train, function(x){ class(x)}))

#creating a data frame of numeric variables
xs <- cd_train[az$numeric]

#check correlation
cor(xs)

cd_train$Total_Income <- NULL
cd_test$Total_Income <- NULL

summarizeColumns(cd_train)
summarizeColumns(cd_test)

#create a task
trainTask <- makeClassifTask(data = cd_train,target = "Loan_Status")
testTask <- makeClassifTask(data = cd_test, target = "Loan_Status")

trainTask <- makeClassifTask(data = cd_train,target = "Loan_Status", positive = "Y")



# normalize the variables

trainTask <- normalizeFeatures(trainTask, method = "standardize")
testTask <- normalizeFeatures(testTask, method = "standardize")

trainTask <- dropFeatures(task = trainTask, features = c("Loan_ID","Married.dummy"))


# Feature Importance

im_feat <- generateFilterValuesData(trainTask, method = c("information.gain","chi.squared"))

plotFilterValues(im_feat,n.show = 20)


#to launch its shiny application
plotFilterValuesGGVIS(im_feat)






