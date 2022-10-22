library(tidyverse)
library(leaflet)

income_data <- sf::st_read(dsn = "income_distribution/income_distribution.shp")
income_map <- sf::st_transform(income_data, "WGS84")
m <- leaflet(income_map)

bins <- c(-Inf, 2.018e-05, 6.431e-05, 1.715e-04, 0.001, 0.002, Inf)
pal <- colorBin("YlOrRd", domain = income_map$pr__200, bins = bins)

labels <- sprintf(
  "<strong>%s</strong><br/>$%g <sup>2</sup>",
  income_map$NAME, income_map$pr__200
) %>% lapply(htmltools::HTML)

m %>% addPolygons(
  fillColor = ~pal(pr__200),
  weight = 2,
  opacity = 1,
  color = NA,
  dashArray = "3",
  fillOpacity = 0.7,
  highlightOptions = highlightOptions(
    weight = 1,
    color = "#666",
    dashArray = "",
    fillOpacity = 0.7,
    bringToFront = TRUE),
  label = labels,
  labelOptions = labelOptions(
    style = list("font-weight" = "normal", padding = "3px 8px"),
    textsize = "15px",
    direction = "auto"))
