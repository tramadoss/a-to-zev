library(sf)
library(readr)
library(leaflet)

## Shapefiles
roads <- st_read(file.path("data/charging/Shape_file","shn2014v3_Segments.shp")) %>% st_transform("WGS84")
Counties <- st_read(file.path("data/charging/CA_Counties","CA_Counties_TIGER2016.shp")) %>% st_transform("WGS84")
#Highways <- st_read(file.path("data/charging/SHN_Lines","HWY_SHN_Lines.shp")) %>% st_transform("WGS84")
State_Boundary <- st_read(file.path("data/charging/ca-state-boundary","CA_State_TIGER2016.shp")) %>% st_transform("WGS84")
#Transmission <- st_read(file.path("data/charging/Transmission","Transmission_Line.shp")) %>% st_transform("WGS84")

#AFDC Station data 
statioon_Sep_9 <- read_csv("data/charging/alt_fuel_stations (Sep 9 2022).csv") 
Sub <- statioon_Sep_9[,c("Station Name","Latitude", "Longitude")] %>% dplyr::rename(name = `Station Name`)
my_sub <- st_as_sf(Sub, coords = c('Longitude', 'Latitude'),crs =4269) %>% st_transform("WGS84") 

#Other attributes 
Substations <- st_read(file.path("data/charging/California_Electric_Substations","CA_Substations_Final.shp")) %>% st_transform("WGS84")
#Boundary <- st_read(file.path("data/charging/data-2","District_201511.shp")) %>% st_transform("WGS84")

#Map Visualization of corridor chargers along the highways
c <- leaflet() %>% 
  setView(-120, 37.4, 6) %>% 
  #addProviderTiles(providers$CartoDB.PositronOnlyLabels) %>% 
  addProviderTiles(providers$CartoDB.VoyagerLabelsUnder) %>% 
  addPolygons(
    data = State_Boundary,
    fillColor = "white",
    weight = 0.01,
    opacity = 1,
    dashArray = "3",
    fillOpacity = 0.7,
    color = "black"
    ) %>% 
  addCircles(data = my_sub, 
             weight = 1,
             radius = 40234,
             fillColor = "lightgreen",
             fillOpacity = 0.2,
             color = NA,
             group = "Current DCFC"
  )%>% 
  addPolylines(
    data = roads,
    color = "goldenrod",
    weight = 2,
    ) %>% 
  addCircles(data = Substations, 
                   weight = 3,
                   radius = 4828.03,
                   fillColor = "steelblue",
                   fillOpacity = 0.8,
                   color = NA,
                   group = "Existing Substations"
  )%>% 
  addCircleMarkers(data = my_sub, 
             weight = 1,
             radius = 5,
             fillColor = "seagreen",
             fillOpacity = 0.8,
             color = NA,
             group = "Current DCFC",
             popup = ~as.character(name),
             label = ~as.character(name),
  ) %>% 
  addLayersControl(
    overlayGroups = c("Current DCFC", "Existing Substations"),
    options = layersControlOptions(collapsed = FALSE)
  )

