# feature engineering

source("./projects/iris/load_iris.R")
library("dplyr")

getFeatureImportance(rforest)

n <- data.frame(getFeatureImportance(rforest)$res)

n <- n %>% gather(feature, importance) %>% 
  arrange(desc(importance))

write.csv(n, "./projects/iris/features.csv")

n = read_csv("./projects/iris/features.csv")

ggplot(n, aes(x = feature, y = importance)) + geom_boxplot()




