
#' Search for species photo and return url, attribution
#' 
#' This function adds the CERQ province names to any dataframe.
#' 
#' 
#' @param name name to search by 
#' @return the same dataframe with one new column, NOM_PROV_N. This new column contains the French names of the natural provinces of Quebec
#' 
#' @export

get_species_photo <- function(name){
  resp<-content(httr::GET('https://species.wikimedia.org/w/api.php',query=list(
  action="query",
  generator="images",
  prop="imageinfo",
  gimlimit=5,
  redirects=1,
  titles=name,
  format="json",
  iiurlwidth="500",
  iiprop="timestamp|user|userid|comment|canonicaltitle|url|size|dimensions|mime|thumbmime|mediatype|bitdepth"
  )),'parsed')
  if(any(names(resp)=='query')){
    for (i in length(resp$query$pages)){
      if(grepl("File:Commons-logo",resp$query$pages[i][[1]]$title, fixed = TRUE)==FALSE) {
        l<-resp$query$pages[i][[1]]$imageinfo[[1]]
        return(list(url=l$url,thumb_url=l$thumburl, comment=l$comment))
      }
    }
  }
  return(list(url=NULL,thumb_url=NULL, comment=NULL))
}