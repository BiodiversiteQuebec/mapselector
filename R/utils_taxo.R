
#' Search for species photo and return url, attribution
#' 
#' 
#' 
#' @param name name to search by 
#' @return the photo url, thumbnail url and comment for the photo
#' 
#' @export

get_species_photo <- function(name){
  resp<-httr::content(httr::GET('https://species.wikimedia.org/w/api.php',query=list(
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
    for (i in 1:length(resp$query$pages)){
      if(grepl("File:Commons-logo",resp$query$pages[i][[1]]$title, fixed = TRUE)==FALSE & grepl("File:Open Access",resp$query$pages[i][[1]]$title, fixed = TRUE)==FALSE & & grepl("Disambig",resp$query$pages[i][[1]]$title, fixed = TRUE)==FALSE) {
        l<-resp$query$pages[i][[1]]$imageinfo[[1]]
        return(list(url=l$url,thumb_url=l$thumburl, comment=l$comment))
      }
    }
  }
  return(list(url=NULL,thumb_url=NULL, comment=NULL))
}