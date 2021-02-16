#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    marcel(filename = "marcel.md"),
    golem_add_external_resources(),
    tableau_de_bord(
      dash_title(title = "Analyse de raréfaction"), 
      dash_sidebar(
        badge(),
        textInput("name", "What's your name?"),
        mod_modal_helpbutton_ui("info1")
      ), 
      dash_tabs(
        #maybe a little strange, but here we pass in the UI of a modal and the id that defines it.
        tab_map(title = "Map", id = "map", outputFunction = mod_map_select_ui),
        tab_map(title = "Site Map", id = "sitemap", outputFunction = mod_map_select_ui),
        tab_gen())
    )
  )
}

#' Add external Resources to the Application
#' 
#' This function is internally used to add external 
#' resources inside the Shiny application. 
#' 
#' @import shiny
#' @importFrom golem add_resource_path activate_js favicon bundle_resources
#' @noRd
golem_add_external_resources <- function(){
  
  add_resource_path(
    'www', app_sys('app/www')
  )
 
  tags$head(
    favicon(ext = 'png'),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'mapselector'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

