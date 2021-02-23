## read in the ouranos data

library(tidyverse)

# ouranos metadata -- inferred from reading Claire's script in tableau-explo-sites
# rcp45 and rcp 85 are actually the minimum and maximum of predictions -- not different scenarios

# get ouranos data
filenames <- dir("data-raw/data_ouranos/", full.names = TRUE, pattern = "csv$") %>% 
  set_names(nm = basename(.))

# read in all the files
ff <- filenames %>%# head %>%
  map_df(read_csv,.id = "fn",col_types = cols(
    Annee = col_double(),
    Obs = col_double(),
    `Hist-Min` = col_double(),
    `Hist-Max` = col_double(),
    `rcp45-Min` = col_double(),
    `rcp45-Avg` = col_double(),
    `rcp45-Max` = col_double(),
    `rcp85-Min` = col_double(),
    `rcp85-Avg` = col_double(),
    `rcp85-Max` = col_double()
  ))


# split up the location and variable names
separate_names <- ff %>% 
  separate(fn, into = c("region", "var"),
           sep = "-Moyenne annuelle des |-Total annuel des ") %>% 
  mutate(var = var %>% str_replace(" .csv", ""))



# splitting and cleaning data ---------------------------------------------

# visualize what is missing
separate_names %>% 
  filter(var %>% str_detect("tation"))
visdat::vis_dat()

# precip??


visdat::vis_dat(separate_names)

separate_names %>% head(1000) %>% 
  visdat::vis_dat(.)

separate_names %>% slice(62:67) %>% visdat::vis_dat(.)
# ok so observations stop at 2014



# ouranos observations ---------------------------------------------------

# create one table just for observations -- drop any that don't have an "obs" value
ouranos_observed <- separate_names %>% 
  select(region:`Hist-Max`) %>% 
  filter(!is.na(Obs))

ouranos_observed %>% glimpse %>% 
  ggplot(aes(x = Annee, 
             y = Obs, 
             ymin = `Hist-Min`, 
             ymax = `Hist-Max`,
             group = region)) + 
  geom_line(alpha = 0.4) + geom_ribbon(alpha = 0.1)+
  facet_wrap(~var, scales = "free_y")


usethis::use_data(ouranos_observed)


# ouranos rcp ------------------------------------------------------------


# now look at the rcp values separately
ouranos_rcp <- separate_names %>% 
  filter(!is.na(`rcp45-Min`)) %>% 
  select(region, var, Annee, `rcp45-Min`:`rcp85-Max`) %>% 
  pivot_longer(`rcp45-Min`:`rcp85-Max`) %>% 
  separate(name, into = c("rcp", "v")) %>% 
  pivot_wider(names_from = v, values_from = value)


project_plot <- ouranos_rcp %>% 
  filter(str_detect(var, "temp"), str_detect(region, "Abi")) %>%
  ggplot(aes(x = Annee, y = Avg, colour = rcp, fill = rcp,  ymin = Min, ymax = Max)) + 
  geom_line() + facet_wrap(~region) + geom_ribbon(alpha = 0.1)

project_plot + 
  geom_line(aes(x = Annee, y = Obs),inherit.aes = FALSE, data = obs_data %>% 
              filter(str_detect(var, "temp"), str_detect(region, "Abi")))


usethis::use_data(ouranos_rcp)

# ouranos regions --------------------------------------------------------


# do I need to do something with the geojson from ouranos??? probably 

regions_simplified_Ouranos <- geojsonio::geojson_sf("data-raw//data_ouranos/regions_simplified_Ouranos.geojson") 

library(leaflet)
leaflet(regions_simplified_Ouranos) %>% 
  addTiles() %>% # Affichage du fond de carte
  addPolygons(color = "darkblue")

usethis::use_data(regions_simplified_Ouranos)
              
