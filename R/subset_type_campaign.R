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
#'
#' @examples
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