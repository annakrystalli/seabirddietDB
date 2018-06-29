context("setup.R")

taxonomy <- readr::read_tsv(here::here("data-raw", "taxonomy.tsv")) %>%
    dplyr::rename_all(dplyr::funs(stringr::str_replace(., "_prey", ""))) 

taxo_correct <- readr::read_csv(here::here("data-raw", 
                                           "worrms_nomatches_verified.csv"))


seabirddiet <- readr::read_csv(
    here::here("data-raw", 
               "Seabird Diets British Isles revised 20180620.csv")) %>% 
    janitor::clean_names() %>%
    dplyr::bind_cols(ID =  1:nrow(.), .)

