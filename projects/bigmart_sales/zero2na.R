df <- data.frame(a=c(1,2,3,NA, NA, NA),b=c(200, 300, 400, 500, 0, 0))


df$a <- as.integer(df$a)
df$b <- as.integer(df$b)

n <- impute(df, classes = list(integer = imputeMean(), 
                                      factor = imputeMode()), 
                # cols = list(b = imputeMean()), 
                dummy.classes = "integer"
)

df[df == 0] <- NA


class(df$a)

n <- n$data

str(n)
