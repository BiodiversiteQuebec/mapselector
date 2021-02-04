
    
#' modal_make Server Functions
#'
#' @noRd 
#' @export
mod_modal_make_server <- function(id, 
                                  region = reactive("this region"),
                                  title_format_pattern,
                                  ...){
  if(missing(title_format_pattern) | !is.character(title_format_pattern)) stop("Please provide a title for the modal")
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observe({
    if (!is.null( region())) {
      showModal(
        modal_tab_format(
          # first argument to modal_tab_format is the region selected on the map
          region(),
          # the second is a format string for the title of the modal, see ?sprintf
          title_fmt = title_format_pattern,
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
