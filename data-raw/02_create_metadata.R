library(metadatar)
library(dplyr)

tbl <- readr::read_csv(here::here("inst", "csv", "seabirddiet.csv"), guess_max = Inf)
meta_tbl <- readr::read_csv(here::here("data-raw", "metadata", "attributes.csv"))

# update meta_tbl attributeName
meta_tbl <- mt_update_meta_tbl(tbl, meta_tbl) 

# update factors
factor_vars <- c("pred_breeding_status", "pred_age_group", "prey_age_group",
                 "source", "sample_type", "prey_rank")
meta_tbl <- mt_update_factors(tbl, meta_tbl, factor_cols = factor_vars, overwrite = T) 

# manual updates if required
seabirdPrey::mn_edit_df(meta_tbl)   
