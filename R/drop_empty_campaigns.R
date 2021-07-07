drop_empty_campaigns <- function(site_df) {
  
  no_empty_lists <- subset(site_df,
                           purrr::map_lgl(site_df$campaigns,
                                          is.data.frame))
  
  camps_with_data <- subset(no_empty_lists,
                             purrr::map_lgl(no_empty_lists$campaigns, ~ nrow(.) > 0))
  
  return(camps_with_data)
}