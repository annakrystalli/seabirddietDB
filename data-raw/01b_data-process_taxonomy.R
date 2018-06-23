library(dplyr)
source(here::here("R", "taxonomy.R"))

taxonomy <- readr::read_tsv(here::here("data-raw", "taxonomy.tsv")) %>%
    correct_manual() %>%
    rowwise %>% 
    do({
        result = as_data_frame(.)
        result$base = get_taxo_base(.) %>% unlist
        result})  %>% worrms_taxonomy()





    readr::write_tsv(here::here("data", "metadata", "taxonomy.tsv"))