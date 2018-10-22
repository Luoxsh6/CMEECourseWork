rm(list=ls())
library(maps)
# load in the data
load("../data/GPDDFiltered.RData")
gpdd <- as.data.frame(gpdd)
map("world", fill =FALSE,ylim = c(-60, 90), mar = c(0, 0, 0, 0))

points(gpdd$long, gpdd$lat,  pch = 19, col = 345)


m<- leaflet(gpdd)
m<- addTiles(m)
m<- setView(m,lng=0.00,lat=20.00,zoom=2)
addCircleMarkers(m,lng=~long,lat=~lat,radius =0.1, col= 27, fill = TRUE)

text(dat$jd, dat$wd, dat[, 1], cex = 0.9, col = rgb(0,
    0, 0, 0.7), pos = c(2, 4, 4, 4, 3, 4, 2, 3, 4, 2, 4, 2, 2,
    4, 3, 2, 1, 3, 1, 1, 2, 3, 2, 2, 1, 2, 4, 3, 1, 2, 2, 4, 4, 2))
axis(1, lwd = 0); axis(2, lwd = 0); axis(3, lwd = 0); axis(4, lwd = 0)




