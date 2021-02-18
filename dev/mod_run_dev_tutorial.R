# Detach all loaded packages and clean your environment
golem::detach_all_attached()
# rm(list=ls(all.names = TRUE))

# Document and reload your package
golem::document_and_reload()

# https://shiny.rstudio.com/articles/modules.html

library(shiny)

options(shiny.reactlog = TRUE)


if (FALSE) {
  
  mapselector:::testapp_observe_tuto()
  
  
  mapselector:::testapp_observation_display()
  
}