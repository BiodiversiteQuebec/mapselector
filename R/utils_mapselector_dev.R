
mapselector_app_ui_starter <- function(){
  if (file.exists("R/app_ui.R")) {
    ans <- readline("do you want to copy over the old app_ui file? y/n")
  }
  
  if (ans != "y" ) {
    stop("stopping") }
  else {
      
      writeLines(
        "#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    tableau_de_bord(
      dash_title(title = \"Analyse de raréfaction\"), 
      dash_sidebar(
        badge(),
        sliderInput(\"obs\",
                    \"Nombre d'observations:\",
                    min = 0,
                    max = 1000,
                    value = 500),
        textInput(\"name\", \"What's your name?\")
      ), 
      dash_tabs(tab_map(),
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
", con = file("R/app_ui.R"))

    }
}

