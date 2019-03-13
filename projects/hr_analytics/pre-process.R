
source("./projects/hr_analytics/load_data.R")
set.seed(2019)

# 
# remove <- c("ID", "X0", "X1", "X2", "X3", "X4", "X5", "X6", "X8")
# 
# train <- train[, setdiff(names(train), remove)]


# separate column is_promoted
is_prom <- train.hr$is_promoted
test_emp_id <- test.hr$is_promoted

train.hr$employee_id <- NULL
train.hr$is_promoted <- NULL
test.hr$employee_id <- NULL


# converting into factor

train.hr$department <- as.factor(train.hr$department)
train.hr$region <- as.factor(train.hr$region)
train.hr$education <- as.factor(train.hr$education)
train.hr$gender <- as.factor(train.hr$gender)
train.hr$recruitment_channel <- as.factor(train.hr$recruitment_channel)
train.hr$previous_year_rating <- as.factor(train.hr$previous_year_rating)

test.hr$department <- as.factor(test.hr$department)
test.hr$region <- as.factor(test.hr$region)
test.hr$education <- as.factor(test.hr$education)
test.hr$gender <- as.factor(test.hr$gender)
test.hr$recruitment_channel <- as.factor(test.hr$recruitment_channel)
test.hr$previous_year_rating <- as.factor(test.hr$previous_year_rating)


# normalize features 
train.hr = normalizeFeatures(train.hr, method = "range")
test.hr = normalizeFeatures(test.hr, method = "range")

# renaming columns

names(train.hr) <- c("department","region","education","gender","recruitment_channel","no_of_trainings","age",
"previous_year_rating","length_of_service","KPIs_met","awards_won","avg_training_score")

names(test.hr) <- c("department","region","education","gender","recruitment_channel","no_of_trainings","age",
                                       "previous_year_rating","length_of_service","KPIs_met","awards_won","avg_training_score")

## imputation

train.hr <- impute(train.hr, classes = list(integer = imputeMean(), 
                                            factor = imputeMode(), 
                                            character = imputeMode()))
train.hr <- train.hr$data

test.hr <- impute(test.hr, classes = list(integer = imputeMean(), 
                                            factor = imputeMode(), 
                                            character = imputeMode()))
test.hr <- test.hr$data


#adding back promoted
train.hr$is_promoted <- is_prom
test.hr$is_promoted <- 0


# converting factor to numeric

train.hr$department <- as.numeric(train.hr$department)
train.hr$region <- as.numeric(train.hr$region)
train.hr$education <- as.numeric(train.hr$education)
train.hr$gender <- as.numeric(train.hr$gender)
train.hr$recruitment_channel <- as.numeric(train.hr$recruitment_channel)
train.hr$previous_year_rating <- as.numeric(train.hr$previous_year_rating)
train.hr$is_promoted <- as.factor(train.hr$is_promoted)

test.hr$department <- as.numeric(test.hr$department)
test.hr$region <- as.numeric(test.hr$region)
test.hr$education <- as.numeric(test.hr$education)
test.hr$gender <- as.numeric(test.hr$gender)
test.hr$recruitment_channel <- as.numeric(test.hr$recruitment_channel)
test.hr$previous_year_rating <- as.numeric(test.hr$previous_year_rating)
test.hr$is_promoted <- as.factor(test.hr$is_promoted)

sum(is.na(train.hr))
sum(is.na(test.hr))

tsk.train = makeClassifTask(data = train.hr, target = "is_promoted")

tsk.test = makeClassifTask(data = test.hr, target = "is_promoted")

class(tsk.train)
class(tsk.test)