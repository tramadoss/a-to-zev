library(tidyverse)
library(leaflet)

income_data <- sf::st_read(dsn = "income_distribution/income_distribution.shp")

new_vars <- income_data %>% sf::st_drop_geometry() %>% 
  mutate(nickname = substr(NAME, 8, (nchar(NAME) -12))) %>% 
  mutate(taxable_millionaires = ovr_200 * 0.02472) %>% ## % of people who make over 200k who make over 2m
  mutate(revenue = pr__200 * 2885050875) %>% 
  mutate(revenue_label = case_when(
    revenue < 1000 ~"< $1k",
    revenue > 1000000 ~ paste0("$",round(revenue/1000000,1) %>% as.character(), "m"),
    revenue < 10000 ~ paste0("$",round(revenue/1000,1) %>% as.character(), "k"),
    TRUE ~ paste0("$",round(revenue/1000) %>% as.character(), "k")
  ))
  
income_map <- sf::st_transform(income_data, "WGS84") %>% 
  inner_join(new_vars)

bins <- c(0, 1, 20, 40, 60, 120)
pal <- colorBin("YlOrRd", domain = income_map$taxable_millionaires, bins = bins)

labels <- sprintf(
  "<strong>%s</strong><br/>%s <br/>%g millionaires",
  income_map$nickname, income_map$revenue_label , round(income_map$taxable_millionaires,1)
) %>% lapply(htmltools::HTML)

m <- leaflet(income_map) %>% 
  setView(-122.3, 37.8, 9) %>% 
  #addTiles() %>%
  addProviderTiles(providers$CartoDB.PositronOnlyLabels) %>% 
  addPolygons(
  fillColor = ~pal(taxable_millionaires),
  weight = 0.01,
  opacity = 1,
  color = "NA",
  dashArray = "3",
  fillOpacity = 0.7,
  highlightOptions = highlightOptions(
    weight = 0.5,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    #textsize = "12px",
    direction = "auto")) %>% 
  addLegend(pal = pal, values = ~taxable_millionaires, opacity = 0.7, title = NULL,
            position = "bottomright")
m
