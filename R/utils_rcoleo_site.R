
#' @export
icon_colours <- function(){
  icon_options <- list(
    lac             = list(ico = "fish",     col = "darkblue"),
    rivière         = list(ico = "fish",     col = "blue"),
    toundrique      = list(ico = "leaf",     col = "orange"),
    marais          = list(ico = "frog",     col = "darkgreen"),
    "marais côtier" = list(ico = "water",    col = "cadetblue"),
    forestier       = list(ico = "tree",     col = "green"),
    tourbière       = list(ico = "seedling", col = "darkred")
  )
  
  return(icon_options)
}  


#' @export
make_site_icons <- function() {
  fa_col <- function(txt) fontawesome::fa(txt, fill = "white")
  
  icon_options <- lapply(X = icon_colours(), function(l) list(
    text = fa_col(l$ico),
    markerColor = l$col
    ))
  
  awesome_icon_list <- lapply(icon_options, do.call, what = leaflet::makeAwesomeIcon)
  
  site_icons <- do.call(leaflet::awesomeIconList, awesome_icon_list)

  return(site_icons)
}

# could also format cute icons for the actual text, see https://github.com/rstudio/fontawesome

#' Create the icons for a map
#'
#' Take a site dataframe, select the icons that should go on it, and configure
#' these with options. The most important is to define what value should be
#' returned by a click.
#' 
#' @param site_info_sf dataset with site information. should be of type sf and have a column points in sf format
#' @param habitat_col column name that holds the habitat type. defaults to "type"
#' @param site_id_col column name that holds the value that gets returned when clicked. defaults to "site_code
#' 
#' @export
make_icon_adders <- function(site_info_sf, 
                             site_icons = make_site_icons(),
                             habitat_col = "type",
                             site_id_col = "site_code"){
  
  
  site_info_sf_split <- split(site_info_sf, site_info_sf[[habitat_col]])
  
  # filter the icons -- only what is in data
  
  filter_icons <- site_icons[names(site_info_sf_split)]
  
  # lengths should be same
  stopifnot(length(site_info_sf_split) == length(filter_icons))
  
  add_partial_awesome <- function(ic, dat, grp, pt_id) {
    function(map) leaflet::addAwesomeMarkers(map = map, 
                                    icon = ic, 
                                    data = dat,
                                    group = grp,
                                    layerId = pt_id, 
                                    label = pt_id)
  }
  
  markers <- mapply(add_partial_awesome,
                    filter_icons, 
                    site_info_sf_split, 
                    names(site_info_sf_split),
                    lapply(site_info_sf_split, `[[`, site_id_col))

  return(markers)
}



runfun <- function(x, fun){
  fun(x)
}


#' Add markers to a map of sites
#'
#' Take a blank map and put markers on it. Markers are supplied in a list so
#' that they can be grouped and then controlled together.
#' 
#' @param site_info_sf the site info df. should be sf
#' @param markers a list of markers to add
#' 
#' @export
plot_markers_controls <- function(site_info_sf, markers){
  blank_map <- site_info_sf %>%  
    leaflet::leaflet(.) %>% 
    leaflet::addTiles(.)
  
  p <- Reduce(f = runfun, markers, init = blank_map)
  
  leaflet::addLayersControl(p ,
                            overlayGroups = names(markers),
                            options = leaflet::layersControlOptions(collapsed = FALSE)
  )
}


#' @export
plot_rcoleo_sites <- function(rcoleo_sites_sf = rcoleo::download_sites_sf(token = Sys.getenv("RCOLEO_TOKEN")),
                              site_id_col = "site_code"){
  
  icon_adders <- make_icon_adders(rcoleo_sites_sf, site_id_col = site_id_col)
  
  plot_markers_controls(rcoleo_sites_sf, icon_adders)
}
