#' observation_display UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#'
#' @noRd 
#'
#' @importFrom shiny NS tagList 
#' @export
mod_ouranous_display_ui <- function(id){
  ns <- NS(id)
  tagList(
    tags$div(
      plotly::plotlyOutput((ns("plot")))
    )
  )
}
    
#' observation_display Server Functions
#'
#' @noRd 
#' @export
mod_ouranous_display_server <- function(id, region){
  assertthat::assert_that(shiny::is.reactive(region))
  
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    output$plot = plotly::renderPlotly(plotly::ggplotly(
      plot_ouranous_one_region(reg = region()))
      )
  })
}




subset_our <- function(dd, reg){
  subset(dd, dd$region == reg)
}

#' @export
plot_ouranous_one_region <- function(reg){
  project_plot <- subset_our(mapselector::ouranous_rcp, reg) %>%
    ggplot2::ggplot(ggplot2::aes(x = Annee, y = Avg, colour = rcp, fill = rcp,  ymin = Min, ymax = Max)) + 
    ggplot2::geom_line() + 
    ggplot2::facet_wrap(~var, scales = "free") + 
    ggplot2::geom_ribbon(alpha = 0.1)
  
  project_plot + 
    ggplot2::geom_line(ggplot2::aes(x = Annee, y = Obs),inherit.aes = FALSE, 
              data = subset_our(mapselector::ouranous_observed, reg))
}

    
## To be copied in the UI
# mod_observation_display_ui("observation_display_ui_1")
    
## To be copied in the server
# mod_observation_display_server("observation_display_ui_1")

# testing function
testapp_ouranous_display <- function(){
  ui <- fluidPage(
    mod_ouranous_display_ui("observation_display_ui_1")
  )
  
  server <-  function(input, output, session) {
    
    mod_ouranous_display_server("observation_display_ui_1", 
                                   region = reactive("Abitibi-Témiscamingue"))
  }
  shinyApp(ui, server)
}

testapp_ouranous_display()
