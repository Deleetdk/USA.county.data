### tidy the dirty NYC 2016 data

# remove redundant header rows --------------------------------------------
#the only information in this is the state, but we can get that using the county IDs/FIPS
d_this = d_this[-c(1:2), ]


# rownames to explicit variable -------------------------------------------
#easier to work with like that in this case
d_this %<>% rownames_to_column()


# to 2 columns ------------------------------------------------------------
#the problem is that each col has data for all counties in that state, but there's no need for that
#we move all the data in the state-cols to 1 columns so we end up with 2 cols

#function to subset data
extractor = function(i) {
  #which rows has data?
  nonNA_rows = !is.na(d_this[[i]])
  
  #subset
  d_this[nonNA_rows, c(1, i)] %>% set_colnames(c("key", "value"))
}

#loop and get data
d_this = map_df(.x = 2:ncol(d_this), .f = extractor)


# remove redundant info in key --------------------------------------------
#next we remove redundant info in the key variable
#we extract the fips code first to a new id variable
#and get the key afterwards
d_this$fips = d_this$key %>% str_extract(pattern = "\\d+")
d_this$key %<>% str_replace(pattern = "counties\\.\\d+\\.", replacement = "")

#assert that theres no NAs
see_if(noNA(d_this$fips))
see_if(noNA(d_this$key))

# spread ------------------------------------------------------------------
#finally we spread the data to get a tidy df!
d_this %<>% spread(key = key, value = value)

#remove extra fips variable
d_this = d_this[!duplicated(names(d_this))]

#to fancy df
d_this = as_data_frame(d_this)


# merge by fips -----------------------------------------------------------
#join the two tables by fips code
d_both = dplyr::full_join(d_this, d_prev, by = c("fips" = "GEOID"))


# variable deletion/fix ----------------------------------------------
#theres two name variables
d_both$NAME = NULL
d_both$est_votes_remaining = NULL
d_both$reporting = NULL

#fips to int
d_both$fips %<>% as.integer()

# make party 2016 vars ----------------------------------------------------
#the numbers are given for each candidate for 2016
#but we just want the 4 biggest parties
d_both %<>% mutate(rep16_frac = as.numeric(results.trumpd) / as.numeric(votes),
                  dem16_frac = as.numeric(results.clintonh) / as.numeric(votes),
                  green16_frac = as.numeric(results.steinj) / as.numeric(votes),
                  libert16_frac = as.numeric(results.johnsong) / as.numeric(votes),
                  rep12_frac = rep12/tot12,
                  rep08_frac = rep08/tot08,
                  dem12_frac = dem12/tot12,
                  dem08_frac = dem08/tot08
                  )


# merge with data from Kirkegaard 2016 ------------------------------------
d_all = dplyr::full_join(d_both, d_kirk16, by = c("fips" = "FIPS"))

# save data for reuse -----------------------------------------------------
write_csv(d_all, "data/tidy_data.csv", na = "")
write_rds(d_all, "data/tidy_data.rds")

#to the data package
USA_county_data = d_all
save(USA_county_data, file = "USA_county_data.RData")
