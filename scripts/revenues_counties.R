#Name: Jean Y. Ji
#Date: October 19, 2022
#Summary: This script is used to process income tax data from the California Franchise Tax Board, median home price data,
#and number of museums per county in order to determine a few key metrics in understanding what counties millionaires are likely to reside in. The key metrics that we are
#interested in at the county level are tax assessed per capita, median home price, and number of museums per square mile

#load in packages
library(dplyr)

#read in California Franchise Tax Board data
tax_data <- read.csv("C:/Users/jeany/Desktop/CA_FTB_TableB6.csv")
colnames(tax_data)[1] = "county"

#compute the first key metric: tax assessed per capita
tax_data <- mutate(tax_data, tax_assessed_per_capita = Tax.Assessed/Population)

#read in California median home price by county 
home_price_data <- read.csv("C:/Users/jeany/Desktop/CA_median_home_price_county.csv")

#read in museums data
museums_us <- read.csv("C:/Users/jeany/Desktop/museums_in_US.csv")

#read in area data
area_county <- read.csv("C:/Users/jeany/Desktop/CA_county_area.csv")

#rename a variable
colnames(area_county)[1] = "area"

#filter for museums in California based on the FIPS codes
museums_ca <- filter(museums_us, FIPSST == 6)

#add a new variable to help summarize the number of museums per county
museums_ca <- mutate(museums_ca, count = 1)

#group museums by county and summarize the number of museums by county
summary_museums_county <- museums_ca %>%
  group_by(FIPSCO)%>%
  summarise(num_museums = sum(count))

#remove the row with missing county information
summary_museums_county <- filter(summary_museums_county, FIPSCO != "NA")

#rename a column
colnames(summary_museums_county)[1] = "FIPS"

#read in data set on CA county and FIPS
county_fips <- read.csv("C:/Users/jeany/Desktop/CA_county_fips.csv")
colnames(county_fips)[1] = "county"

#merge summary of museums per county with the county name data set
summary_museums_county <- left_join(summary_museums_county, county_fips)

#merge summary of museums per county with area data 
summary_museums_county <- left_join(summary_museums_county, area_county)

#compute the number of museums per square mile
summary_museums_county <- mutate(summary_museums_county, num_museums_per_mile = num_museums/area)

#rank the counties by the ones with the largest number of museums to the smallest number of museums
summary_museums_county <- arrange(summary_museums_county, desc(num_museums_per_mile))
