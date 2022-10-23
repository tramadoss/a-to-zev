library(tidycensus)
library(tidyverse)

#acs_api_key <- "36bc9f2942111b56a8e1c8255e554dc53f79aca3"
#census_api_key(acs_api_key, install = TRUE)
cached_acs5 <- load_variables(2019, 'acs5', cache = TRUE)

income <- get_acs(state = "CA"
                  ,geography = "tract"
                  ,year = 2019
                  #,table = "B19001"
                  ,variables = c("B19001_001","B19001_017","B19013_001") ##total, over 200k, median
                  ,geometry = TRUE
)

income_vars <- income %>% 
  inner_join(cached_acs5, by = c("variable"="name")) %>% 
  inner_join(tibble(
    variable = c("B19001_001","B19001_017","B19013_001"),
    type = c("total","over_200", "median_income")
  )) %>% 
  #select(-variable, label, concept) %>% 
  sf::st_drop_geometry() %>% 
  pivot_wider(id = c(GEOID, NAME), values_from = estimate, names_from = type) %>% 
  mutate(percent_of_tract = over_200 / total) %>% 
  mutate(percent_of_200s = over_200 / sum(over_200)) %>% 
  inner_join(income  %>% filter(variable == "B19001_001") %>% select(GEOID),.)
  
#sf::st_write(income_vars, "data/income_distribution/income_distribution.shp")
