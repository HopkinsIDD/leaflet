# library(sf)
# library(leaflet)
# library(geojsonsf)
# library(geojsonio)

library(raster)
library(tiler)
library(RColorBrewer)
library(taxdat)
library(rgdal)

raster_directory <- "~/svn/cholera-taxonomy/trunk/manuscripts/GAVI Impact Estimation/data/"
repository_directory <- "~/git/leaflet"
WtOrBr = c("#FFFFFF", "#FED98E", "#FE9929", "#D95F0E", "#993404")
case_palette <- colorRampPalette(WtOrBr,space="Lab")
rate_palette <- brewer.pal(9, name="RdBu")
rate_palette <-colorRampPalette(rate_palette, space = "Lab")


rates <- raster::raster(paste(raster_directory,"afro_2010-2016_lambdas_raster_stack_upd.grd",sep='/'))
rates <- taxdat::aggregate_raster_xlayers(rates,mean)
## Set the minimum rate to be the bottom of the color scale
rates[][100000*rates[] < 10^(-2)] <- 10^(-2)/100000
raster::writeRaster(rates,paste(repository_directory,'rates.tif',sep='/'),overwrite=TRUE)
raster::writeRaster(log10(rates*100000),paste(repository_directory,'log10rates.tif',sep='/'),overwrite=TRUE)

cases <- raster::raster(paste(raster_directory,"afro_2010-2016_cases_raster_stack_upd.grd",sep='/'))
cases <- taxdat::aggregate_raster_xlayers(cases,mean)
## Set the number of cases rate to be the bottom of the color scale
cases[][log(cases[]) < -5] <- exp(-5)
raster::writeRaster(cases,paste(repository_directory,'cases.tif',sep='/'),overwrite=TRUE)
raster::writeRaster(log(cases),paste(repository_directory,'logcases.tif',sep='/'),overwrite=TRUE)


tiler::tile(
  paste(repository_directory,'log10rates.tif',sep='/'),
  paste(repository_directory,'log10rates','tiles',sep='/'),
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",
  col = rev(rate_palette(255)),
  zlim = c(-4,4)
)
tiler::tile(
  paste(repository_directory,'rates.tif',sep='/'),
  paste(repository_directory,'rates','tiles',sep='/'),
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",
  col = rev(rate_palette(255)),
  zlim = (10^c(-2,4))/100000
)

tiler::tile(
  paste(repository_directory,'cases.tif',sep='/'),
  paste(repository_directory,'cases','tiles',sep='/'),
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",
  col = case_palette(255),
)

tiler::tile(
  paste(repository_directory,'logcases.tif',sep='/'),
  paste(repository_directory,'logcases','tiles',sep='/'),
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0",
  col = case_palette(255),
  zlim = c(-5.0001,8.92)
)
