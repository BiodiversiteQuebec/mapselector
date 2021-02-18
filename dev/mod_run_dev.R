# Detach all loaded packages and clean your environment
golem::detach_all_attached()
# rm(list=ls(all.names = TRUE))

# Document and reload your package
golem::document_and_reload()

# https://shiny.rstudio.com/articles/modules.html

library(shiny)

options(shiny.reactlog=TRUE)

testapp_observe_vis <- function(){
  ui <- fluidPage(
    mod_modal_observeEvent_ui("ff", "button")
  )
  
  server <-  function(input, output, session) {
    mod_modal_observeEvent_server("ff",
                                  title_format_pattern = "its a modal! for %s",
                                  title_var = reactive("All Animals"),
                                  tabPanel(title = "Visualization",
                                           # see mapselector::ipso_zoo for an example
                                           ipso_zoo(color = I("red")))
    )
  }
  shinyApp(ui, server)
}


testapp_observe_vis()