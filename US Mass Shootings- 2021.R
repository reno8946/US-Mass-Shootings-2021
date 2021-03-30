#Install Packages
install.packages("data.table")
install.packages("sp")
install.packages("rgdal")
install.packages("dplyr")
install.packages("ggpubr")
install.packages("grid")
install.packages("leaflet")

#Libraries
library(data.table)
library(sp)
library(rgdal)
library(dplyr)
library(ggpubr)
library(grid)
library(leaflet)

#read in data table
Mass_Shooting_data = fread("Mass_Shootings_US_2021.csv")

#convert to data table
Mass_Shooting_data = as.data.table(Mass_Shooting_data)

#make data spatial
coordinates(Mass_Shooting_data) = c("Longitude","Latitude")
crs.geo1 = CRS("+proj=longlat")
proj4string(Mass_Shooting_data) = crs.geo1

plot(Mass_Shooting_data, pch = 20, col = "steelblue")

#read in shapefile of US
install.packages("sf")
library(sf)

US = readOGR(dsn="C:/Users/16307/anaconda/Class/US-Mass-Shootings-2021/community/States_shapefile.shp", layer="States_shapefile")

#reproject coordinates
proj4string(US) = crs.geo1

chi_agg = aggregate(x=Mass_Shooting_data["X..Injured"],by=US,FUN=length)

install.packages("namespace")
library(namespace)

qpal = colorBin("Reds", chi_agg$X..Injured, bins=4)

leaflet(chi_agg) %>%
  addPolygons(stroke = TRUE,opacity = 1,fillOpacity = 0.5, smoothFactor = 0.5,
              color="black",fillColor = ~qpal(X..Injured),weight = 1) %>%
  addLegend(values=~X..Injured,pal=qpal,title="Total Injured by Gun Violence")

plot(US)
points(Mass_Shooting_data, pch= 20, col= "orange")