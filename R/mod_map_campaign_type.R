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
mod_campaign_type_checkbox <- function(id#, start_sel = c("acoustique", "odonates")
                                       ){
  ns <- NS(id)
  tagList(
    checkboxGroupInput(ns("selected_campaigns"),
                       label = "Quel types de campaigns?",
                       choices = c(
                         "végétation", "papilionidés", "acoustique", "insectes_sol", 
                         "mammifères", "odonates", "zooplancton"),
                        selected = c(
                       "végétation", "papilionidés", "acoustique", "insectes_sol", 
                       "mammifères", "odonates", "zooplancton")
                       )
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
    
    rcoleo_sites_sf_raw <- rcoleo::download_sites_sf(token = rcoleo:::bearer())
    
    rcoleo_sites_sf <- drop_empty_campaigns(rcoleo_sites_sf_raw)
    
    sites_subset <- reactive({
      mapselector::subset_site_df(downloaded_sites = rcoleo_sites_sf,
                                  campaign_type = input$selected_campaigns)
    })
    
    # make a blank map
    output$map <- leaflet::renderLeaflet(make_leaflet_empty())
    
    # update this map with the markers defined in the filtered data.frame
    # this works because update_subset_sites calls leafletProxy, which 
    # knows that it is inside a module and adds the module id
    observeEvent(
      sites_subset(),
      update_subset_sites(sites_subset(), "map"))
    
    # create a reactive val to catch the id of the site you click on
    react <- reactiveValues(click = NULL)

    observeEvent(input$map_marker_click,{
      react$click <- input$map_marker_click$id
    })
    
    ## if different campaigns are selected, then set react$click to NULL 
    
    observeEvent(input$selected_campaigns,{
      react$click <- NULL})
    
    ## rework to also set to NULL when you click off the modal?
    
    # set back to NULL with timed invalidation?
    timer <- reactiveTimer(500)
    
    observe({ 
      timer
      react$click <- NULL})
    
    
    # get the observations from the clicked site
    # this part could be anything -- could even simply be looking up the display name
    
    clicked_site_data <- eventReactive(
      # do nothing till user clicks!
      input$map_marker_click, {
        mapselector::get_subset_site(
          site = sites_subset(),
          site_code_sel = react$click)
      }
    )

    
    
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

