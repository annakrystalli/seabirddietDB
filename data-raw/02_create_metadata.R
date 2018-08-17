library(metadatar)
library(dplyr)

tbl <- readr::read_csv(here::here("output", "seabirddiet.csv"))
meta_tbl <- readr::read_csv(here::here("data-raw", "metadata", "attributes.csv"))
meta_tbl %>% mn_edit_df()
meta_tbl %>% 
    readr::write_csv(here::here("data-raw", "metadata", "attributes.csv"))




factor_vars <- c("pred_breeding_status", "pred_age_group", "prey_age_group",
                 "source", "sample_type")
meta_tbl <- mt_update_factors(tbl, meta_tbl, factor_cols = factor_vars) 

mn_names <- readr::read_csv(
    here::here("data-raw", "validation",
               "mn_seabirddiet_rename.csv")) 

# Interactive! DO NOT SOURCE
readr::read_csv(
    here::here("data-raw", "validation",
               "mn_seabirddiet_rename.csv")) %>% 
    add_row(names = "prey_age_group", rename = "prey_age_group") %>%
    distinct() %>%
    readr::write_csv(
        here::here("data-raw", "validation",
                   "mn_seabirddiet_rename.csv"))


meta_tbl <- mn_recode(meta_tbl, mn_names, "attributeName")



mt_update_meta_tbl(seabirddiet, meta_tbl) 
 
mn_edit_df(mn_names)   
