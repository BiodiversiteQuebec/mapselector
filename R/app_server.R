#' The application server-side
#' 
#' @param input,output,session Internal parameters for {shiny}. 
#'     DO NOT REMOVE.
#' @import shiny
#' @importFrom magrittr %>%
#' @noRd
app_server <- function( input, output, session ){
  # Your application server logic 
  
  # help functions and modals
  mod_modal_observeEvent_tutorial_server("info1",
                                         title_text = "title for help",
                                         md_file = "demo_help.md")
                                         
  # make a map of your own
  # needs and id
  got_clicked <- mod_map_select_server("map",what_to_click = "shape",
                                       fun = make_leaflet_map,
                                       # these are arguments to make_leaflet_map
                                       mapdata = mapselector::CERQ,
                                       label = TRUE,
                                       region_name = "NOM_PROV_N")
  
  downloaded_sites <- rcoleo::download_sites_sf()
  
  
  got_clicked_site <- mod_map_select_server("sitemap",
                                            what_to_click = "marker", 
                                            fun = plot_rcoleo_sites,
                                            rcoleo_sites_sf = downloaded_sites)
  
  
  got_clicked_our <- mod_map_select_server("ouranous_map",what_to_click = "shape",
                        fun = make_leaflet_map,
                        # these are arguments to make_leaflet_map
                        mapdata = mapselector::regions_simplified_Ouranos,
                        label = TRUE,
                        region_name = "Region")
  
  mod_modal_make_server("modal_make_ui_1", 
                        # this reactive value is passed inside the module
                        # note you but the reactive value here, not its value, 
                        # which you would get with chosen_region()
                        region = got_clicked,
                        # give the title that you want for the modal
                        title_format_pattern = "Visualization for %s",
                        # here place all the tabs you want in your final modal! 
                        ## this can be a function which returns a reactive output (e.g. renderPlotly)
                        tabPanel(title = "Visualization",
                                 # see mapselector::ipso_zoo for an example
                                 ipso_zoo(color = I("red"))
                        ),
                        ## could also be html elements
                        tabPanel(title = "C'est un tab",
                                 div("Bien sur c'est un tab")),
                        ## can also (probably should?) include a reactive input from the selected map region.
                        ## NOTE that if you use a render function here, in tabpanel, pass in the value (use parentheses) 
                        ### but if you write a function with a render function _inside_ pass in the reactive itself (no parentheses)
                        tabPanel(title = "ou suis-je",
                                 renderText({paste("tu est sur", got_clicked())})
                        )
                        )
  
  mod_observation_display_server("siteobs", 
                                 site = downloaded_sites, 
                                 region = got_clicked_site)
  
  mod_modal_make_server("modal_make_ui_1", 
                        # this reactive value is passed inside the module
                        # note you but the reactive value here, not its value, 
                        # which you would get with chosen_region()
                        region = got_clicked_site,
                        # give the title that you want for the modal
                        title_format_pattern = "Visualization for %s",
                        tabPanel(title = "ou suis-je",
                                 renderText({paste("tu est sur", got_clicked_site())})
                        ),
                        tabPanel(title = "Observations",
                                 mod_observation_display_ui("siteobs")
                                 )
  )
  
  mod_ouranous_display_server("projection", got_clicked_our)
  
  mod_modal_make_server("modal_our",
                        region = got_clicked_our,
                        title_format_pattern = "Climate projection for %s",
                        tabPanel(title = "Ouranous",
                                 mod_ouranous_display_ui("projection")))
}
