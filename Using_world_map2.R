library(tidyverse)
library(here)
library(visdat)



load(here::here("data",
                "tidy_data", 
                "maps", 
                "world_map2_project.rda"))



gni_percapita_ppp <- read_csv(here::here("data",
                                         "raw_data",
                                         "gnipercapita_ppp_current_international.csv") )


water_access <- read_csv(here::here("data", 
                                    "raw_data", 
                                    "at_least_basic_water_source_overall_access_percent.csv") )




energy_use_per_person <- read_csv(here::here("data", 
                                             "raw_data", 
                                             "energy_use_per_person.csv") )

water_access  %>% vis_dat()
water_access  %>% glimpse()


setdiff(water_access$country,world_map2$country)
setdiff(world_map2$country, water_access$country)



water_tidy <- water_access %>%
  pivot_longer(cols = !country,
               names_to = "year",
               names_transform = list(year = as.integer),
               values_to = "water")



water_tidy %>% vis_dat()
water_tidy %>% glimpse()

water_tidy$year %>% range()


water_dat_2000 <- water_tidy %>%
  filter(year == 2000) %>% 
  complete(country = world_map2$country, 
           fill = (list(water = NA )) ) %>%
  left_join(world_map2, by = "country") %>%
  replace_na(list(year = 2000))


water_dat_2000 %>%
  ggplot(aes(x = long, 
             y = lat, 
             group = group, 
             label = country)) +
  geom_polygon(aes(fill = water) )+
  scale_fill_viridis_c(option = "C") +
  labs(fill = "Water Acess",
       title = "Gapminder Data: 2000") +
  theme_void()


water_dat_2005 <- water_tidy %>%
  filter(year == 2005) %>% 
  complete(country = world_map2$country, 
           fill = (list(water = NA )) ) %>%
  left_join(world_map2, by = "country") %>%
  replace_na(list(year = 2005))


water_dat_2005 %>%
  filter(code_3 != "ATA")  %>%
  ggplot(aes(x = long, y = lat, group = group, label = country)) +
  geom_polygon(aes(fill = water ) )+
  scale_fill_viridis_c(option = "C") +
  labs(fill = "Water Acess",
       title = "Gapminder Data: 2005") +
  theme_void()






# Explore
gni_percapita_ppp %>% vis_dat()

gni_percapita_ppp %>% glimpse()


setdiff(gni_percapita_ppp$country,world_map2$country)
setdiff(world_map2$country, gni_percapita_ppp$country)


tidy_gni_capita <- gni_percapita_ppp %>%
  pivot_longer(cols = !country,
               names_to = "year",
               names_transform = list(year = as.integer),
               values_to = "gni_ppp_cap") %>%
  mutate(gni_ppp_cap = readr::parse_number(gni_ppp_cap) )%>%
  mutate(gni_ppp_cap = case_when(gni_ppp_cap < 175 ~ gni_ppp_cap * 1000,
                                 TRUE ~ gni_ppp_cap) )


tidy_gni_capita <- tidy_gni_capita %>%
  mutate( country = case_when(country == "Curaçao" ~ "Curacao",
                              country == "Sint Maarten (Dutch part)"  ~ "Sint Maarten" ,
                              TRUE ~ country) )


tidy_gni_capita %>% vis_dat()

tidy_gni_capita %>% glimpse()

setdiff(tidy_gni_capita$country, world_map2$country)






