#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function( input, output, session ){
  # Your application server logic 
  # mod_map_select_server("map_select_ui_1")
  output$map <- leaflet::renderLeaflet(make_leaflet_map())
  chosen_region <- reactive({input$map_shape_click$id})
  mod_modal_make_server("modal_make_ui_1", 
                        # this reactive value is passed inside the module
                        # note you but the reactive value here, not its value, 
                        # which you would get with chosen_region()
                        region = chosen_region,
                        # here place all the tabs you want in your final modal! 
                        ## this can be a function which returns a reactive output (e.g. renderPlotly)
                        tabPanel(title = "Visualization",
                                 # see mapselector::ipso_zoo for an example
                                 ipso_zoo(color = I("red"))
                                 ),
                        ## could also be html elements
                        tabPanel(title = "C'est un tab",
                                 div("Bien sur c'est un tab")),
                        ## can also (probably should?) include a reactive input from the selected map region
                        tabPanel(title = "ou suis-je",
                                 renderText({paste("tu est sur", chosen_region())})
                        )
                        )
}
