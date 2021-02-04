#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom magrittr %>%
#' @noRd
app_server <- function( input, output, session ){
  # Your application server logic 
  output$map <- leaflet::renderLeaflet(make_leaflet_map() %>% 
                                        leaflet:: addControl(
                                           selectInput("Statut", 
                                                       label = "Statut", 
                                                       choices = list("Toutes les espèces" = 1, 
                                                                      "Abondantes"  = 2, 
                                                                      "Susceptibles" = 3,
                                                                      "Menacées" = 4,
                                                                      "Vulnérables" = 5
                                                       ))))
  chosen_region <- reactive({input$map_shape_click$id})
  mod_modal_make_server("modal_make_ui_1", 
                        # this reactive value is passed inside the module
                        # note you but the reactive value here, not its value, 
                        # which you would get with chosen_region()
                        region = chosen_region,
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
                                 renderText({paste("tu est sur", chosen_region())})
                        )
                        )
}
