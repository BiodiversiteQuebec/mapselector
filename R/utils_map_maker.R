# fucntion for making a leaflet map of the chosen region

#' @importFrom magrittr `%>%`
#' @export
make_leaflet_map <- function() {
  CERQ <- mapselector::CERQ
  
  # leaflet can make attractive colour palattes. 
  # interp_pal <- leaflet::colorFactor(rcartocolor::carto_pal(12,"Prism"), domain = CERQ$NOM_PROV_N)
  
  ## as a demo, make me a map
  
  leaflet::leaflet(CERQ,
                   options = leaflet::leafletOptions(minZoom = 4)) %>%
    leaflet::addTiles() %>% # Affichage du fond de carte
    leaflet::addPolygons(
      color = "darkblue", # couleur des limites des polygones
      weight = 1,
      smoothFactor = 0.5,
      layerId = ~ NOM_PROV_N,
      fillColor = "lightblue", # couleur du remplissage des polygones
      fillOpacity = 0.7,
      highlightOptions = leaflet::highlightOptions(color = "white",
                                                   fillColor = "darkblue",
                                                   weight = 4,
                                                   # fillOpacity = 0.,
                                                   bringToFront = TRUE)
    )
}
