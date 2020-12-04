title_row <- function(title = "Analyse de raréfaction"){
  fillRow(
    flex=c(3,1,1),
    fillCol(
      tags$div(
        class="left-header",
        tags$div(class = "logo", 
                 tags$img(src ="www/coleo_test_small.png",
                          height="70px")),
        tags$div(class="dash-title", title)
      ),
      hover="Coléo"),
    height="7vh")
}


sidebar_row <- function(){
  fillCol(id="sidebar",
          tags$div(
            tags$div(
              id="closebtn-div",
              tags$a(href="javascript:void(0)",
                     id="closebtn",'<')),
            tags$div(
              class="blue-badge",
              "Ce tableau de bord vise à tester les modèles de tableau de bord. "),
            tags$div(class="widget-div",
                     sliderInput("obs",
                                 "Nombre d'observations:",
                                 min = 0,
                                 max = 1000,
                                 value = 500
                     ))
          ))
}

tab_bigvis <- function(title = "Map", outputFunction = leaflet::leafletOutput, id = "map"){
  tabPanel(title,
           outputFunction(id,
                          height="90vh",
                          width="80vw"))
}

tab_gen <- function(title = "Data download", outputFunction = downloadButton, id = "DL_data"){
  tabPanel(title,
           outputFunction(id))
}
