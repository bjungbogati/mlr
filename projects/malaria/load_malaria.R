# 
# url <- "https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2018/2018-11-13/malaria_deaths_inc.csv"
# download.file(url, "./data/malaria/malaria_inc.csv")

library("readr")
library("dplyr")

d1 <- read_csv("./data/malaria/malaria_deaths.csv")
d2 <- read_csv("./data/malaria/malaria_deaths_age.csv")
d3 <- read_csv("./data/malaria/malaria_inc.csv")




