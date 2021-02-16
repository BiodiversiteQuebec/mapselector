
    
#' modal_make Server Functions
#'
#' @noRd 
#' @export
mod_modal_make_server <- function(id, 
                                  region = reactive("this region"),
                                  title_format_pattern,
                                  ...){
  if (missing(title_format_pattern) | !is.character(title_format_pattern)) stop("Please provide a title for the modal")
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observe({
      if (!is.null( region())) {
        showModal(
          modal_tab_format(
            # first argument to modal_tab_format is the region selected on the map
            region(),
            # the second is a format string for the title of the modal, see ?sprintf
            title_fmt = title_format_pattern,
            ...
          ))
      }
    })
  })
}

#' @export
mod_modal_observeEvent_ui <- function(id, button_text, ...){
  ns <- NS(id)
  actionButton(ns("open_modal"), button_text, ...)
}

#' modal_make Server Functions
#'

#' @noRd 
#' @export
mod_modal_observeEvent_server <- function(id, 
                                  title_format_pattern,
                                  title_var = reactive("the title"),
                                  ...,
                                  type = "tabs"){
  if (missing(title_format_pattern) | !is.character(title_format_pattern)) stop("Please provide a title for the modal")
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observeEvent(
      # this refers to the input element named ns("open_modal") from above
      input$open_modal, {
        showModal(
          modal_tab_format(
            # first argument to modal_tab_format is the region selected on the map
            title_var(),
            # the second is a format string for the title of the modal, see ?sprintf
            title_fmt = title_format_pattern, 
            ..., type = type
          ))
      }
    )
  }
  )
}



## To be copied in the UI
# mod_modal_make_ui("modal_make_ui_1")
    
## To be copied in the server
# mod_modal_make_server("modal_make_ui_1")



testapp_observe2 <- function(){
  ui <- fluidPage(
    mod_modal_observeEvent_ui("ff", button_text = "button txt")
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


testapp_observe2()


# another way to work with mod_modal_observeEvent_ui, but this time opening a tutorial!

#' @noRd 
#' @export
mod_modal_observeEvent_tutorial_server <- function(id, 
                                                   title_text,
                                                   md_file,
                                                   second_button = NULL){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    observeEvent(
      # this refers to the input element named ns("open_modal") from above
      input$open_modal, {
        showModal(
          # the second is a format string for the title of the modal, see ?sprintf
          modalDialog(title = title_text,
                      includeMarkdown(md_file),
                      footer = tagList(
                        span(
                          modalButton("Passer l'introduction"),
                          style = "position:relative; float:left;"
                        ),
                        second_button
                      )
          )
        )
      }
    )
  }
  )
}


mod_modal_helpbutton_ui <- function(id, button_text, ...){
  ns <- NS(id)
  tags$sup(
    shinyWidgets::circleButton(inputId = ns("open_modal"),
                               label = "",
                               icon = icon("info"),
                               size = "xs",
                               status = "primary")
    )
  
  # wrap in div with class and text??? div(style = "font-size:25px; text-align:center",
  # "Diversité des indicateurs",...)
}


