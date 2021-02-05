#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom magrittr %>%
#' @noRd
app_server <- function( input, output, session ){
  # Your application server logic 
  
  got_clicked <- mod_map_select_server("map",what_to_click = "shape", fun = make_leaflet_map,
                                       # these are arguments to make_leaflet_map
                                       mapdata = mapselector::CERQ,
                                       label = TRUE,
                                       region_name = "NOM_PROV_N")
  
  mod_modal_make_server("modal_make_ui_1", 
                        # this reactive value is passed inside the module
                        # note you but the reactive value here, not its value, 
                        # which you would get with chosen_region()
                        region = got_clicked,
                        # give the title that you want for the modal
                        title_format_pattern = "Visualization for %s",
                        # here place all the tabs you want in your final modal! 
                        ## this can be a function which returns a reactive output (e.g. renderPlotly)
                        tabPanel(title = "Visualization",
                                 # see mapselector::ipso_zoo for an example
                                 ipso_zoo(color = I("red"))
                        ),
                        ## could also be html elements
                        tabPanel(title = "C'est un tab",
                                 div("Bien sur c'est un tab")),
                        ## can also (probably should?) include a reactive input from the selected map region.
                        ## NOTE that if you use a render function here, in tabpanel, pass in the value (use parentheses) 
                        ### but if you write a function with a render function _inside_ pass in the reactive itself (no parentheses)
                        tabPanel(title = "ou suis-je",
                                 renderText({paste("tu est sur", got_clicked())})
                        )
                        )
}
