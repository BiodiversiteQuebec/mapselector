
#' Format modal tabs
#'
#' This function is a wrapper around modal tabs. It does two things. first, it
#' sets the title for the whole modal. Its assumed that this is going to be
#' based on the id of the thing you clicked on the map. Second, it formats the
#' modals' CSS: it applies nice CSS classes to all tabs and wraps them in modalDialog.
#' 
#' @param region this is a character value, probably from a reactive value
#' @param title_fmt is a format for the modal title
#'
#' @export
modal_tab_format <- function(region, title_fmt, ...){
  
  stopifnot(is.character(region))
  
  modaltitle <- sprintf(title_fmt, region)
  modalDialog(
    h3(modaltitle),
    add_class_tabs(prefix = "modaltab-", ...)
  )
}

#' @export
ipso_zoo <- function(...){
  
  plotly::renderPlotly(
    plotly::plot_ly(
      x = c("giraffes", "orangutans", "monkeys"),
      y = runif(3)*10,
      name = "Espèce dominante",
      type = "bar",
      ...
    )
  )
}