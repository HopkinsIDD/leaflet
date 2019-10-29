library(sf)
library(leaflet)
library(geojsonsf)
library(geojsonio)

pal <- colorNumeric("viridis", NULL)

b <- st_read('~/rates.geojson')
b <- a[1:100,]

leaflet(b) %>%
  addTiles() %>%
  addPolygons(
    color = ~pal(log10(rate))
  )

rates <- raster::raster("~/svn/cholera-taxonomy/trunk/manuscripts/GAVI Impact Estimation/data/afro_2010-2016_lambdas_raster_stack_upd.grd")
rates <- taxdat::aggregate_raster_xlayers(rates,mean)
raster::writeRaster(rates,'~/rates.tif',overwrite=TRUE)
raster::writeRaster(log10(rates),'~/log10rates.tif',overwrite=TRUE)

cases <- raster::raster("~/svn/cholera-taxonomy/trunk/manuscripts/GAVI Impact Estimation/data/afro_2010-2016_cases_raster_stack_upd.grd")
cases <- taxdat::aggregate_raster_xlayers(cases,mean)
raster::writeRaster(cases,'~/cases.tif',overwrite=TRUE)


tiler::tile(
  '~/log10rates.tif',
  "~/git/leaflet/log10rates/tiles",
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
)
tiler::tile(
  '~/rates.tif',
  "~/git/leaflet/rates/tiles",
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
)

tiler::tile(
  '~/cases.tif',
  "~/git/leaflet/cases/tiles",
  "0-7",
  crs = "+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"
)
