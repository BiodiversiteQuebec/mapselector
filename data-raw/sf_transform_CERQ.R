## code to prepare `CERQ` dataset goes here

# these data are downloaded from https://www.donneesquebec.ca/recherche/dataset/cadre-ecologique-de-reference/resource/0da3fa75-4b76-4485-ae7d-896eb7881b61
# on 30 Nov 2020

# data is gitignored and should be downloaded again if someone needs to redo or check this work! 

# this data cleaning script is based on the work of Claire & Guillaume L.

# Andrew MacDonald 30 Nov


library(sf)
library(tidyverse)

# read using sf
CR01_test <- st_read("./data-raw/CERQ_SHP/CR_NIV_01_S.shp")

# transfer the thing into the right CRS
CR01_crs <- CR01_test %>% st_transform(crs = "+proj=longlat +datum=WGS84 +no_defs")

#smooth the shape out a bit
CR01_sf <- rmapshaper::ms_simplify(CR01_crs, keep=.01)

CR01_sf$NOM_PROV_N %>% unique %>% length

CERQ <- CR01_sf %>%
  mutate(NOM_PROV_N = forcats::fct_reorder(NOM_PROV_N, SHAPE_Area, .desc = TRUE))



usethis::use_data(CERQ, overwrite = TRUE)
