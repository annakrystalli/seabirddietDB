library(dplyr)
source(here::here("R", "taxonomy.R"))

taxonomy <- readr::read_tsv(here::here("data-raw", "taxonomy.tsv")) %>%
    rename_all(funs(stringr::str_replace(., "_prey", ""))) %>%
    recode_manual(path = here::here("data-raw",
                              "worrms_nomatches_verified.csv")) %>%
    rowwise %>% 
    do({
        result = as_data_frame(.)
        result$base_name = get_tx_base_name(.) %>% unlist
        result$base_rank = get_tx_base_rank(., ranks = names(.)) %>% unlist
        result})  %>% worrms_validate() 

taxonomy %>%
    readr::write_csv(here::here("data", "metadata", "taxonomy.csv"))