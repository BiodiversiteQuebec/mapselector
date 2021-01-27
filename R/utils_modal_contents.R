
#' @export
dataModal <- function(region, ...){
  modalDialog(
    h3(region),
    tabsetPanel(type = "tabs",...)
  )
}

ipso_zoo <- function(...){
  # browser()
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