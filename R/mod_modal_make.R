
    
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
    if(!is.null( region() )){
      showModal(dataModal( region() ,  vis_function = data_vis_function, ...))
    }
    })
  })
}
    
## To be copied in the UI
# mod_modal_make_ui("modal_make_ui_1")
    
## To be copied in the server
# mod_modal_make_server("modal_make_ui_1")
