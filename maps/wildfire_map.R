library(tidyverse)
library(leaflet)

fire <- sf::st_read(dsn = "data/wildfire/fhszssn/fhszs06_3.shp")

fire_map <- sf::st_transform(fire,"WGS84")

pal <- colorFactor("YlOrRd", domain = fire_map$HAZ_CODE, levels = 1:3)

f <- leaflet(fire_map) %>% 
  setView(-120, 37.4, 6) %>% 
  addProviderTiles(providers$CartoDB.VoyagerLabelsUnder) %>% 
  addPolygons(
    fillColor = ~pal(HAZ_CODE),
    weight = 0.01,
    opacity = 1,
    color = "NA",
    dashArray = "3",
    fillOpacity = 0.7
  ) 