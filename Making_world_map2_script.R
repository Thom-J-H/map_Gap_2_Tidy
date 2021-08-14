
# Making world_map2 -------------------------------------------------------



# Libraries ---------------------------------------------------------------

library(tidyverse)
library(here)
library(visdat)



# Data sets from Gapminder.org --------------------------------------------
life_expectancy_years <- read_csv(here::here("data", 
                                             "raw_data", 
                                             "life_expectancy_years.csv") ,
                                  show_col_types = FALSE)

total_fertility <- read_csv(here::here("data", 
                                       "raw_data",
                                       "children_per_woman_total_fertility.csv"),
                            show_col_types = FALSE)

energy_use_per_person <- read_csv(here::here("data", 
                                             "raw_data", 
                                             "energy_use_per_person.csv"),
                                  show_col_types = FALSE)

demox_eiu <- read_csv(here::here("data", 
                                 "raw_data", 
                                 "demox_eiu.csv"),
                      show_col_types = FALSE)



# Gapminder data EDA ------------------------------------------------------

life_expectancy_years %>% head()

demox_eiu %>% vis_dat()

life_expectancy_years %>% 
  arrange(country) %>% 
  select(country)

demox_eiu %>% 
  arrange(country) %>% 
  select(country)

life_expectancy_years$country %>% 
  n_distinct()

energy_use_per_person$country %>% 
  n_distinct() 



# Set differences ---------------------------------------------------------

### Fertility  vs. Life coverage
setdiff(total_fertility$country, life_expectancy_years$country) %>% 
  enframe(name = NULL, value = "diff") %>% 
  knitr::kable(caption = "Fertility  vs. Life coverage" ,
               row.names = TRUE)

### Life vs. Fertility  coverage
setdiff(life_expectancy_years$country, total_fertility$country)  %>% 
  enframe(name = NULL, value = "diff") %>% 
  knitr::kable(caption = "Life vs. Fertility  coverage" ,
               row.names = TRUE)

### Fertility  vs. Energy coverage"
setdiff(total_fertility$country, energy_use_per_person$country)  %>% 
  enframe(name = NULL, value = "diff") %>% 
  knitr::kable(caption = "Fertility  vs. Energy coverage",
               row.names = TRUE)


### Energy vs. Fertility coverage
setdiff(energy_use_per_person$country, total_fertility$country) %>% 
  enframe(name = NULL, value = "diff") %>% 
  knitr::kable(caption = "Energy vs. Fertility coverage",
               row.names = TRUE)

### Life vs. Energy coverage
setdiff(life_expectancy_years$country, energy_use_per_person$country) %>% 
  enframe(name = NULL, value = "diff") %>% 
  knitr::kable(caption = "Life vs. Energy coverage",
               row.names = TRUE)

### Energy  vs. Life coverage
setdiff(energy_use_per_person$country,life_expectancy_years$country) %>% 
  enframe(name = NULL, value = "diff") %>% 
  knitr::kable(caption = "Energy  vs. Life coverage",
               row.names = TRUE)

### Energy  vs. Democracy coverage
setdiff(energy_use_per_person$country,demox_eiu$country) %>% 
  enframe(name = NULL, value = "diff") %>% 
  knitr::kable(caption = "Energy  vs. Democracy coverage",
               row.names = TRUE)

### Democracy vs. Energy coverage
setdiff(demox_eiu$country,energy_use_per_person$country) %>% 
  enframe(name = NULL, value = "diff") %>%
  knitr::kable(caption = "Democracy vs. Energy coverage",
               row.names = TRUE)


# Country name reference --------------------------------------------------


# Gapminder Country Name Reference DF -------------------------------------

country_names <- demox_eiu %>% 
  select(country) %>% 
  full_join(energy_use_per_person, by = "country") %>%
  select(country) %>%
  full_join(total_fertility, by = "country") %>%
  select(country)  %>% 
  full_join(life_expectancy_years, by = "country") %>% 
  select(country) %>% 
  arrange(country) 

## Current working total
country_names$country %>%
  n_distinct() 

country_names %>% head(n = 10) %>% 
  knitr::kable(caption = "First Ten Country Designations",
               row.names = TRUE)

country_names %>% tail(n = 10) %>% 
  knitr::kable(caption = "Last Ten Country Designations",
               row.names = TRUE)




# Mapping data source -----------------------------------------------------

world_map <- ggplot2::map_data("world")

world_map %>% vis_dat()
## Basic unit is region; subregion mostly NA
world_map %>% glimpse()
## group or groups belong to regions
## order refers the long and lat coordinates for mapping
## long == longitude lat == latitude

world_map %>% 
  skimr::skim(region, subregion)
## more regions than gapminder countries 
## difference in emphasis
## subregion contains some units which gapminder treats a country



# Essential tools ---------------------------------------------------------


### Check for example South Sudan
world_map %>% 
  filter(stringr::str_detect(region, "Sudan") ) %>% 
  distinct(region) 

### Check for example South Sudan
world_map %>% 
  filter(stringr::str_detect(region, "South") ) %>% 
  distinct(region) 

