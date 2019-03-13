source("load_iris.R")

head(iris)

iris.val <- iris %>% gather(Feature, Value, -Species)
ggplot(iris.val, aes(x = Value, fill = Species)) + 
  facet_wrap(~Feature, scales = "free_x") + 
  geom_histogram(bins = 30) 

ggplot(iris.val, aes(x = Species, y = Value, fill = Species)) +
  facet_wrap(~Feature) + 
  geom_violin()
# 
# ggplot(iris, aes(x = Petal.Length, y = Petal.Width, color = Species)) + geom_point()
# ggplot(iris, aes(x = Sepal.Length, y = Sepal.Width, color = Species)) + geom_point()

corrplot::corrplot(cor(iris[, -5]))


ggplot(iris, aes(x = Petal.Length, y = Petal.Width)) + geom_point()
