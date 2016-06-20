#Diego J. Lizcano 2015

#This code shows you quickly how to manipulate IUCN Mammal GR maps and also WORLDCLIM env data.
#Make sure you use the proper citations for the maps and WORLDCLIM if you use this

#-------------------------------------------------------------------------
#Load required packages
#-------------------------------------------------------------------------

library(maptools)

library(rgdal)
library(sp)
library(raster)

library(PBSmapping)
library(rworldmap)
library(RColorBrewer)
library(rgeos)

#-------------------------------------------------------------------------
#Read in IUCN range maps
#These are spatial polygons
#Available in a zipped file from the IUCN website
#Note you need the polygons so you must download terrestrial mammals only
#the all mammals file is in a different format which R can't read
#Note that shapefiles like this come in multiple files
#so you will have files called hc_grid1d.dbf, hc_grid1d.prj, hc_grid1d.shp and hc_grid1d.shx
#You need ALL of them in your working directory to make this work
#-------------------------------------------------------------------------

maps<-readShapeSpatial("MAMMTERR")#This is SLOOOOOOW

proj4string(maps) <-CRS("+proj=longlat +datum=WGS84")
#ensure the projection is correct***This is really important! check your map projection before use!

#If you need to correct the taxonomy so it matches the data:
maps@data$BINOMIAL<-gsub("Mico argentatus","Callithrix argentata", maps@data$BINOMIAL)

#You can plot range maps either individually or on the world map:

plot(maps[which(maps@data$BINOMIAL == "Pan troglodytes"),])

#or:

data(wrld_simpl)
plot(wrld_simpl)
plot(maps[which(maps@data$BINOMIAL == "Pan troglodytes"),], add = TRUE, col = "green")

#-------------------------------------------------------------------------
#To look at overlap/intersections between two species:
#-------------------------------------------------------------------------

intersects<-gIntersection(maps[which(maps@data$BINOMIAL == "Pan troglodytes"),], 
		maps[which(maps@data$BINOMIAL == "Colobus guereza"),])

plot(wrld_simpl)
plot(maps[which(maps@data$BINOMIAL == "Pan troglodytes"),], add = TRUE, col = "green")
plot(maps[which(maps@data$BINOMIAL == "Colobus guereza"),], add = TRUE, col = "blue")
plot(intersects, add= TRUE, col = "yellow")

#-------------------------------------------------------------------------
#Manipulating IUCN range maps
#This is easy, you can subset as you would a normal dataframe
#You just need to use maps@data$VariableName, rather than the standard maps$Variable Name
#because now your dataframe is just part of the whole maps object
#-------------------------------------------------------------------------
#For example, to replace spaces in species names with _ 

maps@data$BINOMIAL<-gsub(" ", "_", maps@data$BINOMIAL)

#-----------------------------------------------
#Plotting colourful maps of environmental data
#----------------------------------------------

#Read in worldclim data (available directly through R)
#extract WORLDCLIM data. Object is a RasterStack with a layer for each variable
#Note you can vary the resolution of the data you extract

bioclim<-getData("worldclim", var = "bio", res = 10)#takes a while the first time

bioclim<-unstack(bioclim)#unstacks raster so you can deal with each variable individually

plot(bioclim[[6]], zlim=c(-100,250), axes = F, col=rev(heat.colors(25)), ext = matrix(c(150,50,-120,-40), nrow = 2))
#zlim defines the range of the variable (temperature in this case = bioclim 6)
#extent defines the lat and long you want to display
#you can use any of R's colour palettes eg rainbow, terrain.colors or a user defined set

plot(bioclim[[6]], zlim=c(-100,250), axes = F, col=rev(rainbow(25)), ext = matrix(c(150,50,-120,-40), nrow = 2))
plot(bioclim[[6]], zlim=c(-100,250), axes = F, col=rev(heat.colors(25)), ext = matrix(c(150,50,-120,-40), nrow = 2))

#Note that "rev" reverses the colour scale, because I prefer red = hot. 

#You can add the parasite location points into this etc.
