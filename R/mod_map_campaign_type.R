#' map_campaign_type UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @export
mod_map_campaign_type_ui <- function(id){
  ns <- NS(id)
  tagList(
    checkboxGroupInput(ns("camp_types_sel"),
                       label = "Quel types de campaigns?",
                       choices = c(
                         "végétation", "papilionidés", "acoustique", "insectes_sol", 
                         "mammifères", "odonates", "zooplancton"),
                       selected = c("acoustique", "odonates"))
  )
}
    
#' map_campaign_type Server Functions
#'
#' @noRd 
#' @export
mod_map_campaign_type_server <- function(id, map_id = "siteplot"){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    ## composed module for selecting a site or sites from the coleo database
    
    rcoleo_sites_sf <- rcoleo::download_sites_sf(token = rcoleo:::bearer())
    
    sites_subset <- reactive({
      mapselector::subset_site_df(downloaded_sites = rcoleo_sites_sf,
                                  campaign_type = input$camp_types_sel)
    })
    
    # or could be passing the map_id in..
    output[[map_id]] <- leaflet::renderLeaflet(make_leaflet_empty())
    
    observeEvent(
      sites_subset(),
      update_subset_sites(sites_subset(), map_id))
    
    return(list(
      camps = reactive(input$camp_types_sel),
      click = reactive(input[[paste0(map_id, "_marker_click")]]$id)
      ))
    
  })
}
    
## To be copied in the UI
# mod_map_campaign_type_ui("map_campaign_type_ui_1")
    
## To be copied in the server
# mod_map_campaign_type_server("map_campaign_type_ui_1")


# test function
testapp_map_campaign_type <- function(){
  ui <- fluidPage(
    fa_dependency(),
    mod_map_campaign_type_ui("ff"),
    textOutput("what"),
    textOutput("where"),
    leaflet::leafletOutput(NS("ff", "wow_its_a_map"))
  )
  
  server <-  function(input, output, session) {
    # output[[NS("ff", "wow_its_a_map")]] <- leaflet::renderLeaflet(make_leaflet_empty())
    out <- mod_map_campaign_type_server("ff", map_id = "wow_its_a_map")
    
    outtext <- reactive(paste("you just selected", paste(out$camps(), collapse = " ")))
    outclik <- reactive(paste("you just clicked the site", out$click()))
    output$what <- renderText(outtext())
    output$where <- renderText(outclik())
  }
  shinyApp(ui, server)
}
