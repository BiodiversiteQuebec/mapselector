dataModal <- function(region, vis_function = ipso_zoo){
  modalDialog(
    h3(region),
    tabsetPanel(type = "tabs",
                tabPanel("Visualisation",
                         vis_function()
                         ),
                tabPanel("Données",div("Données ici"))
    )
  )
}

ipso_zoo <- function(){
  plotly::renderPlotly(
    plotly::plot_ly(
      x = c("giraffes", "orangutans", "monkeys"),
      y = runif(3)*10,
      name = "Espèce dominante",
      type = "bar"
    )
  )
}