#' observation_display UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @export
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
#' @param id the id for this modal
#' @param site the site data frame
#' @param region reactive value, the region that was clicked
#' @noRd 
#' @export
mod_observation_display_server <- function(id, site, region, token = rcoleo:::bearer()){
  assertthat::assert_that(shiny::is.reactive(region))
  
  moduleServer( id, function(input, output, session){
    ns <- session$ns
 
    to_show <- reactive({get_subset_site(site = site, site_code_sel = region(), token = token)})
    
    output$obs_tbl = DT::renderDT(to_show(),
                                  options = list(lengthChange = FALSE,
                                                 fillContainer = FALSE)
    )
  })
}


#' @export 
get_subset_site <- function(site = rcoleo::download_sites_sf(), 
                            site_code_sel = "137_111_F01",
                            token = rcoleo:::bearer()){
  
  # before the click the map, do nothing 
  req(site_code_sel)
  
  # subset the site list by any requests
  subsite <- subset(site, site_code == site_code_sel)
  
  
  # download from coleo database
  resp <- rcoleo::get_all_observations_from_a_site(subsite, token = token)

  if (nrow(resp$obs_resp[[1]]) == 0) message("there is no data here") else return(resp$obs_resp[[1]])
  
}


    
## To be copied in the UI
# mod_observation_display_ui("observation_display_ui_1")
    
## To be copied in the server
# mod_observation_display_server("observation_display_ui_1")

# testing function
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