### Check for example South Sudan
country_names %>% 
  filter(stringr::str_detect(country, "Sudan") ) 

### Check for example South Sudan
country_names %>% 
  filter(stringr::str_detect(country, "South") )


### Check for example Hong Kong
world_map %>% 
  filter(stringr::str_detect(region, "Hong Kong") ) %>% 
  distinct(region)  # NO!

### Check for example Hong Kong
world_map %>% 
  filter(stringr::str_detect(subregion, "Hong Kong") ) %>% 
  distinct(region, subregion)  # YES!

### Group IDs for coordinates data
world_map %>% 
  filter(stringr::str_detect(subregion, "Hong Kong") ) %>%
  select(group) %>% 
  distinct()



# Map regions vs Gapminder countries --------------------------------------

####Identify key differences --------------------------------------

map_vs_gap <- setdiff(world_map$region, country_names$country) %>%
  enframe(name = NULL, value = "desn") %>% 
  arrange(desn)

gap_vs_map <- setdiff(country_names$country, world_map$region) %>%
  enframe(name = NULL, value = "desn") %>% 
  arrange(desn)

map_vs_gap %>% 
  knitr::kable(caption = "Map regions vs. Gap countries: Coverage diff",
               row.names = TRUE)

gap_vs_map  %>% 
  knitr::kable(caption = "Gap countries vs. Map regions: Coverage diff",
               row.names = TRUE)



# Standardizing Names -----------------------------------------------------


# Easy cases --------------------------------------------------------------
### Easy cases -- see tools above for digging out names

world_map2 <- world_map %>% 
  rename(country = region) %>%
  mutate(country = case_when(country == "Macedonia" ~ "North Macedonia" ,
                             country == "Ivory Coast"  ~ "Cote d'Ivoire",
                             country == "Democratic Republic of the Congo"  ~ "Congo, Dem. Rep.",
                             country == "Republic of Congo" ~  "Congo, Rep.",
                             country == "UK" ~  "United Kingdom",
                             country == "USA" ~  "United States",
                             country == "Laos" ~  "Lao",
                             country == "Slovakia" ~  "Slovak Republic",
                             country == "Saint Lucia" ~  "St. Lucia",
                             country == "Kyrgyzstan"  ~  "Kyrgyz Republic",
                             country == "Micronesia" ~ "Micronesia, Fed. Sts.",
                             country == "Swaziland"  ~ "Eswatini", 
                             country == "Virgin Islands"  ~ "Virgin Islands (U.S.)", 
                             TRUE ~ country))





### Progress check
setdiff(country_names$country, world_map2$country)  %>% 
  enframe(name = NULL, value = "diff") %>% 
  knitr::kable(caption = "Remaining Cases", 
               row.names = TRUE)


# Island Nations ----------------------------------------------------------

## Get data for Island nations
match_names <- c("Antigua" , "Barbuda", "Nevis", 
                 "Saint Kitts", "Trinidad" , 
                 "Tobago", "Grenadines" , "Saint Vincent")

### Island nations data set
map_match <- world_map2 %>% 
  filter(country %in% match_names) 

map_match %>% distinct(country)


### Group IDs for the countries
ant_bar <- c(137 ,138 )
kit_nev <- c(930 , 931)
tri_tog <- c(1425, 1426)
vin_gre <- c(1575, 1576, 1577)
# chan_isl <- c(594, 861)
# neth_ant <- c(1055, 1056)

new_names_ref <- c("Antigua and Barbuda", "St. Kitts and Nevis",
                   "Trinidad and Tobago", "St. Vincent and the Grenadines")


### assign new country names to match Gapminder
map_match <- map_match %>% 
  mutate(country = case_when(group %in% ant_bar ~ "Antigua and Barbuda" ,
                             group %in% kit_nev  ~ "St. Kitts and Nevis" ,
                             group %in% tri_tog  ~ "Trinidad and Tobago" ,
                             group %in% vin_gre ~ "St. Vincent and the Grenadines") 
  ) %>% 
  tibble()

### Quick checks

map_match %>% head()

map_match %>% 
  distinct(country)%>% 
  knitr::kable(caption = "Add to World Map")

map_match %>% 
  group_by(country) %>% 
  count(group)  %>% 
  knitr::kable(caption = "Add to World Map")

#### Structure check for merge
map_match %>% 
  str()

world_map2 %>% 
  str()


#### Time to Slice, Dice, and Restack

world_map2 <-  world_map2 %>%
  filter(!country %in% match_names)


world_map2 <- world_map2 %>% 
  bind_rows(map_match) %>%
  arrange(country)  %>%
  tibble()

### Safety check -- should return empty set
world_map2 %>% 
  filter(country %in% match_names)


### Safety check - should return one complete row each
world_map2 %>% 
  filter(country %in% new_names_ref) %>%
  group_by(country) %>%
  slice_max(order, n = 1)



# Subregion promotion -----------------------------------------------------

####
### Hong Kong and Macao
####  Pull from subregion; slice out; restack

sub_sleeps <- c("Hong Kong", "Macao")

hk_mc <- world_map2 %>% 
  filter(subregion %in% sub_sleeps)

