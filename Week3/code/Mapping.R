# map the Global Population Dynamics Database

rm(list=ls())

# load required packages

require(maps)
# load in the data
load("../data/GPDDFiltered.RData")
gpdd <- as.data.frame(gpdd)
# set the map
map(database = "world", fill = T)
# put the points on the map.
points(x = gpdd$long, y = gpdd$lat, pch = 21, bg = gpdd$common.name)

# A more beautiful map
# require(leaflet)
# m<- leaflet(gpdd)
# m<- addTiles(m)
# m<- setView(m,lng=0.00,lat=20.00,zoom=2)
# addCircleMarkers(m,lng=~long,lat=~lat,radius =0.1, col= 27, fill = TRUE)

##Biases: The data is mainly focusing on western regions, specifically North America and Europe, while Southern Africa and Japan shows only a single point. ##Obviously such data is highly biased against the assessment of biodiversity except Western regions.


