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
      title_row(),
      fillRow(
        flex=c(2,8),
        id="main-row",
        fillCol(id = "sidebar",
                sidebar_row()
                ),
        fillCol(id="main",
                tabsetPanel(type = "tabs",
                            tab_bigvis()
                            ,
                            tabPanel("Data download",
                                     div(downloadButton("DL_data"))
                            )
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
    favicon(),
    bundle_resources(
      path = app_sys('app/www'),
      app_title = 'mapselector'
    )
    # Add here other external resources
    # for example, you can add shinyalert::useShinyalert() 
  )
}

