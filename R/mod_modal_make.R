#' modal_make UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_modal_make_ui <- function(id){
  ns <- NS(id)
  tagList(
    # showModal(modalDialog(h3(ns("region"))))
    textOutput(ns("words"))
  )
}
    
#' modal_make Server Functions
#'
#' @noRd 
mod_modal_make_server <- function(id, region = reactive("this region")){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observe({
    if(!is.null( region() )){
      showModal(dataModal( region() ))
    }
    })
  })
}
    
## To be copied in the UI
# mod_modal_make_ui("modal_make_ui_1")
    
## To be copied in the server
# mod_modal_make_server("modal_make_ui_1")
