#' subset a list of campaigns to have all of a certain type 
#' 
#' The return from get_sites has all the campaigns listed. This function subsets that list-column to 
#' create a new one, containing only campaigns of a specific type. 
#'
#' @param campaign_list the list of dataframes containing all campaign information. usually a list column
#' @param campaign_type the types to filter for.
#'
#' @return
#' @export
subset_type_campaign <- function(campaign_list, campaign_type){
  assertthat::assert_that(all(campaign_type %in% c(
    "végétation", "papilionidés", "acoustique", "insectes_sol", 
    "mammifères", "odonates", "zooplancton")))
  
  # filter down the list
  filtered_list <- purrr::map_if(campaign_list,
                                 .p = ~ nrow(.)>0,
                                 .f = ~ subset(., .$type %in% campaign_type))
  
  return(filtered_list)
}



#' subset the dataframe of sites to sites with specific observations
#'
#' @param downloaded_sites data frame of sites
#' @param campaign_type type of observation. can be a vector. must be one of "végétation", "papilionidés", "acoustique", "insectes_sol", 
#' "mammifères", "odonates", "zooplancton"
#'
#' @return
#' @export
subset_site_df <- function(downloaded_sites, campaign_type = "acoustique"){
  
  if (campaign_type != "tous") {
  downloaded_sites$campaigns <- subset_type_campaign(downloaded_sites$campaigns, campaign_type)
  
  
  has_obs <- purrr::map_lgl(downloaded_sites$campaigns, ~ nrow(.) > 0)
  
  downloaded_sites <- subset(downloaded_sites, has_obs)
  }
  
  return(downladed_sites)
}



filter_leaflet_map <- function(mapid, site_df, campaign_type = "tous"){
  
  subset_site_df(site_df, campaign_type)
  
  leaflet::leafletProxy(mapid) %>%
    leaflet::clearMarkers() %>% 
    leaflet::addCircleMarkers(
      data = lpd_qc_filtered,
      layerId = lpd_qc_filtered[["scientific_name"]],
      label = lpd_qc_filtered[["scientific_name"]],
      popup = ~get_popup_content(lpd_qc_filtered),
      color = unname(getColor(lpd_qc_filtered)),
      stroke = FALSE,
      fillOpacity = .7,
      radius = 5
    )
}
