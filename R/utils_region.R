
#' Add the regions to a plot
#' 
#' This function adds the CERQ province names to any dataframe.
#' 
#' Observations from anywhere in Quebec must fall in one of the 20 CERQ regions.
#' In most of our apps, we use these regions to select subsets of the data. 
#' To do this, we need to know the region which matches each observation. 
#' This function automates that process. 
#' 
#' Note that the mapping may not be perfect, tk link to documentation.
#' 
#' This function uses sf, and will not work unless that is installed.
#' 
#' IMPORTANT: note that you need to have columns called specifically "longitude" and "latitude" in your data frame
#' 
#' @param obs_data a dataframe of observations
#' @return the same dataframe with one new column, NOM_PROV_N. This new column contains the French names of the natural provinces of Quebec
#' 
#' @export
add_region <- function(obs_data){
  assertthat::assert_that(
    assertthat::has_name(obs_data, c("longitude", "latitude"))
  )
  obs_data %>% 
    # needs to have a long and lat column 
    sf::st_as_sf(coords = c("longitude", "latitude")) %>% # set coordinates
    # this CRS could be set in some general place in mapselector and then modified only once.
    sf::st_set_crs(value = "+proj=longlat +datum=WGS84 +no_defs") %>% 
    sf::st_join(mapselector::CERQ["NOM_PROV_N"])
}
