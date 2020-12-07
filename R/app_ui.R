#' The application User-Interface
#' 
#' @param request Internal parameter for `{shiny}`. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_ui <- function(request) {
  tagList(
    golem_add_external_resources(),
    fillPage(
      dash_title(),
      fillRow(
        id="main-row",
        flex=c(2,8),
        fillCol(id = "sidebar",
                sidebar_row(
                  badge(),
                  widgets(sliderInput("obs",
                                      "Nombre d'observations:",
                                      min = 0,
                                      max = 1000,
                                      value = 500),
                          textInput("name", "What's your name?"))
                )
        ),
        fillCol(id="main",
                tabsetPanel(type = "tabs",
                            tab_bigvis(),
                            tab_gen()
                )
        )
      )
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

