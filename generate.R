# library(sf)
# library(leaflet)
# library(geojsonsf)
# library(geojsonio)

library(raster)
library(tiler)

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

raster_directory <- "~/svn/cholera-taxonomy/trunk/manuscripts/GAVI Impact Estimation/data/"
repository_directory <- "~/git/leaflet"
## This will generate temporary files in your home directory

rates <- raster::raster(paste(raster_directory,"afro_2010-2016_lambdas_raster_stack_upd.grd",sep='/'))
rates <- taxdat::aggregate_raster_xlayers(rates,mean)
raster::writeRaster(rates,paste(repository_directory,'rates.tif',sep='/'),overwrite=TRUE)
raster::writeRaster(log10(rates),paste(repository_directory,'log10rates.tif',sep='/'),overwrite=TRUE)

cases <- raster::raster(paste(raster_directory,"afro_2010-2016_cases_raster_stack_upd.grd",sep='/'))
cases <- taxdat::aggregate_raster_xlayers(cases,mean)
raster::writeRaster(cases,paste(repository_directory,'cases.tif',sep='/'),overwrite=TRUE)


tiler::tile(
  paste(repository_directory,'log10rates.tif',sep='/'),
  paste(repository_directory,'log10rates','tiles',sep='/'),
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
)
tiler::tile(
  paste(repository_directory,'rates.tif',sep='/'),
  paste(repository_directory,'rates','tiles',sep='/'),
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
)

tiler::tile(
  paste(repository_directory,'cases.tif',sep='/'),
  paste(repository_directory,'cases','tiles',sep='/'),
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
)
