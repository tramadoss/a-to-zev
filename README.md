# a-to-zev
Analysis of Prop 30 for the UC Davis CA Election 2022 Data Challenge

## Motivation

## Data Visualization Tool

https://tramadoss.github.io/a-to-zev/

## Definitions and Data Sources

### 
[American Community Survey 2015-2019 5 year estimate](https://www.census.gov/programs-surveys/acs)

California Franchise Tax Board [2020 Personal Income Tax Annual Report](https://data.ftb.ca.gov)

Alternative Fuels Data Center [Electric Vehicle Charging Station Locations](https://afdc.energy.gov) filtered for publicly-accessible DCFC, non-Tesla chargers only 

California Energy Commission [California Electric Substations](https://data.ca.gov/dataset/california-electric-substations1)

National Association of Realtors [County Median Home Prices](https://www.nar.realtor/research-and-statistics/housing-statistics/county-median-home-prices-and-monthly-mortgage-payment)

Institute of Museum and Library Services[Museums Data File](https://www.imls.gov/research-evaluation/data-collection/museum-data-files)

## Data Collection

ACS data was accessed through the R package tidycensus. All data was accessed between 10/20/2022 - 10/23/2022

## Data Processing

The full data processing steps can be found [here]().

## Repo Architecture

/index.html launches the interactive webapp

/maps stores all the scripts used to generate the interactive maps

/data stores all the data sources

/scripts stores the scripts used for processing the raw data and producing shapefiles for the map files

## Contributors

Jean Ji, Ph.D. Candidate, Energy Systems, Electric Vehicle Research Center, UC Davis 

Tisura Gamage, Ph.D. Student, Transportation Technology and Policy, Electric Vehicle Research Center, UC Davis

Trisha Ramadoss, Ph.D. Student, Transportation Technology and Policy, Electric Vehicle Research Center, UC Davis


## Helpful Resource to Create Visualizations in R
https://rstudio.github.io/leaflet/markers.html
