

copy_mapselector_app_ui <- function(destfile = "R/app_ui.R"){
  download.file("https://raw.githubusercontent.com/ReseauBiodiversiteQuebec/mapselector/main/R/app_ui.R",
                destfile = destfile)
}



copy_mapselector_app_server <- function(destfile = "R/app_server.R"){
  download.file("https://raw.githubusercontent.com/ReseauBiodiversiteQuebec/mapselector/main/R/app_server.R",
                destfile = destfile)
}
