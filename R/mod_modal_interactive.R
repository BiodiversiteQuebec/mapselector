#' modal_interactive UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
mod_modal_interactive_ui <- function(id){
  ns <- NS(id)
  fluidRow(
    column(2,
           numericInput(ns("num"), "sample size", min = 100, max = 500, step = 50, value = 200),
           numericInput(ns("mean"), "Prior mean", value = 0),
           numericInput(ns("sd"), "Prior standard dev", value = 10)
    ),
    column(10,
           plotOutput(ns("prior_logit")),
           plotOutput(ns("prior_prob")),
           plotOutput(ns("prior_predict"))
           )
 
  )
}
    
#' modal_interactive Server Functions
#'
#' @noRd 
mod_modal_interactive_server <- function(id){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    prior_sim <- reactive(rnorm(mean = input$mean, sd = input$sd, n = input$num))
    output$prior_logit <- renderPlot({
      hist(prior_sim(), main = "Prior on logit scale")
    })
    output$prior_prob <- renderPlot({
      hist(plogis(prior_sim()), main = "Prior on probability scale")
    })
    
    prior_pred_sim <- reactive({
      rbinom(n = length(prior_sim()),
             size = 20,
             prob = plogis(prior_sim()))})
    
    output$prior_predict <- renderPlot({
      hist(prior_pred_sim(), main = "Prior predictions")
    })
    
    
 
  })
}

testapp <- function(){
  ui <- fluidPage(
    mod_modal_interactive_ui("norm")
  )
  
  server <-  function(input, output, session) {
    mod_modal_interactive_server("norm")
  }
  shinyApp(ui, server)
}

testapp()
    
## To be copied in the UI
# mod_modal_interactive_ui("modal_interactive_ui_1")
    
## To be copied in the server
# mod_modal_interactive_server("modal_interactive_ui_1")
