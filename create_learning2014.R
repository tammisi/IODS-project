# Silja Tammi
# 8.11.2023
# Exercises 2 data wrangling

lrn14 <- read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

dim(lrn14) 
str(lrn14)

# dimensions are 183 rows and 64 columns
# There are variables such as `Attitude` and `gender`, but also many variables whose name doesn't 
# make much sense

# Create an analysis dataset with the variables gender, age, attitude, deep, stra, surf and points 
# by combining questions in the learning2014 data and scale all combination variables to the original 
# scales (by taking the mean)
# attitude
lrn14$attitude <- lrn14$Attitude / 10
# deep
deep_questions <- c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30","D06",  "D15", "D23", "D31")
deep_columns <- select(lrn14, one_of(deep_questions))
lrn14$deep <- rowMeans(deep_columns)
# surf
surface_questions <- c("SU02","SU10","SU18","SU26", "SU05","SU13","SU21","SU29","SU08","SU16","SU24","SU32")
surface_columns <- select(lrn14, one_of(surface_questions))
lrn14$surf <- rowMeans(surface_columns)
# stra
strategic_questions <- c("ST01","ST09","ST17","ST25","ST04","ST12","ST20","ST28")
strategic_columns <- select(lrn14, one_of(strategic_questions))
lrn14$stra <- rowMeans(strategic_columns)
# points
lrn14 <- lrn14 %>% mutate(points = Points, age = Age)

# extract columns to create analysis data set
keep_columns <- c("gender","age","attitude", "deep", "stra", "surf", "points")
learning2014 <- lrn14 %>% select(one_of(keep_columns))

# Exclude observations where the exam points variable is zero
learning2014 <- learning2014 %>% filter(points>0)
dim(learning2014) # dim now 166 X 7, so should be ok

# Save the analysis dataset to the ‘data’ folder
library(readr)
write_csv(learning2014, ./data/"learning2014.csv") 

# Demonstrate that you can also read the data again by using read_csv() 
test <- read_csv("learning2014.csv")

# Use `str()` and `head()` to make sure that the structure of the data is correct
str(test)
head(test)
