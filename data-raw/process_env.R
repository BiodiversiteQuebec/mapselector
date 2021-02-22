## processing meteo data

library(tidyverse)

filenames <- dir("data-raw/data_meteo_cells/", full.names = TRUE) %>% 
  set_names(nm = basename(.))


# might separate precip and temp


filenames %>% keep(str_detect, pattern = "Temperature")


meteo_df <- filenames  %>%
  keep(str_detect, pattern = "Precipitation") %>%  
  map_df(read_csv, .id = "fn", skip = 1)

meteo_var <- meteo_df %>% 
  separate(fn, into = c("nn", "var"), sep = "-", extra = "drop")


meteo_precipitation_ECMWF <- meteo_var %>% 
  mutate(Month = factor(Month,
                        levels = c("Jan", "Feb", "Mar", "Apr",
                                   "May", "Jun", "Jul", "Aug", "Sep", 
                                   "Oct", "Nov", "Dec"))) %>% 
  select(-var) %>% 
  rename(total_mm = Sum)


# export precip -----------------------------------------------------------


usethis::use_data(meteo_precipitation_ECMWF)

# a polar plot for the precipitation. 
wet <- meteo_precipitation_ECMWF %>% #pull("Month") %>% as.numeric()
  ggplot(aes(x = Month, y = total_mm, group = nn)) + 
  geom_polygon(fill = NA, col = "black")+
  coord_polar(start = -pi * 1/12)



# same but temperature ------------------



temper_df <- filenames  %>%
  keep(str_detect, pattern = "Temperature") %>%  
  map_df(read_csv, .id = "fn", skip = 1)

temper_var <- temper_df %>% 
  separate(fn, into = c("nn", "var"), sep = "-", extra = "drop")


mean_temperature <- temper_var %>% 
  mutate(Month = factor(Month,
                        levels = c("Jan", "Feb", "Mar", "Apr",
                                   "May", "Jun", "Jul", "Aug", "Sep", 
                                   "Oct", "Nov", "Dec"))) %>% 
  select(-var) %>% 
  rename(mean_deg_C = Average)



# export temp -------------------------------------------------------------

usethis::use_data(mean_temperature)


# side by side, ggplotly

hot <- mean_temperature %>% ggplot(aes(x = Month, y = mean_deg_C, group = nn)) + 
  geom_polygon(fill = NA, col = "black")+
  coord_polar(start = -pi * 1/12)


library(patchwork)

wet+labs(title = "Precipitation", y = "mm") + 
  hot+labs(title = "Temperature", y = "Degres C")



# do these match the site ids or something?? ------------------------------

sites <- rcoleo::get_sites()

# yes
as.character(unique(mean_temperature$nn)) %in% unique(sites[[1]]$body[[1]]$cell_id)
