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
mod_campaign_type_checkbox <- function(id, start_sel = c("acoustique", "odonates")){
  ns <- NS(id)
  tagList(
    checkboxGroupInput(ns("selected_campaigns"),
                       label = "Quel types de campaigns?",
                       choices = c(
                         "végétation", "papilionidés", "acoustique", "insectes_sol", 
                         "mammifères", "odonates", "zooplancton"),
                       selected = start_sel)
  )
}
 
#' @export
mod_campaign_type_map_plot <- function(id){
  ns <- NS(id)
  tagList(
    leaflet::leafletOutput(ns("map"))
  )
}
   
#' map_campaign_type Server Functions
#'
#' @noRd 
#' @export
mod_campaign_type_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    ## composed module for selecting a site or sites from the coleo database
    
    rcoleo_sites_sf <- rcoleo::download_sites_sf(token = rcoleo:::bearer())
    
    sites_subset <- reactive({
      mapselector::subset_site_df(downloaded_sites = rcoleo_sites_sf,
                                  campaign_type = input$selected_campaigns)
    })
    
    # or could be passing the map_id in..
    output$map <- leaflet::renderLeaflet(make_leaflet_empty())
    
    # this works because update_subset_sites calls leafletProxy, which 
    # knows that it is inside a module and adds the module id
    observeEvent(
      sites_subset(),
      update_subset_sites(sites_subset(), "map"))
    
    react <- reactiveValues(click = NULL, id = "mapclick")

    observeEvent(input$map_marker_click,{
      react$click <- input$map_marker_click$id
    })
    
    ## if different campaigns are selected, then set map_marker_click to NULL
    
    observeEvent(input$selected_campaigns,{
      react$click <- NULL})
    
    ## if 
    
    
    # get the observations from the clicked site
    clicked_site_data <- reactive({
      # do nothing till user clicks!
      req(react$click)
      mapselector::get_subset_site(
        site = sites_subset(),
        site_code_sel = react$click)
    })
    
    return(list(
      camps = reactive(input$selected_campaigns),
      click = reactive(react$click),
      stdat = clicked_site_data
      ))
    
  })
}
    
## To be copied in the UI
# mod_map_campaign_type_ui("map_campaign_type_ui_1")
    
## To be copied in the server
# mod_map_campaign_type_server("map_campaign_type_ui_1")

