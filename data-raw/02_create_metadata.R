library(metadatar)

tbl <- readr::read_csv(here::here("data", "seabird-diet_db.csv"))
meta_tbl <- readr::read_csv(here::here("data", "metadata", "attributes.csv"))

mt_update_factors(tbl, meta_tbl, factor_cols = get_factors_meta(meta_tbl)) %>% View()
