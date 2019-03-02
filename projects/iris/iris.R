# Load Your Data.
# Dimensions of Your Data
# Data Types
# Class Distribution
# Data Summary
# Standard Deviations
# Skewness
# Correlations


# load data
data(iris)

# view top 6 items
head(iris)

#structure 

str(iris)

# dimension
dim(iris)

# distrubute class variable

cbind(freq = table(iris$Species), percentage = prop.table(table(iris$Species))*100)

# summary
summary(iris)

# standard deviation

sapply(iris[,1:4], sd)

# skewness
library(moments)
apply(iris[, 1:4], 2, skewness)

# Correlation
cor(iris[, 1:4])

# ----------------------------------------------------------------------

# Visualize

# histograms
iris

library("ggplot2")

ggplot(iris, aes(x=Species)) +
  geom_histogram() +
  stat_bin() +
  facet_grid(~ Species)


#qplot(Sepal.Length, Petal.Length, data = iris, color = Species)




