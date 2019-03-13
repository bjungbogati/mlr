source("./projects/hr_analytics/load_data.R")

## 1. Summary and test
summary(test.hr)
summary(train.hr)

dim(test.hr)
dim(train.hr)

colnames(train.hr)

## viz

ggplot(train.hr) +
  geom_bar(aes(x = is_promoted))


## Multivariate analysis

ggplot()