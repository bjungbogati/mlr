source("load_data.R")

# Exploratory Data Analysis

# Target variable

ggplot(train) + 
  geom_histogram(aes(train$Item_Outlet_Sales), 
                     binwidth = 100, fill = "darkgreen") +
  xlab("Item_Outlet_Sales")


# Independent Variables (numeric variables)

p1 <- ggplot(combi) +
  geom_histogram(aes(Item_Weight), binwidth = 0.5, 
                 fill = "blue")

p2 <- ggplot(combi) +
  geom_histogram(aes(Item_Visibility), binwidth = 0.005, 
                 fill = "blue")

p3 <- ggplot(combi) + 
  geom_histogram(aes(Item_MRP), binwidth = 1, fill = "blue")

plot_grid(p1, p2, p3, nrow = 1)

# Independent Variables (Categorical variables)

p <- ggplot(combi %>%  group_by(Item_Fat_Content) %>% summarise(Count = n())) +
  geom_bar(aes(Item_Fat_Content, Count), stat = "identity", fill = "coral1")


combi$Item_Fat_Content[combi$Item_Fat_Content == "LF"] = "Low Fat"
combi$Item_Fat_Content[combi$Item_Fat_Content == "low fat"] = "Low Fat"
combi$Item_Fat_Content[combi$Item_Fat_Content == "reg"] = "Regular"

p

## Categorical variables

p4 <- ggplot(combi %>% group_by(Item_Type) %>% 
               summarise(Count = n())) + 
  geom_bar(aes(Item_Type, Count), stat = "identity", 
           fill = "coral1") + xlab("") +
  geom_label(aes(Item_Type, Count, label = Count), 
             vjust = 0.5) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Item_Type")

p5 <- ggplot(combi %>% group_by(Outlet_Identifier) %>% 
               summarise(Count = n())) + 
  geom_bar(aes(Outlet_Identifier, Count), stat = "identity", 
           fill = "coral1") + xlab("") +
  geom_label(aes(Outlet_Identifier, Count, label = Count), 
             vjust = 0.5) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Outlet_Identifier")

p6 <- ggplot(combi %>% group_by(Outlet_Size) %>% 
               summarise(Count = n())) + 
  geom_bar(aes(Outlet_Size, Count), stat = "identity", 
           fill = "coral1") + xlab("") +
  geom_label(aes(Outlet_Size, Count, label = Count), 
             vjust = 0.5) + 
  theme(axis.text.x = element_text(angle = 45, hjust = 1)) +
  ggtitle("Outlet_Size")

second_row <- plot_grid(p5, p6, nrow = 1)


plot_grid(p4, second_row, ncol = 1)


## plot for Outlet_Establishment_Year

p7 <- ggplot(combi %>% group_by(Outlet_Establishment_Year) %>% 
               summarise(Count = n())) +
  geom_bar(aes(factor(Outlet_Establishment_Year), Count), 
           stat = "identity", fill = "coral1") +
  geom_label(aes(factor(Outlet_Establishment_Year), Count, 
                 label = Count), vjust = 0.5) +
  xlab("Outlet_Establishment_Year") +
  theme(axis.text.x = element_text(size = 8.5))

p8 <- ggplot(combi %>% group_by(Outlet_Type) %>% 
               summarise(Count = n())) +
  geom_bar(aes(Outlet_Type, Count), stat = "identity", 
           fill = "coral1") +
  geom_label(aes(factor(Outlet_Type), Count, label= Count), 
             vjust = 0.5) + 
  theme(axis.text.x = element_text(size = 8.5))

# plotting together

plot_grid(p7, p8, ncol = 2)


## Bivariate Analysis
train <- combi[1:nrow(train)]

# Target Variable vs Independent Numerical Variables


p9 <- ggplot(train) +
  geom_point(aes(Item_Weight, Item_Outlet_Sales), colour = "violet", 
             alpha = 0.3) +
  theme(axis.title = element_text(size = 8.5))


p10 <- ggplot(train) +
  geom_point(aes(Item_Visibility, Item_Outlet_Sales), colour = "violet", 
             alpha = 0.3) +
  theme(axis.title = element_text(size = 0.5))


p11 <- ggplot(train) +
  geom_point(aes(Item_MRP, Item_Outlet_Sales), colour = "violet", alpha = 0.3) +
  theme(axis.title = element_text(size = 8.5))


second_row_2 <- plot_grid(p10, p11, ncol = 2)

plot_grid(p9, second_row_2, nrow = 2)


## Target Variable vs Independent Categorical Variables

p12 <- ggplot(train) +
  geom_violin(aes(Item_Type, Item_Outlet_Sales), fill = "magenta") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        axis.text = element_text(size = 6), axis.title = element_text(size = 8.5))

p13 <- ggplot(train) +
  geom_violin(aes(Item_Fat_Content, Item_Outlet_Sales), fill = "magenta") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), 
        axis.text = element_text(size = 8), 
        axis.title = element_text(size = 8.5))

p14 <- ggplot(train) +
  geom_violin(aes(Outlet_Identifier, Item_Outlet_Sales), fill = "magenta") +
  theme(axis.text.x = element_text(angle = 45, hjust = 1), axis.text = element_text(size = 8), 
        axis.title = element_text(size = 8.5))

second_row_3 <- plot_grid(p13, p14, ncol = 2)

plot_grid(p12, second_row_3, ncol = 1)


ggplot(train) +
  geom_violin(aes(Outlet_Size, Item_Outlet_Sales), fill = "magenta")


p15 <- ggplot(train) +
  geom_violin(aes(Outlet_Location_Type, Item_Outlet_Sales), 
              fill = "magenta")

p16 <- ggplot(train) +
  geom_violin(aes(Outlet_Type, Item_Outlet_Sales), fill = "magenta")

plot_grid(p15, p16, ncol = 1)
