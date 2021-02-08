#' Plot a leaflet map
#' 
#' function for making a leaflet map of the chosen region
#' 
#' @param mapdata the data that supplies the things that go on your map. default is `mapselector::CERQ`
#' @param label should a mouseover label appear? default is TRUE
#' @param region_name quoted name of the column in your dataset that gives the mouseover text. Will also be returned when you click
#' 
#' @importFrom magrittr `%>%`
#' @export
make_leaflet_map <- function(mapdata = mapselector::CERQ, label = TRUE, region_name = "NOM_PROV_N") {
  
  assertthat::assert_that(assertthat::has_name(mapdata, region_name))
  
  # label with a column, otherwise NULL
  
  if(label) labeltext <- mapdata[[region_name]] else labeltext <- NULL
  
  leaflet::leaflet(mapdata,
                   options = leaflet::leafletOptions(minZoom = 4)) %>%
    leaflet::addTiles() %>% # Affichage du fond de carte
    leaflet::addPolygons(
      color = "darkblue", # couleur des limites des polygones
      weight = 1,
      smoothFactor = 0.5,
      layerId = mapdata[[region_name]],
      label = labeltext,
      fillColor = "#2571BB", # couleur du remplissage des polygones
      fillOpacity = 0.4,
      highlightOptions = leaflet::highlightOptions(color = "white",
                                                   fillColor = "#2571BB",
                                                   weight = 3,
                                                   opacity = 1,
                                                   fillOpacity = 1,
                                                   bringToFront = TRUE)
    )
}


# function for making a leaflet map of an sdm

#' @importFrom magrittr `%>%`
#' @export

make_leaflet_sdm <- function(sdm=NULL) {
 
  # Prepare color palette for raster map
  max_int <- max(sdm[,,], na.rm=T)
  max_int <- ceiling_dec(max_int, level=nbr_dec(max_int))
  min_int <- min(sdm[,,], na.rm=T)
  min_int <- floor_dec(min_int, level=nbr_dec(min_int))

  pal <- leaflet::colorNumeric(palette = viridis::viridis(100), domain = c(NA, min_int, max_int), na.color = "transparent")
  pal_legend <- leaflet::colorNumeric(palette = viridis::viridis(100), domain = c(NA, min_int, max_int), na.color = "transparent", reverse = TRUE) # reverse so it works with legends with value from 1 to 0

  # Render map for all species
  map_qc = leaflet::leaflet(options = leaflet::leafletOptions(minZoom=4)) %>%
                leaflet::addTiles() %>%
                leaflet::addRasterImage(sdm, color = pal, project=FALSE, opacity = 0.7) %>%
                leaflet::addLegend(pal = pal_legend, values = seq(max_int,min_int, -1*(max_int-min_int)/100), title = "Ratio de probabilité d'occurrence",
                labFormat = leaflet::labelFormat(transform = function(x) sort(x, decreasing = TRUE)), group = "Distribution", layerId = "distr_legend", opacity=1) %>%
                leaflet::fitBounds(lng1 = -79.76330, lat1 = 44.99136, lng2 = -56.93868, lat2 = 62.58191)
}

# Ceiling and floor for intervals in raster legend
floor_dec <- function(x, level=1) round(x - 5*10^(-level-1), level)
ceiling_dec <- function(x, level=1) round(x + 5*10^(-level-1), level)

# Get number of decimals (level) for floor_dec or ceiling_dec
nbr_dec <- function(x) {
  i=0
  while(abs(x) < 1) {
    i=i+1
    x=x*10
  }
  return(i)
}


#' @importFrom magrittr `%>%`
#' @export
make_leaflet_empty <- function() {  
  leaflet::leaflet(options = leaflet::leafletOptions(minZoom = 4), ) %>%
    leaflet::addTiles() %>% # Affichage du fond de carte
    leaflet::fitBounds(lng1 = -79.76330, lat1 = 44.99136, lng2 = -56.93868, lat2 = 62.58191)
}