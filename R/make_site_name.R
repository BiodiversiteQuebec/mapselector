

#' take a clicked name and lookup the matching value from a vector
#' 
#' The name of the clicked site needs to be among the names in the lookup vector
#'
#' @param got_clicked_site_val clicked value
#' @param cell_lookup_vec lookup vector
#'
#' @return
#' @export
make_site_name <- function(got_clicked_site_val, cell_lookup_vec){
  
  # there should be one and only one match of the clicked value in the lookup vector.
  assertthat::assert_that(sum(names(cell_lookup_vec) == got_clicked_site_val) == 1)
  
  good_name <- cell_lookup_vec[[got_clicked_site_val]]
  
  return(good_name)
}


#' Make the site name
#'
#' @param cell_data a data.frame containing cell info
#'
#'   This data.frame must have columns "type" and "cell.name". They will be
#'   stuck together and simply formatted.
#'
#' @return
#' @export
add_site_name_df <- function(cell_data){
  
  stopifnot(any(c("type", "cell.name") %in% names(cell_data)))
  
  outdata <- transform(cell_data, display_name = paste0(cell.name," -- ", type))
  
  return(outdata)
}


#' Create a lookup table from a data.frame
#'
#' Sometimes one column of a data.frame has human-readable names, and the other
#' had computer-useful codes. We often need to look up one based on the other.
#' This function creates a handy lookup vector from two such columns of a
#' data.frame. The vector is only as long at the number of distinct name-value
#' pairs.
#'
#' @param some_df any data frame, containing two columns: one for values, one
#'   for names used to choose a value
#' @param value_col the values to be looked up
#' @param name_col the names to use to find these values.
#'
#' @return a named vector of
#' @export
make_lookup_vector <- function(some_df, value_col, name_col){
  # check for error
  stopifnot(any(c(value_col, name_col) %in% names(some_df)))
  
  names_df <- as.data.frame(some_df)[,c(value_col, name_col)]
  
  dedup_names <- names_df[!duplicated(names_df), ]
  
  xx <- setNames(dedup_names[[value_col]], dedup_names[[name_col]])
  return(xx)
}