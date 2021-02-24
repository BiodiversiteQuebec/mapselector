
    
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


#' Open a tutorial modal
#' 
#' requires a text to open to be placed in inst/app/www
#' 
#' @param id 
#' @param title_text Title for the modal that pops up
#' @param md_file file name, not path
#' @param button_text what the button says
#' @param second_button do you want this modal to open a second? default NULL
#'
#' @noRd 
#' @export
mod_modal_observeEvent_tutorial_server <- function(id, 
                                                   title_text,
                                                   md_file,
                                                   button_text = "Fermer",
                                                   second_button = NULL){
  moduleServer( id, function(input, output, session){
    ns <- session$ns
    
    f <- here::here("inst", "app", "www", md_file)
    stopifnot(file.exists(f))
    
    
    observeEvent(
      # this refers to the input element named ns("open_modal") from above
      input$open_modal, {
        showModal(
          # the second is a format string for the title of the modal, see ?sprintf
          modalDialog(title = title_text,
                      includeMarkdown(f),
                      footer = tagList(
                        span(
                          modalButton(button_text),
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

#
#' make a modal help button
#' 
#' this function takes some text and makes a little help button appear next to it.
#'
#' @param id id for the module. match it to the module that makes the modal
#' @param text_before_button the text that should be followed by the "i" for information.
#'
#' @return
#' @export
#'
# @examples
mod_modal_helpbutton_ui <- function(id, text_before_button){
  ns <- NS(id)
  
  tags$span(
    text_before_button,
    tags$sup(
      shinyWidgets::circleButton(inputId = ns("open_modal"),
                                 label = "",
                                 icon = icon("info"),
                                 size = "xs",
                                 status = "primary")
    )
  )
  
  # wrap in div with class and text??? div(style = "font-size:25px; text-align:center",
  # "Diversité des indicateurs",...)
}



# test function
testapp_observe_tuto <- function(){
  ui <- fluidPage(
    mod_modal_observeEvent_ui("ff", "button")
  )
  
  server <-  function(input, output, session) {
    mod_modal_observeEvent_tutorial_server("ff",
                                           title_text = "its a modal",
                                           button_text = "Fermer",
                                           second_button = NULL,
                                           md_file = "demo_help.md")
  }
  shinyApp(ui, server)
}

