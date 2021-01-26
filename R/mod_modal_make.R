
    
#' modal_make Server Functions
#'
#' @noRd 
#' @export
mod_modal_make_server <- function(id, 
                                  region = reactive("this region"),
                                  data_vis_function = ipso_zoo,
                                  ...){
  # here, name the function that you are using to visualize your data
  # then pass in the other arguments via the dots
  force(data_vis_function)
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observe({
    if (!is.null( region())) {
      showModal(
        dataModal(
          # first argument to dataModal is the region selected on the map
          region(), 
          # here place all the tabs you want in your final modal! 
          ## this can be a function which returns a reactive output (e.g. renderPlotly)
          tabPanel(title = "Visualization",
                   # see mapselector::ipso_zoo for an example
                   ipso_zoo(color = I("red"))),
          ## could also be html elements
          tabPanel(title = "C'est un tab",
                   div("Bien sur c'est un tab")),
          ## can also (probably should?) include a reactive input from region()
          tabPanel(title = "ou suis-je",
                   renderText(paste("tu est sur", region()))
                   )
          ))
    }
    })
  })
}
    
## To be copied in the UI
# mod_modal_make_ui("modal_make_ui_1")
    
## To be copied in the server
# mod_modal_make_server("modal_make_ui_1")
