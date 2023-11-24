# Silja Tammi
# 24.11.2023
# IODS Chapter 4,  data wrangling

library(readr)

# Read in the “Human development” and “Gender inequality” data sets 
hd <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/human_development.csv")
gii <- read_csv("https://raw.githubusercontent.com/KimmoVehkalahti/Helsinki-Open-Data-Science/master/datasets/gender_inequality.csv", na = "..")

# Explore the datasets: see the structure and dimensions of the data. Create summaries of the variables.
dim(hd)
str(hd)
dim(gii)
str(gii)

summary(hd$`HDI Rank`)
summary(hd$`Human Development Index (HDI)`)
summary(hd$`Life Expectancy at Birth`)

summary(gii$`GII Rank`)
summary(gii$`Gender Inequality Index (GII)`)
summary(gii$`Maternal Mortality Ratio`)

#rename the variables with (shorter) descriptive names.
colnames(hd) <- c("HDI_rank", "Country", "HDI_index", "Life_exp", "Edu_years", "Edu_years_mean", 
                  "GNI", "GNI_rank_minus_HDI_rank")
colnames(gii) <- c("GII_rank", "Country", "GII_index", "Mat_mort", "Adol_birth_rate", "Rep_parl", "Sec_edu_f", "Sec_edu_m",
                   "LFPR_f", "LFPR_m")

# Mutate the “Gender inequality” data and create two new variables. 
# The first new variable should be the ratio of female and male populations with secondary education 
# in each country (i.e., Edu2.F / Edu2.M). 
# The second new variable should be the ratio of labor force participation of females and males 
# in each country 

gii$Sec_edu_ratio <- gii$Sec_edu_f / gii$Sec_edu_m
gii$LFPR_ratio <- gii$LFPR_f / gii$LFPR_m
head(gii)

# join together the two datasets using the variable Country as the identifier. 
# Keep only the countries in both data sets. 
# The joined data should have 195 observations and 19 variables. 
# Call the new joined data "human" and save it in your data folder 
# (use write_csv() function from the readr package).

human <- inner_join(hd, gii, by="Country")
dim(human)
head(human)

# looks ok, so let's save
write_csv(human, "./data/human.csv")

# check by reading in
human <- read_csv("./data/human.csv")
dim(human)
head(human)
