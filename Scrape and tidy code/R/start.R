###start

# libs --------------------------------------------------------------------
library(pacman)
p_load(jsonlite, kirkegaard, tidyverse, assertthat, readr)
options(digits = 2)

# data --------------------------------------------------------------------
#http://www.nytimes.com/elections/results/president
json_prev = jsonlite::fromJSON('data/NYT_2008_2012.json')
json_2016 = jsonlite::fromJSON('data/NYT_2016.json', flatten = T)
d_kirk16 = read_csv("data/S_counties_data.csv") #from county study

#extract useful data
d_prev = json_prev$objects$counties$geometries$properties
#d_this = json_2016$contents$`eln_2016_prd:2016-11-08:president:counties` %>% t %>% as.data.frame

# updated -----------------------------------------------------------------
json_2016_final = jsonlite::fromJSON("data/updated.json", flatten = T)
d_this = bind_rows(json_2016_final$counties) %>% as_data_frame