hk_mc <- hk_mc %>%
  mutate(country = case_when(subregion == "Hong Kong" ~ "Hong Kong, China" ,
                             subregion == "Macao" ~ "Macao, China" ) )


### Safety check for bind_rows()
hk_mc %>% 
  slice(38:41) %>% 
  knitr::kable(caption = "Check structure")

### Slice out old info
world_map2 <-   world_map2 %>%
  filter(!subregion %in% sub_sleeps)

### Stack in new info
world_map2 <- world_map2 %>% 
  bind_rows(hk_mc) %>%
  select(-subregion) %>% 
  tibble()


### Progress check
setdiff(country_names$country, world_map2$country)  %>% 
  enframe(name = NULL, value = "diff") %>% 
  knitr::kable(caption = "Remaining Cases", 
               row.names = TRUE)


# Map Check ---------------------------------------------------------------


world_map2 %>% distinct(country) %>%
  DT::datatable(caption = "Map Country List")

### No Tuvalu  in map -- add coordinates
world_map2 %>% 
  filter(stringr::str_detect(country, "Tu") ) %>%
  distinct(country)



# Add Tuvalu, Gibr, BVI ----------------------------------------------------

# Tuvalu
world_map %>% 
  filter(stringr::str_detect(region, "Tu") ) %>% 
  distinct(region, subregion)

# Tuvalu again
world_map %>% 
  filter(stringr::str_detect(subregion, "Tu") ) %>% 
  distinct(region, subregion) 

# Gibraltar
world_map %>% 
  filter(stringr::str_detect(region, "Gib") ) %>% 
  distinct(region, subregion) 

# Gibraltar
world_map %>% 
  filter(stringr::str_detect(subregion, "Gib") ) %>% 
  distinct(region, subregion) 


### From https://public.opendatasoft.com/ 
tuvalu_coords <- readRDS(here::here("data", 
                                    "tidy_data", 
                                    "tuvalu_coords.rds") )


tuvalu_coords %>% head()  ## check structure


## Add to map
world_map2 <- world_map2 %>%
  bind_rows(tuvalu_coords) %>% 
  arrange(country)

## Check!
world_map2 %>% 
  filter(stringr::str_detect(country, "Tu") ) %>%
  distinct(country)

### Missing also Gibraltar &  Virgin Islands (British)
### From https://public.opendatasoft.com/ 

Gib_BVI_coords <- readRDS(file = here::here("data",
                                            "tidy_data",
                                            "Gib_BVI_coords.rds"))

Gib_BVI_coords %>% head()


world_map2 <- world_map2 %>%
  bind_rows(Gib_BVI_coords) %>% 
  arrange(country)


world_map2 %>% 
  filter(stringr::str_detect(country, "Gib") ) %>%
  distinct(country)

world_map2 %>% 
  filter(stringr::str_detect(country, "Vir") ) %>%
  distinct(country)


# ISO country codes -------------------------------------------------------

country_ISO_codes <- readRDS(file = here::here("data", 
                                               "tidy_data", 
                                               "country_ISO_codes2.rds") )

country_ISO_codes %>% head()



# Add Norfolk Island ------------------------------------------------------


### Missing Norfolk Island
norfolk_codes <- tibble(s_name = "Norfolk Island",
                        code_2 = "NF", 
                        code_3 = "NFK",
                        code_num = 574,
                        form_name = "Territory of Norfolk Island, Australia")

norfolk_codes %>% head()

country_ISO_codes2 <- country_ISO_codes %>%
  bind_rows(norfolk_codes) %>% 
  arrange(s_name)

country_ISO_codes2 %>% 
  filter(code_2 == "NF") %>% 
  slice(n=1)



# Reconcilation check -----------------------------------------------------


### Remaining  Gapmminder cases -- the two historical entities
setdiff(country_names$country, world_map2$country)  %>% 
  enframe(name = NULL, value = "diff") %>% 
  knitr::kable(caption = "Gap vs Map: Remaining Cases", 
               row.names = TRUE)


setdiff(country_ISO_codes2$s_name , world_map2$country)  %>% 
  enframe(name = NULL, value = "diff") %>% 
  knitr::kable(caption = "ISO vs Map: Remaining Cases", 
               row.names = TRUE)


setdiff(world_map2$country, country_ISO_codes2$s_name)  %>% 
  enframe(name = NULL, value = "diff") %>% 
  knitr::kable(caption = "Map vs. ISO:  Remaining Cases", 
               row.names = TRUE)


# Add ISO data to map -----------------------------------------------------

world_map2 <- world_map2 %>%
  left_join(country_ISO_codes2, by = c("country" = "s_name")) %>%
  tibble() 


world_map2 %>% vis_dat()

world_map2 %>% glimpse()


# SAVE --------------------------------------------------------------------


save_data <- c("world_map2",
               "country_ISO_codes2")

# Save Data! --------------------------
save(list = save_data, file = here::here("data",
                                         "tidy_data", 
                                         "maps", 
                                         "world_map2_project.rda" ))
## Just the map data
saveRDS(world_map2, file = here::here("data",
                                      "tidy_data", 
                                      "maps", 
                                      "world_map2.rds" ))




##########  END ############