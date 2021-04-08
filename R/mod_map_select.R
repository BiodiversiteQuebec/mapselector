#' map_select UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#' @importFrom shiny NS tagList 
#' @export
mod_map_select_ui <- function(id){
  ns <- NS(id)
  tagList(
    leaflet::leafletOutput(ns("map"))
  )
}
    
#' Make a leaflet map with a reactive output
#'
#' This module is meant to help us make leaflet maps and output a reactive
#' value. This value can be used to trigger a modal and also it's contents.
#'
#' @param id this is the modal id string. It has to match the ui function. If
#'   you make a second map, use a different one
#' @param what_to_click either "shape" for a region map or "marker" for a site
#'   map
#' @param fun this is a function that makes a map; you might write this yourself
#'   or you might use one of the built in ones for sites (plot_rcoleo_sites)
#'   blank (make_leaflet_empty) or regions (make_leaflet_map)
#' @param \dots{...} additional arguments to fun
#'
#' @importFrom magrittr %>%
#' @export
mod_map_select_server <- function(id,
                                  what_to_click = "shape",
                                  fun = make_leaflet_map, ...){
  
  stopifnot(is.function(fun))
  
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    # remember this name, "map" will be namespaced!! 
    output$map <- leaflet::renderLeaflet(
      fun(...)
    )
    
    # so you can get it with just `map_shape_click`
    ## gotta make it reactive to trace the connection
    reactive({input[[paste("map", what_to_click, "click", sep = "_")]]$id})
    # 
  })
}
    
## To be copied in the UI
# mod_map_select_ui("map_select_ui_1")
    
## To be copied in the server
# mod_map_select_server("map_select_ui_1")

trialApp <- function(filter = NULL) {
  ui <- fluidPage(
    mod_map_select_ui("testmap"),
    textOutput("u_clicked")
  )
  server <- function(input, output, session) {
    got_clicked <- mod_map_select_server("testmap",
                                         mapdata = mapselector::CERQ,
                                         label = TRUE,
                                         region_name = "NOM_PROV_N")
    
    
    mod_modal_interactive_server("norm")
    
    mod_modal_make_server("modal_make_ui_1",
                          region = got_clicked, 
                          title_format_pattern = "what's up %s",
                          tabPanel(title = "ou suis-je",
                                   renderText({
                                     paste("tu est sur", 
                                           got_clicked()
                                     )})
                          ),
                          tabPanel(title = "a stastic",{
                            mod_modal_interactive_ui("norm")
                          }))
  }
  shinyApp(ui, server)
}
trialApp()


# should a module affect the `output` directly? or should it just return reactive values??

# select by name the region from the map, in the input list??

# TODO add the controls to the map and ALSO extract those instructions from the map module



# test functions to make sure the badges plot -----------------------------

small_ui <- function(request) {
  tagList(
    tableau_de_bord(
      dash_title(title = "Explorateur des sites"), 
      dash_sidebar(
        badge(text_badge = "Voila un survol"),
        tableOutput("sel")
      ), 
      dash_tabs(
        #maybe a little strange, but here we pass in the UI of a modal and the id that defines it.
        tab_map(title = "Site Map", id = "bat_map", outputFunction = mod_map_select_ui)
      )
    )
  )
}  

#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @import mapselector
#' @importFrom magrittr %>%
#' @noRd
small_server <- function(input, output, session) {
  
  downloaded_sites <- rcoleo::download_sites_sf()
  
  selsite <- mod_map_select_server("bat_map",
                                   what_to_click = "marker",
                                   fun = plot_rcoleo_sites,
                                   rcoleo_sites_sf = downloaded_sites)
  
  
  ff <- reactive({mapselector::get_subset_site(site = downloaded_sites,
                                               site_code_sel = selsite())})
  
  output$sel <- renderTable(head(ff()))
}


smallapp <- function(){
  shinyApp(
    ui = small_ui,
    server = small_server)
}
