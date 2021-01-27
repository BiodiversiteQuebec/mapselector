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
