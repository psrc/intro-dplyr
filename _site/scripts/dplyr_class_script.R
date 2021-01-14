library(dplyr)
library(stringr)
library(tidyr)
library(ggplot2)


#### Restaurant Inspection Data ####

restaurant_file<-'C:/Users/SChildress/Documents/GitHub/intro-dplyr/data/king_county_restaurant_inspections.csv'
rest_df<-read.csv(restaurant_file, fileEncoding = 'UTF-8-BOM')
# find the dimensions of the data frame
dim(rest_df)
#look at the first five rows
head(rest_df)
#what are the column names
colnames(rest_df)
glimpse(rest_df)


#### Basic dplyr verbs ####

# mutate() adds new variables that are functions of existing variables
# I'm going to add a new variable which is the year.
# Notice how I am using a %>% to use the mutate function on the rest_df.

rest_df <- rest_df %>% mutate('SEATTLE'= if_else(CITY=='Seattle', 'Seattle', 'Not Seattle'))

# select() picks variables based on their names.
less_columns_df <- rest_df %>% select('NAME', 'SEAT_CAP', 'VIOLATIONTYPE')
head(less_columns_df)

# filter() picks cases based on their values.
biz_df <- rest_df %>% dplyr::filter(str_detect(NAME, 'BIZ'))
bizzaro_df <- rest_df %>% dplyr::filter(str_detect(NAME, 'BIZZARRO'))
head(bizzaro_df)
# you can stack the two operations together; like nesting a function

less_col_biz <- rest_df %>% select('NAME', 'VIOLATIONTYPE', 'VIOLATIONDESCR') %>%  dplyr::filter(str_detect(NAME, 'BIZZARRO'))
head(less_col_biz)
# arrange() changes the ordering of the rows.
# the default is ascending order, if you want descending use: desc
ordered_df <- bizzaro_df%>% arrange(desc(SCORE_INSPECTION))
head(ordered_df)

#In class exercise 1: 
  
#Now it's your turn to try, try to filter a restaurant you know, 
#and select three columns you are interested in, then order descending by the inspection score.
  
#### Group by and Summarize ####

# Let's count the records in our data.

rest_df_count <- rest_df %>% count()
rest_df_count

# Now let's count the number of observations for each restaurant.

rest_df_count2 <- rest_df %>% count(NAME)
head(rest_df_count2)

rest_df_count_sort<-rest_df %>% count(NAME,sort=TRUE)
head(rest_df_count_sort)


#### Data Wrangling ####

# I want to find out the unique values of the type of inspections

unique(rest_df$TYPE_INSPECTION)

glimpse(rest_df)
# The DATE_INSPECTION FIELD is a factor, but we want it to be a date so we filter on it.

rest_df <- rest_df %>% mutate(DATE_INSP_FORMAT=as.Date(word(as.character(DATE_INSPECTION), 1)))

#let's check to see that now the DATE_INSP_FORMAT field looks like a date and is okay
glimpse(rest_df)

rest_df<-rest_df %>% dplyr::mutate(VIOLATIONPOINTS = replace_na(VIOLATIONPOINTS, 0))

rest_df_filtered <- rest_df %>% filter(TYPE_INSPECTION=='Routine Inspection/Field Review') %>%
  group_by(NAME) %>% 
  filter(DATE_INSP_FORMAT == max(DATE_INSP_FORMAT)) %>% 
  slice(which.max(VIOLATIONPOINTS))

#### Playing with the Data ####
glimpse(rest_df_filtered)

#How do the inspection scores vary by city?

# Average and Max Score by City
score_by_city<-rest_df_filtered %>% group_by(CITY) %>% summarize(avg_score= mean(SCORE_INSPECTION),
                                                                 max_score = max(SCORE_INSPECTION),
                                                                 n_rests = n())


score_by_city

# some of the cities have very few restaurants; let's remove those

score_city_sufficient <- score_by_city %>% filter(n_rests>50)

#dplyr works great with ggplot to make plots.  

ggplot(data=score_city_sufficient, aes(x=CITY, y=avg_score)) +
  geom_bar(stat="identity")+theme(axis.text.x = element_text(angle = 90))+
  ggtitle("Average Restaurant Inspection Score by City") +
  xlab("City") + ylab("Average Restaurant Score")

# does the average score just correlate with number of restaurants?
ggplot(data=score_city_sufficient, aes(x=n_rests, y=avg_score)) +
  geom_point()+ggtitle("Average Restaurant Inspection Score by Number of Restaurants") +
  xlab("Number of Restaurants") + ylab("Average Restaurant Score")

# Seattle throws everything off  
score_city_sufficient_not_too_many <- score_city_sufficient %>% filter(n_rests<100)
ggplot(data=score_city_sufficient_not_too_many, aes(x=n_rests, y=avg_score)) +
  geom_point()+ggtitle("Average Restaurant Inspection Score by Number of Restaurants") +
  xlab("Number of Restaurants") + ylab("Average Restaurant Score")


# What is the info on the restaurant with the worst score by city?

worst_by_city<-rest_df_filtered %>% group_by(CITY) %>% top_n(1, SCORE_INSPECTION)

worst_by_city
# What was the data on the restaurant I liked?

bizzaro_df_filtered <- rest_df_filtered %>% dplyr::filter(str_detect(NAME, 'BIZZARRO'))
bizzaro_df_filtered


############### Exercises ################
# 1. Find your a restaurant of your choice and get the latest data.
# 2. Go back to the big dataset and find the worst violation of a restaurant you want.
# 3. Make a table that shows grouped RISK category and the average and max SCORE_INSPECTION
# 4. Make a table that shows grouped SEAT_CAP and the average and max SCORE_INSPECTION
# 5. Find out which VIOLATIONDESCR is associated with the the highest SCORE_INSPECTION
# 6. Make a barplot that shows the maximum inspection score by city.



