#' map_select UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_map_select_ui <- function(id){
  ns <- NS(id)
  tagList(
    
  )
}
    
#' map_select Server Functions
#'
#' @noRd 
mod_map_select_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
  })
}
    
## To be copied in the UI
# mod_map_select_ui("map_select_ui_1")
    
## To be copied in the server
# mod_map_select_server("map_select_ui_1")
