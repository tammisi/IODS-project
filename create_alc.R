# Silja Tammi
# 19.11.2023
# IODS exercises 3, data wrangling of student-mat.csv and student-por.csv to create 'alc' data set

# libraries
library(tidyverse)
library(dplyr)

# Read both student-mat.csv and student-por.csv into R (from the data folder) 
# and explore the structure and dimensions of the data.

math <- read.csv("./data/student+performance/student-mat.csv", sep=";")
por <- read.csv("./data/student+performance/student-por.csv", sep=";")
dim(math)
dim(por)
str(math)
str(por)

# Join the two data sets using all other variables than "failures", "paid", "absences", "G1", "G2", "G3"
# Keep only the students present in both data sets. Explore the structure and dimensions of the joined data.
free_cols <- c('failures', 'paid', 'absences', 'G1', 'G2', 'G3')
join_cols <- setdiff(colnames(por), free_cols)
math_por <- inner_join(math, por, by = join_cols, suffix = c(".math", ".por"))
dim(math_por) # 370 students in common between math and por, 39 variables
str(math_por)

# Get rid of the duplicate records in the joined data set. 
# Either a) copy the solution from the exercise "3.3 The if-else structure" to combine the 'duplicated' 
# answers in the joined data, or b) write your own solution to achieve this task.

# create a new data frame with only the joined columns
alc <- select(math_por, all_of(join_cols))

for(col_name in free_cols) {
  # select two columns from 'math_por' with the same original name
  two_cols <- select(math_por, starts_with(col_name))
  # select the first column vector of those two columns
  first_col <- select(two_cols, 1)[[1]]
  # if that first column vector is numeric...
  if(is.numeric(first_col)) {
    # take a rounded average of each row of the two columns and
    # add the resulting vector to the alc data frame
    alc[col_name] <- round(rowMeans(two_cols))
  } else { # else (if the first column vector was not numeric)...
    # add the first column vector to the alc data frame
    alc[col_name] <- first_col
  }
}

dim(alc)

# Take the average of the answers related to weekday and weekend alcohol consumption 
# to create a new column 'alc_use' to the joined data. Then use 'alc_use' to create a new logical column 
# 'high_use' which is TRUE for students for which 'alc_use' is greater than 2 (and FALSE otherwise)

# define new column alc_use by combining weekday and weekend alcohol use
alc <- mutate(alc, alc_use = (Dalc + Walc) / 2)

# define new column 'high_use'
alc <- mutate(alc, high_use = alc_use > 2)

# Glimpse at the joined and modified data to make sure everything is in order. 
# The joined data should now have 370 observations. Save the joined and modified data set to 
# the ‘data’ folder, using for example write_csv() function (readr package, part of tidyverse).

glimpse(alc)
write.csv(alc, "./data/alc.csv")

# test reading in data
alc <- read.csv("./data/alc.csv")
head(alc)
dim(alc)
