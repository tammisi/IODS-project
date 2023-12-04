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

# ................................................................................................ #

# continue (Assignment 5 Data Wrangling)

human <- read.csv("./data/human.csv")
dim(human)
str(human)
# the data has 195 study subjects and 19 variables:

# The data combines several indicators from most countries in the world

# "Country" = Country name

# Health and knowledge

# "GNI" = Gross National Income per capita
# "Life.Exp" = Life expectancy at birth ('Life_exp' in my data)
# "Edu.Exp" = Expected years of schooling  ('Edu_years')
# "Mat.Mor" = Maternal mortality ratio ('Mat_mort')
# "Ado.Birth" = Adolescent birth rate ('Adol_birth_rate')

# Empowerment

# "Parli.F" = Percetange of female representatives in parliament ('Rep_parl')
# "Edu2.F" = Proportion of females with at least secondary education ('Sec_edu_f')
# "Edu2.M" = Proportion of males with at least secondary education ('Sec_edu_m')
# "Labo.F" = Proportion of females in the labour force ('LFPR_f')
# "Labo.M" " Proportion of males in the labour force ('LFPR_m')

# "Edu2.FM" = Edu2.F / Edu2.M ('Sec_edu_ratio')
# "Labo.FM" = Labo2.F / Labo2.M ('LFPR_ratio')

# The columns in my data are named a little differently (my names in parenthesis)

# Exclude unneeded variables: keep only the columns matching the following variable names 
# (described in the meta file above):  "Country", "Edu2.FM", "Labo.FM", "Edu.Exp", "Life.Exp", "GNI", 
# "Mat.Mor", "Ado.Birth", "Parli.F"

to_keep <- c('Country', 'Sec_edu_ratio', 'LFPR_ratio', 'Edu_years', 'Life_exp', 'GNI', 'Mat_mort',
             'Adol_birth_rate', 'Rep_parl')

human <- human %>% select(any_of(to_keep))
dim(human) # 9 columns left, so ok

# Remove all rows with missing values
human <- human %>% na.omit()
dim(human) # 162 rows out of original 195, so 33 rows removed

# Remove the observations which relate to regions instead of countries

unique(human$Country)
regions <- c('Arab States', 'East Asia and the Pacific', 'Europe and Central Asia', 
             'Latin America and the Caribbean', 'South Asia', 'Sub-Saharan Africa', 'World')

human <- human %>% filter(!Country %in% regions)
dim(human) # 155 rows left so 6 rows removed

# The data should now have 155 observations and 9 variables (including the "Country" variable). 
# Save the human data in your data folder. You can overwrite your old ‘human’ data.

write.csv(human, row.names = F, "./data/human.csv")
