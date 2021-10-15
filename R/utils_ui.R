


widget_div_wrapper <- function(wid){
  tags$div(class = "widget-div", wid)
}

#' @export
widgets <- function(...){
  ll <- list(...)
  lapply(ll, widget_div_wrapper)
}

#' Create a leaflet map
#' 
#' This map creates a leaflet map. It takes an optional list of widgets to display on the map and 
#' places them on top. 
#' 
#' 
#' @param title title for the tab
#' @param id id of the output to plot
#' @param outputFunction the Output function that draws the plot,. usually `leaflet::leafletOutput`
#' @param on_map_widgets doesn't actually work because idk if we're doing that anymore?
#'
#' @export
tab_map <- function(title = "Map",
                    id = "map",
                    outputFunction = leaflet::leafletOutput,
                    ## any on-map widgets go here:
                    on_map_widgets = list(NULL)
                    ){
  
  
  # panel_widgets <- function(widgets) absolutePanel(top = 50, right = 30, widgets)
  
  tabPanel(title,
           tags$div(class = "main-map",
                    outputFunction(id)#,
                    # tags$div(class = "map-controls",
                    #          do.call(panel_widgets, on_map_widgets))
           )
  )
}


# function that takes in tabs as dots and returns a tabpanel, with each tab given a prefix and a number
add_class_tabs <-  function(prefix = "maintab-", ..., type = "tabs"){
  list_of_tabs <- list(...)
  tab_seq <- seq_len(length(list_of_tabs))
  
  tabclasses <- paste0("maintab-", tab_seq)
  
  for (i in tab_seq) {
    list_of_tabs[[i]] <- htmltools::tagAppendAttributes(
      list_of_tabs[[i]], 
      class = tabclasses[i])
  }
  
  tabfun <- function(...) tabsetPanel(id = "tabs", ..., type = type)
  
  tabpanel <- do.call(tabfun, list_of_tabs)

  return(tabpanel)
}
    

# this function needs to count the tabs
#' @export
dash_tabs <- function(...){
  
  tabpanel <- add_class_tabs(prefix = "maintab-", ...)
  
  
  fillCol(id="main",tabpanel)
}


#' @export
tab_gen <- function(title = "Data download", outputFunction = downloadButton, id = "DL_data",...){
  tabPanel(title,
           outputFunction(id),...)
}



## dashboard functions

#' @export
dash_title <- function(title = "Analyse de raréfaction"){
    column(
      tags$div(
        class = "left-header",
        tags$div(class = "dash-title", title)
      )
    )
}

  #' @export
dash_sidebar <- function(badge_function, ...){
  column(id = "sidebar",
          tags$div(
            tags$div(
              id = "closebtn-div",
              tags$a(href = "javascript:void(0)",
                     id = "closebtn",'<')),
            dash_title(),
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
                tags$script(src = "https://coleo.biodiversite-quebec.ca/apps/shiny-src/tableau.js"),
                fa_dependency()
    ),
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
         "arthropodes" = "#AA8222",
         "mollusques" = "#158186",
         "plantes" = "#6da824",
         "#999999")


#' @export
species_colors <- function(sp_cat){
  if (sp_cat %in% names(pal)){
    return(pal[[sp_cat]])
  }else{
    return("#999999")
  }
}

## colours

icons <- c("amphibiens" = "<i class='fianimals animals-010-frog'></i>", 
         "mammifères" =   "<i class='fianimals animals-001-mouse'></i>", 
         "oiseaux"    =  "<i class='fianimals animals-020-bird:'></i>", 
         "poissons"   =   "<i class='finature-collection nature-collection-fish'></i>", 
         "reptiles"   = "<i class='fianimals animals-039-snake'></i>",
         "arthropodes" = "<i class='finature nature-012-beetle'></i>",
         "mollusques" = "<i class='finature nature-039-snail'></i>",
         "plantes" = "<i class='finature-collection nature-collection-plant-1'></i>",
         "#999999")

#' @export
species_icons <- function(sp_cat){
  if (sp_cat %in% names(icons)){
    return(icons[[sp_cat]])
  }else{
    return("#999999")
  }
}

pal_campaign_types <- c( "amphibiens" = "#56B4E9", 
                       "mammifères" = "#D55E00", 
                       "papilionidés" = "#E69F00", 
                       "zooplancton"  = "#0072B2", 
                       "acoustique" = "#009E73",
                       "arthropodes" = "#AA8222",
                       "insectes_sol" = "#158186",
                       "végétation" = "#6da824",
                       "#999999")

#' @export
campaign_types_colors <- function(cat){
  if (cat %in% names(pal_campaign_types)){
    return(pal_campaign_types[[cat]])
  }else{
    return("#999999")
  }
}

icons_campaigns <- c("végétation"="<i class='finature-collection nature-collection-plant-2'></i>",
                     "papilionidés"="<i class='fianimals animals-036-butterfly'></i>",
                     "acoustique"="<i class='fianimals animals-007-bat'></i>",
                     "odonates"="<i class='ficustom custom-dragonfly'></i>",
                     "insectes_sol"="<i class='finature nature-012-beetle'></i>",
                     "zooplancton"="<i class='ficustom custom-shrimp'></i>")

#' @export
campaign_types_icons <- function(cat){
  if (cat %in% names(icons_campaigns)){
    return(icons_campaigns[[cat]])
  }else{
    return("#999999")
  }
}


campaigns_types_formatted <- c("végétation"="Végétation",
                     "papilionidés"="Papillons",
                     "acoustique"="Chauves-souris",
                     "odonates"="Odonates",
                     "insectes_sol"="Insectes du sol",
                     "zooplancton"="Zooplancton")

#' @export
campaign_types_format <- function(cat){
  if (cat %in% names(campaigns_types_formatted)){
    return(campaigns_types_formatted[[cat]])
  }else{
    return(FALSE)
  }
}

#' Generate a div for the sliding explainer on the side
#' 
#' Write and store the text you want in `inst/app/www/` . 
#' It has to be in Markdown format
#' 
#' @param filename the filename of the file, but not the path. 
#' 
#' @export
marcel <- function(filename){
  f <- here::here("inst", "app", "www", filename)
  stopifnot(file.exists(f))
  
  tags$div(
    class = 'tuto-wrap',
    tags$div(
      class = 'tuto-content',
      includeMarkdown(f)
    )
  )
}


#' Depend on fontawesome css for the map icons
#'
#' Any figure that intends to use font awesome classes for the icons needs this
#' somewhere. this is included by default in tableau_de_bord(), but it is also
#' available for use in any fluidPage, tagList, etc.
#'
#' @return htmlDependency on font-awesome
#' @export
fa_dependency <- function(){
  #htmltools::htmlDependency("font-awesome", 
  #                          "5.13.0", "www/shared/fontawesome", package = "shiny", 
  #                          stylesheet = c("css/all.min.css", "css/v4-shims.min.css"))
}
