# Restart session!!!
library(metadatar)
library(dplyr)
library(seabirdPrey)

data(seabirddiet_)
data(seabirddiet)

# load metadata tables
meta_tbl <- readr::read_csv(here::here("data-raw", "metadata", "attributes.csv"))

# update meta_tbl attributeName
meta_tbl <- mt_update_meta_tbl(seabirddiet, meta_tbl) 

# update factors
factor_vars <- c("pred_breeding_status", "pred_age_group", "prey_age_group",
                 "source", "sample_type", "prey_rank", "pred_rank", "multiyear")
meta_tbl <- mt_update_factors(seabirddiet_, meta_tbl, factor_cols = factor_vars, overwrite = T) 
readr::write_csv(meta_tbl, here::here("data-raw", "metadata", "attributes.csv"))


# manual updates if required
seabirdPrey::mn_edit_df(meta_tbl)   
