# .rs.restartR()

source("./projects/hr_analytics/load_data.R")
set.seed(2019)

## adding symbol for test data
test.hr$is_promoted <- 2

# combine data sets
comb.hr <- rbind(train.hr, test.hr)

# View(comb.hr)

# remove train/test data
rm(test.hr, train.hr)


# check na
sum(is.na(comb.hr))

# separate column is_promoted
is_prom <- comb.hr$is_promoted

# delete unnecessary cols

names(comb.hr)

# id <- comb.hr$employee_id

comb.hr$employee_id <- NULL
comb.hr$is_promoted <- NULL

# character to factor

comb.hr$department <- as.factor(comb.hr$department)
comb.hr$region <- as.factor(comb.hr$region)
comb.hr$education <- as.factor(comb.hr$education)
comb.hr$gender <- as.factor(comb.hr$gender)
comb.hr$recruitment_channel <- as.factor(comb.hr$recruitment_channel)
comb.hr$previous_year_rating <- as.factor(comb.hr$previous_year_rating)

# 
# View(comb.hr)

class(comb.hr$previous_year_rating)

# View(comb.hr$previous_year_rating)

## imputation

comb.hr <- impute(comb.hr, classes = list(integer = imputeMean(), 
                                    factor = imputeMode(), 
                                    character = imputeMode()))

# sum(is.na(comb.hr$data))
comb.hr <- comb.hr$data

#adding back promoted
comb.hr$is_promoted <- is_prom

# View(comb.hr)

# converting factor to numeric

comb.hr$department <- as.numeric(comb.hr$department)
comb.hr$region <- as.numeric(comb.hr$region)
comb.hr$education <- as.numeric(comb.hr$education)
comb.hr$gender <- as.numeric(comb.hr$gender)
comb.hr$recruitment_channel <- as.numeric(comb.hr$recruitment_channel)
comb.hr$previous_year_rating <- as.numeric(comb.hr$previous_year_rating)
comb.hr$is_promoted <- as.factor(comb.hr$is_promoted)


sum(is.na(comb.hr))
# 
# str(comb.hr)

# split data

# clean.test.hr <- comb.hr %>% filter(is_promoted == 3) %>% select(-is_promoted)
# clean.train.hr <- comb.hr %>% filter(is_promoted != 3)


comb.hr = normalizeFeatures(comb.hr, method = "range")

ind = makeFixedHoldoutInstance(train.inds = 1:54808, test.inds = 54809:78298, size = 78298)

# ind = makeResampleInstance("Holdout", tsk)

tsk = makeClassifTask(data = comb.hr, target = "is_promoted")

tsk.test = subsetTask(tsk, ind$test.inds[[1]])
tsk.train = subsetTask(tsk, ind$train.inds[[1]])

# tsk.test$env$data$is_promoted <- NA


write_csv(tsk.test$env$data, "./data/hr_analytics/clean/clean_test_hra.csv")
write_csv(tsk.train$env$data, "./data/hr_analytics/clean/clean_train_hra.csv")

# comb.hr <- NULL
# is_prom <- NULL

# rm(is_prom, comb.hr)

# View(clean.test.hr)
# 
# View(tsk.train$env$data)

# tsk.train$env$data %>% filter(is_promoted == "test")
