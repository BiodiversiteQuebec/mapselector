
    
#' modal_make Server Functions
#'
#' @noRd 
#' @export
mod_modal_make_server <- function(id, 
                                  region = reactive("this region"),
                                  ...){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observe({
    if (!is.null( region())) {
      showModal(
        dataModal(
          # first argument to dataModal is the region selected on the map
          region(),
          ...
          ))
    }
    })
  })
}
    
## To be copied in the UI
# mod_modal_make_ui("modal_make_ui_1")
    
## To be copied in the server
# mod_modal_make_server("modal_make_ui_1")
