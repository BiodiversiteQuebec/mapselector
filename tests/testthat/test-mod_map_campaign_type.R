test_that("mod_campaign_type module works", {
  skip_if_not(interactive())
  
  # test function
  testapp_map_campaign_type <- function(){
    ui <- shiny::fluidPage(
      fa_dependency(),
      mod_campaign_type_checkbox("ff"),
      shiny::textOutput("what"),
      shiny::textOutput("where"),
      shiny::tableOutput("how_many"),
      mod_campaign_type_map_plot("ff")
    )
    
    server <-  function(input, output, session) {
      
      out <- mod_campaign_type_server("ff")
      
      outtext <- reactive(paste("you just selected", paste(out$camps(), collapse = " ")))
      outclik <- reactive(paste("you just clicked the site", out$click()))
      outobvs <- reactive({
        req(out$stdat)
        out$stdat()[c("obs_species.taxa_name", 
                      "obs_species.value")]
      })
      output$what <- renderText(outtext())
      output$where <- renderText(outclik())
      output$how_many <- renderTable(outobvs())
    }
    shiny::shinyApp(ui, server)
  }
  
  
  
  # reactlog::reactlog_enable()
  
  testapp_map_campaign_type()
  
  
})
