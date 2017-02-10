### The final data have a different structure, and thus need different code


# previous data vars ------------------------------------------------------

#rename some variables
d_prev %<>% dplyr::rename(
  #totals
  total12 = tot12,
  total08 = tot08,
  
  #other
  name_prev = NAME,
  statecode_prev = STATEFP
)

#add some new variables
d_prev %<>% mutate(
  #other parties
  other08 = total08 - dem08 - rep08,
  other12 = total12 - dem12 - rep12,
  
  #fraction of totals
  rep12_frac = rep12 / total12,
  rep08_frac = rep08 / total08,
  dem12_frac = dem12 / total12,
  dem08_frac = dem08 / total08,
  other12_frac = other12 / total12,
  other08_frac = other08 / total08,
  
  #fraction of major 2
  rep12_frac2 = rep12 / (dem12+rep12),
  rep08_frac2 = rep08 / (dem08+rep08),
  dem12_frac2 = dem12 / (dem12+rep12),
  dem08_frac2 = dem08 / (dem08+rep08)
)


# make party 2016 vars ----------------------------------------------------
#the numbers are given for each candidate for 2016
#but we just want the 4 biggest parties
d_this %<>% dplyr::rename(
  name_16 = name
)

d_this %<>% mutate(
  #total
  total16 = as.numeric(votes),
  
  #big 4 + other fractions
  rep16_frac = as.numeric(results.trumpd) / total16,
  dem16_frac = as.numeric(results.clintonh) / total16,
  green16_frac = as.numeric(results.steinj) / total16,
  libert16_frac = as.numeric(results.johnsong) / total16,
  other16_frac = as.numeric(results.johnsong) / total16,
  
  #fractions of big 2
  rep16_frac2 = as.numeric(results.trumpd) / (as.numeric(results.trumpd) + as.numeric(results.clintonh)),
  dem16_frac2 = as.numeric(results.clintonh) / (as.numeric(results.trumpd) + as.numeric(results.clintonh))
)


# merge election data -----------------------------------------------------

d_both = dplyr::full_join(d_this, d_prev, by = c("fips" = "GEOID"))

d_both$fips %<>% as.integer


# rename by regex ------------------------------------------------------------------

names(d_both) %<>% str_replace("^results\\.", "votes16_")

# merge with data from Kirkegaard 2016 ------------------------------------
d_all = dplyr::full_join(d_both, d_kirk16, by = c("fips" = "FIPS"))


# save data for reuse -----------------------------------------------------
write_csv(d_all, "data/tidy_data.csv", na = "")
write_rds(d_all, "data/tidy_data.rds")

#to the data package
USA_county_data = d_all
save(USA_county_data, file = "USA_county_data.RData")
