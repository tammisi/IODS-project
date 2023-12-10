# Assignment 6 data wrangling
# Silja Tammi

# libraries
library(tidyverse)
library(dplyr)
library(tidyr)

# 1. Load the data sets (BPRS and RATS) into R 
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt",
                   header = T)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt",
                   header = T)

head(BPRS)
str(BPRS)
dim(BPRS)

head(RATS)
str(RATS)
dim(RATS)

# BPRS data:
# 40 male subjects randomly assigned to one of two treatment groups and each subject was rated
# on the brief psychiatric rating scale (BPRS) measured before treatment began (week 0) and then 
# at weekly intervals for eight weeks. The BPRS assesses the level of 18 symptom constructs such as 
# hostility, suspiciousness, hallucinations and grandiosity; each of these is rated from one 
# (not present) to seven (extremely severe). The scale is used to evaluate patients suspected of having
# schizophrenia.

# RATS data:
# data from a nutrition study conducted in three groups of rats (Crowder and Hand, 1990). 
# The three groups were put on different diets, and each animal’s body weight (grams) was recorded 
# repeatedly (approximately weekly, except in week seven when two recordings were taken) over a 9-week
# period. The question of most interest is whether the growth profiles of the three groups differ.


# 2. Convert the categorical variables of both data sets to factors
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

# 3. Convert the data sets to long form. Add a week variable to BPRS and a Time variable to RATS
BPRSL <-  pivot_longer(BPRS, cols = -c(treatment, subject),
                       names_to = "weeks", values_to = "bprs") %>%
  arrange(weeks) #order by weeks variable

RATSL <-  pivot_longer(RATS, cols = -c(ID, Group),
                       names_to = "WD", values_to = "Weight") %>%
  arrange(WD) #order by weeks variable

BPRSL <-  BPRSL %>% 
  mutate(week = as.integer(substr(weeks, 5,5)))

RATSL <- RATSL %>% 
  mutate(Time = as.integer(substr(WD, 3,4))) 

# 4. Now, take a serious look at the new data sets and compare them with their wide form versions: 
# Check the variable names, view the data contents and structures, and create some brief summaries 
# of the variables. Make sure that you understand the point of the long form data and the crucial 
# difference between the wide and the long forms before proceeding the to Analysis exercise.

names(BPRS) 
# "treatment" "subject"   "week0"     "week1"     "week2"     "week3"     "week4"     "week5"    "week6"     "week7"     "week8" 
names(BPRSL) 
# "treatment" "subject"   "weeks"     "bprs"      "week" 

dim(BPRS) # 40 X 11
dim(BPRSL) # 360 X 5

str(BPRS)
str(BPRSL)

summary(BPRS$week0)
summary(BPRSL$bprs)

names(RATS) 
# "ID"    "Group" "WD1"   "WD8"   "WD15"  "WD22"  "WD29"  "WD36"  "WD43"  "WD44"  "WD50"  "WD57"
names(RATSL)
# "ID"     "Group"  "WD"     "Weight" "Time"

dim(RATS) # 16 X 13
dim(RATSL) # 176 X 5

str(RATS)
str(RATSL)

summary(RATS$WD1)
summary(RATSL$Weight)

# In the wide format every measure that varies in time occupies a set of columns, whereas in the long 
# format there will be multiple records for each individual. Some variables that do not vary in time 
# (such as group or ID)are identical in each record, whereas other variables vary across the records
# In BPRS data, the psychiatric rating scales for tne 40 participants are combined into one variable 
# and the corresponding week is added as a new column. Similarly in RATS data, the weights measured 
# at different time points for each individual rat are combined into one column and the corresponding 
# time point or day is added as a new column. 

write.table(BPRSL, "./data/BPRSL.txt", row.names = F)
write.table(RATSL, "./data/RATSL.txt", row.names = F)
