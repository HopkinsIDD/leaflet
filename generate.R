# library(sf)
# library(leaflet)
# library(geojsonsf)
# library(geojsonio)

library(raster)
library(tiler)
library(RColorBrewer)
library(taxdat)
library(rgdal)

# 
# pal <- colorNumeric("viridis", NULL)
# 
# b <- st_read('~/rates.geojson')
# b <- a[1:100,]
# 
# leaflet(b) %>%
#   addTiles() %>%
#   addPolygons(
#     color = ~pal(log10(rate))
#   )
colsramp2 <- brewer.pal(9, name="Oranges")
colsramp2 <-colorRampPalette(colsramp2, space = "Lab")
colsramp <- brewer.pal(9, name="Blues")
colsramp <-colorRampPalette(colsramp, space = "Lab")
colsramp3 <- brewer.pal(9, name="Spectral")
colsramp3 <-colorRampPalette(colsramp3, space = "Lab")
colsramp4 <- brewer.pal(9, name="RdYlGn")
colsramp4 <-colorRampPalette(colsramp4, space = "Lab")

raster_directory <- "~/Desktop/Lessler-Lab/svn/cholera-taxonomy/trunk/manuscripts/GAVI Impact Estimation/data/"
repository_directory <- "~/Desktop/Lessler-Lab/maps/leaflet"
## This will generate temporary files in your home directory

rates <- raster::raster(paste(raster_directory,"afro_2010-2016_lambdas_raster_stack_upd.grd",sep='/'))
rates <- taxdat::aggregate_raster_xlayers(rates,mean)
rates[][100000*rates[] < 10^(-2)] <- 10^(-2)/100000
raster::writeRaster(rates,paste(repository_directory,'rates.tif',sep='/'),overwrite=TRUE)
raster::writeRaster(log10(rates*100000),paste(repository_directory,'log10rates.tif',sep='/'),overwrite=TRUE)

cases <- raster::raster(paste(raster_directory,"afro_2010-2016_cases_raster_stack_upd.grd",sep='/'))
cases <- taxdat::aggregate_raster_xlayers(cases,mean)
cases[][log(cases[]) < -5] <- exp(-5)
raster::writeRaster(cases,paste(repository_directory,'cases.tif',sep='/'),overwrite=TRUE)
raster::writeRaster(log(cases),paste(repository_directory,'logcases.tif',sep='/'),overwrite=TRUE)


tiler::tile(
  paste(repository_directory,'log10rates.tif',sep='/'),
  paste(repository_directory,'log10rates','tiles',sep='/'),
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",
  col = rev(colsramp3(255)),
  zlim = c(-4,4)
)
tiler::tile(
  paste(repository_directory,'rates.tif',sep='/'),
  paste(repository_directory,'rates','tiles',sep='/'),
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",
  col = rev(colsramp3(255)),
  zlim = (10^c(-2,4))/100000
)

tiler::tile(
  paste(repository_directory,'cases.tif',sep='/'),
  paste(repository_directory,'cases','tiles',sep='/'),
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",
  col = colsramp2(255),
)

tiler::tile(
  paste(repository_directory,'logcases.tif',sep='/'),
  paste(repository_directory,'logcases','tiles',sep='/'),
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",
  col = colsramp2(255),
  zlim = c(-5.0001,8.92)
)
