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
    leaflet::leafletOutput(ns("map"))
  )
}
    
#' map_select Server Functions
#'
#' @noRd 
#' @export
mod_map_select_server <- function(id,
                                  what_to_click = "shape",
                                  fun = make_leaflet_map, ...){
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

datasetApp <- function(filter = NULL) {
  ui <- fluidPage(
    mod_map_select_ui("testmap"),
    textOutput("u_clicked")
  )
  server <- function(input, output, session) {
    got_clicked <- mod_map_select_server("testmap",
                                         mapdata = mapselector::CERQ,
                                         label = TRUE,
                                         region_name = "NOM_PROV_N")
    output$u_clicked <- renderText(got_clicked())
    
    mod_modal_make_server("modal_make_ui_1",
                          region = got_clicked, 
                          title_format_pattern = "what's up %s",
                          tabPanel(title = "ou suis-je",
                                   renderText({paste("tu est sur", got_clicked())})
                          ))
  }
  shinyApp(ui, server)
}
datasetApp()


# should a module affect the `output` directly? or should it just return reactive values??

# select by name the region from the map, in the input list??
