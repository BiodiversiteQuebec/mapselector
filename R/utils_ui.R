


widget_div_wrapper <- function(wid){
  tags$div(class = "widget-div", wid)
}

#' @export
widgets <- function(...){
  ll <- list(...)
  lapply(ll, widget_div_wrapper)
}


#' @export
tab_map <- function(title = "Map", outputFunction = leaflet::leafletOutput, id = "map"){
  
  tabPanel(title,
           tags$div(class = "main-map",
                    outputFunction(id)
           )
  )
}

#' @export
tab_gen <- function(title = "Data download", outputFunction = downloadButton, id = "DL_data",...){
  tabPanel(title,
           outputFunction(id),...)
}


## dashboard functions

#' @export
dash_title <- function(title = "Analyse de raréfaction"){
  fillRow(
    flex = c(3,1,1),
    fillCol(
      tags$div(
        class = "left-header",
        tags$div(class = "logo", 
                 tags$img(src = "https://coleo.biodiversite-quebec.ca/apps/shiny-src/coleo_test_small.png",
                          height = "60px")),
        tags$div(class = "dash-title", title)
      ),
      hover = "Coléo"),
    height = "100px",
    class= "top-header")
}

# this function needs to count the tabs
#' @export
dash_tabs <- function(...){
  
  list_of_tabs <- list(...)
  tab_seq <- seq_len(length(list_of_tabs))
  
  tabclasses <- paste0("maintab-", tab_seq)
  
  for (i in tab_seq){
    list_of_tabs[[i]] <- htmltools::tagAppendAttributes(
      list_of_tabs[[i]], 
      class = tabclasses[i])
  }
  
  tabfun <- function(...) tabsetPanel(id ="tabs", type = "tabs", ...)
  
  tabpanel <- do.call(tabfun, list_of_tabs)
  
  fillCol(id="main",tabpanel)
}

#' @export
dash_sidebar <- function(badge_function, ...){
  fillCol(id = "sidebar",
          tags$div(
            tags$div(
              id = "closebtn-div",
              tags$a(href = "javascript:void(0)",
                     id = "closebtn",'<')),
            badge_function,
            widgets(...)
          ))
}

#' @export
tableau_de_bord <- function(titre = dash_title(), 
                            sidebar = 
                              dash_sidebar(
                                badge(),
                                sliderInput(
                                  "obs",
                                  "Nombre d'observations:",
                                  min = 0,
                                  max = 1000,
                                  value = 500),
                                textInput("name", "What's your name?")
                              ), 
                            tabs = dash_tabs(tab_map(),
                                             tab_gen()))
{
  fillPage(
    tags$head(
                tags$link(rel = "stylesheet", type = "text/css", href = "https://coleo.biodiversite-quebec.ca/apps/shiny-src/style.css"),
                tags$script(src = "https://coleo.biodiversite-quebec.ca/apps/shiny-src/tableau.js")
    ),
    titre,
    fillRow(
      id = "main-row",
      flex = c(2,8),
      sidebar,
      tabs)
  )
}


#' @export
badge <- function(use_badge = TRUE,
                  text_badge = "Ce tableau de bord vise à tester les modèles de tableau de bord."){
  if (use_badge)  {tags$div(class = "blue-badge", text_badge)}
  # test if badge = FALSE or text is NULL
}
  
## colours

pal <- c( "amphibiens" = "#56B4E9", 
         "mammifères" =   "#D55E00", 
         "oiseaux"    =  "#E69F00", 
         "poissons"   =    "#0072B2", 
         "reptiles"   = "#009E73",
         "#999999")
