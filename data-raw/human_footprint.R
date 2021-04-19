## code to prepare `human_footprint` dataset goes here



library(sf)
library(raster)

#================================================================================
# Chargement des données 
#================================================================================

# On charge les données des sites extraites de coléo
# On pourrait ici faire appel à l'API mais le travail est fait localament pour accélérer le traitement
# load("source_data/sites.RDS")
# load("source_data/cells.RDS")
hf <- raster("data-raw/hfp_global_geo_grid/hf_v2geo/dblbnd.adf") 

#================================================================================
# Exécution
#================================================================================

all_sites_resp <- rcoleo::download_sites_sf()


library(tidyverse)

sites %>% 
  select(site_code, geom.coordinates)


# Associer humain footprint à chaque cellule

extracted_human_feet <- raster::extract(hf, all_sites_resp, cellnumbers = TRUE, fun = "mean")[,2]


human_footprint <- data.frame(sites = all_sites_resp$site_code, hf = extracted_human_feet)


usethis::use_data(human_footprint, overwrite = TRUE)
