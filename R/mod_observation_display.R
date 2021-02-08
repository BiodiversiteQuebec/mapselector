#' observation_display UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_observation_display_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(
      DT::DTOutput(ns("obs_tbl"))
    )
  )
}
    
#' observation_display Server Functions
#'
#' @noRd 
mod_observation_display_server <- function(id, site, region){
  # stopifnot(shiny::is.reactive(region))
  
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    output$obs_tbl = DT::renderDT({
      
      # choose just that site
      subsite <- subset(site, site_code == region())
      
      # download from coleo database
      resp <- rcoleo::get_all_observations_from_a_site(subsite)
      
      to_show <- with(resp$obs_resp[[1]],
                      data.frame(date = created_at,
                                 espece = obs_species.taxa_name,
                                 ))
      
    },
      options = list(lengthChange = FALSE, fillContainer = FALSE)
    )
  })
}
    
## To be copied in the UI
# mod_observation_display_ui("observation_display_ui_1")
    
## To be copied in the server
# mod_observation_display_server("observation_display_ui_1")

testapp_observation_display <- function(){
  ui <- fluidPage(
    mod_observation_display_ui("observation_display_ui_1")
  )
  
  server <-  function(input, output, session) {
    
    downloaded_sites <- rcoleo::download_sites_sf()
    mod_observation_display_server("observation_display_ui_1", 
                                   site = downloaded_sites, 
                                   region = reactive("132_116_F01"))
  }
  shinyApp(ui, server)
}

testapp_observation_display()
