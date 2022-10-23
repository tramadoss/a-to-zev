
##Libraries
library(readxl)
library(ggplot2)
library(ggmap)
library(sf)
library(readr)

##Shapefile 
my_sf <- st_as_sf(map, coords = c('Longitude', 'Latitude'),crs =4269 )
roads <- st_read(file.path("Data/Shape_file","shn2014v3_Segments.shp"))
Counties <- st_read(file.path("Data/CA_Counties","CA_Counties_TIGER2016.shp"))
Highways <- st_read(file.path("Data/SHN_Lines","HWY_SHN_Lines.shp"))
State_Boundary <- st_read(file.path("Data/ca-state-boundary","CA_State_TIGER2016.shp"))
Transmission <- st_read(file.path("Data/Transmission","Transmission_Line.shp"))


#AFDC Station data 
statioon_Sep_9 <- read_csv("Data/alt_fuel_stations (Sep 9 2022).csv")

##Creating shapefile
Sub <- statioon_Sep_9[,c("Station Name","Latitude", "Longitude")]
my_sub <- st_as_sf(Sub, coords = c('Longitude', 'Latitude'),crs =4269 )

#Other attributes 
Substations <- st_read(file.path("Data/California_Electric_Substations","CA_Substations_Final.shp")) 
Substation_buffer <- st_buffer(Substations,4828.03)
Boundary <- st_read(file.path("Data/data-2","District_201511.shp"))

##Creating uffer around stations 
buffer <- st_buffer(my_sf, 40234) # for 25 miles converted to meters
buffer2 <- st_buffer(my_sub,40234) # 25 miles converted to meters


#Map Visualization of corridor chargers along the highways

plot1 <- ggplot() + 
  #geom_sf(data = Boundary,color = "khaki", fill= "white")+
  geom_sf(data = State_Boundary, fill="white")+
  
  geom_sf(data = buffer2, color= "palegreen3", lwd = 0.1 )+
  #geom_sf(data = buffer, color= "salmon" )+
  geom_sf(data = roads, col="indianred", lwd= 0.2)+
  geom_sf(data = my_sub, color= "springgreen4",size = 1)+
  
  #geom_sf(data = my_sf, color= "red" )+
  
  theme_bw()+
  theme(panel.background = element_rect(fill = "aliceblue"),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_line(color = "white", size = 0.8))

plot1

##Substations map with transmission line

plot2 <- ggplot() + 
  geom_sf(data = State_Boundary, fill= "white")+
  geom_sf(data = Transmission, color="tan1") +
  geom_sf(data = Substation_buffer, color="deepskyblue4")+
  geom_sf(data = Substations, color= "deepskyblue", size = 0.3 )+
  geom_sf(data = roads, col="red", lwd= 0.1 )+
  #geom_sf(data = my_sub, color= "springgreen4",size = 0.9)+
  #geom_sf(data = buffer, color= "red" )+
  
  
  #geom_sf(data = my_sf, color= "red", size = 0.9 )+
  theme_bw()+
  theme(panel.background = element_rect(fill = "aliceblue"),
        axis.ticks = element_blank(),
        axis.text = element_blank(),
        panel.grid = element_line(color = "white", size = 0.8))

plot2

## Charging station layer on substation map

plot3 <- plot2 + geom_sf(data = buffer2, color= "palegreen3", lwd = 0.1 )+ 
  geom_sf(data = my_sub, color= "springgreen4",size = 1)

plot3
