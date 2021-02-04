
#' @export
modal_tab_format <- function(region, title_fmt, ...){
  modaltitle <- sprintf(title_fmt, region)
  modalDialog(
    h3(modaltitle),
    add_class_tabs(suffix = "modaltab-", ...)
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