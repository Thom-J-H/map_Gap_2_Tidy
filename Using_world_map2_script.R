
# Using world_map2 script version -----------------------------------------



# Libraries ---------------------------------------------------------------


library(tidyverse)
library(here)
library(visdat)





# Data --------------------------------------------------------------------

# our custom map data
load(here::here("data",
                "tidy_data", 
                "maps", 
                "world_map2_project.rda"))


# raw Global Studies dat from Gapminder.org
gni_percapita <- read_csv(here::here("data",
                                     "raw_data",                               
                                     "gnipercapita_ppp_current_international.csv") )

# raw Global Studies dat from Gapminder.org
water_access <- read_csv(here::here("data", 
                                    "raw_data",                               
                                    "at_least_basic_water_source_overall_access_percent.csv") )


# raw Global Studies dat from Gapminder.org
energy_capita <- read_csv(here::here("data",
                                     "raw_data",
                                     "energy_use_per_person.csv"))


# Energy Case Study -------------------------------------------------------

energy_capita  %>% vis_dat()

energy_capita  %>% glimpse()


setdiff(energy_capita$country,world_map2$country)

setdiff(world_map2$country, energy_capita$country) %>% 
  enframe(name = NULL, value ="diff")


energy_tidy <- energy_capita  %>%
  pivot_longer(cols = !country,
               names_to = "year",
               names_transform = list(year = as.integer),
               values_to = "energy")

energy_tidy  %>% vis_dat()

energy_tidy  %>% glimpse()

#
# ## This is our bad example
#

energy_tidy %>%
  filter(year == 2004) %>% 
  left_join(world_map2, by = "country") %>%
  ggplot(aes(x = long, 
             y = lat, 
             group = group, 
             label = country)) +
  geom_polygon(aes(fill = energy) )+
  scale_fill_viridis_c(option = "C") +
  labs(fill = "Energy Use\nPer Capita",
       title = "Gapminder Data: 2004") +
  theme_void()


#
# ## This is our good example: graceful failure
#


energy_tidy %>%
  filter(year == 2004) %>% 
  complete(country = world_map2$country, 
           fill = (list(energy = NA )) ) %>%
  left_join(world_map2, by = "country") %>%
  replace_na(list(year = 2004)) %>%
  ggplot(aes(x = long, 
             y = lat, 
             group = group, 
             label = country)) +
  geom_polygon(aes(fill = energy) )+
  scale_fill_viridis_c(option = "C") +
  labs(fill = "Energy Use\nPer Capita",
       title = "Gapminder Data: 2000") +
  theme_void()


#
# ## Easy interactivity & no Anart mapped
#


# Map data
enegry_dat_2004 <- energy_tidy %>%
  filter(year == 2004) %>% 
  complete(country = world_map2$country, 
           fill = (list(energy = NA )) ) %>%
  left_join(world_map2, by = "country") %>%
  replace_na(list(year = 2004))

# ggplot object
enegry_map_2004 <- enegry_dat_2004 %>%
  filter(code_3 != "ATA") %>%
  ggplot(aes(x = long, 
             y = lat, 
             group = group, 
             label = country)) +
  geom_polygon(aes(fill = energy) )+
  scale_fill_viridis_c(option = "C") +
  labs(fill = "",
       title = "Energy Use Per Capita (2004)") +
  theme_void()

# interactive version
plotly::ggplotly(enegry_map_2004)




# Water Acess Case Study --------------------------------------------------

water_access  %>% vis_dat()
water_access  %>% glimpse()


setdiff(water_access$country,world_map2$country)
setdiff(world_map2$country, water_access$country)  %>% 
  enframe(name = NULL, value ="diff")

## Tidy it
water_tidy <- water_access %>%
  pivot_longer(cols = !country,
               names_to = "year",
               names_transform = list(year = as.integer),
               values_to = "water")


water_tidy %>% 
  vis_dat()

water_tidy %>% 
  glimpse()

## Map data
water_dat_2010 <- water_tidy %>%
  filter(year == 2010) %>% 
  complete(country = world_map2$country, 
           fill = (list(water = NA )) ) %>%
  left_join(world_map2, by = "country") %>%
  replace_na(list(year = 2010))


## Plot Object
water_mpa_2010 <- water_dat_2010 %>%
  filter(code_3 != "ATA") %>%
  ggplot(aes(x = long, 
             y = lat, 
             group = group, 
             label = country)) +
  geom_polygon(aes(fill = water) )+
  scale_fill_viridis_c(option = "C") +
  labs(fill = "",
       title = "Basic Water Access (2010)") +
  theme_void()

# Basic plot
water_mpa_2010

# interactive
plotly::ggplotly(water_mpa_2010)




# GNI Per Capita PPP Case Study -------------------------------------------

gni_percapita %>% 
  vis_dat()

gni_percapita %>% 
  glimpse()


setdiff(gni_percapita$country, world_map2$country) %>% 
  enframe(name = NULL, value ="diff")

setdiff(world_map2$country, gni_percapita$country) %>% 
  enframe(name = NULL, value ="diff")


#
## Troubleshoot to TIDY
#


# convert char data to numeric 
gni_tidy <- gni_percapita %>%
  pivot_longer(cols = !country,
               names_to = "year",
               names_transform = list(year = as.integer),
               values_to = "gni_ppp_cap") %>%
  mutate(gni_ppp_cap = readr::parse_number(gni_ppp_cap) )%>%
  mutate(gni_ppp_cap = case_when(gni_ppp_cap < 200 ~ gni_ppp_cap * 1000,
                                 TRUE ~ gni_ppp_cap) )

# reconcile names
gni_tidy  <- gni_tidy %>%
  mutate( country = case_when(country == "Curaçao" ~ "Curacao",
                              country == "Sint Maarten (Dutch part)"  ~ "Sint Maarten" ,
                              TRUE ~ country) )


# Brief check
gni_tidy  %>% slice_min(gni_ppp_cap, n = 4)
gni_tidy %>% slice_max(gni_ppp_cap, n = 4)

setdiff(gni_tidy$country, world_map2$country)

gni_tidy %>%
  vis_dat()



## Map Data and Plot Object

gni_dat_2017 <- gni_tidy %>%
  filter(year == 2017) %>% 
  complete(country = world_map2$country, 
           fill = (list(gni_ppp_cap = NA)) ) %>%
  left_join(world_map2, by = "country") %>%
  replace_na(list(year = 2017))


gni_map_2017 <- gni_dat_2017%>%
  filter(code_3 != "ATA") %>%
  ggplot(aes(x = long, 
             y = lat, 
             group = group, 
             label = country)) +
  geom_polygon(aes(fill = gni_ppp_cap) )+
  scale_fill_viridis_c(option = "C") +
  labs(fill = "",
       title = "GNI Per Capita for 2017 (in PPP dollars)") +
  theme_void()


# Basic
gni_map_2017 

# interactice
plotly::ggplotly(gni_map_2017)



############  END ############