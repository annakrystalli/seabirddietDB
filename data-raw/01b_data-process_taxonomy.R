library(dplyr)
source(here::here("R", "taxonomy.R"))

## read-in-raw-prey-taxonomy ----
taxonomy_raw <- readr::read_tsv(here::here("data-raw", "taxonomy.tsv")) %>%
    rename_all(funs(stringr::str_replace(., "_prey", ""))) 

## process-worms_validate-prey-taxonomy ----
taxonomy_prey <- taxonomy_raw %>%
    recode_spp_manual() %>%
    get_row_base() %>% 
    worrms_validate() %>% 
    mutate(role = "prey")

## read-in--pred-species ----
pred_spp <- readr::read_csv(
    here::here("data-raw", 
               "Seabird Diets British Isles revised 20180620.csv")) %>% 
    select("Species") %>% 
    distinct() %>%
    rename(species = Species) 

## process-worms_validate-pred-taxonomy ----
pred_worms <- taxonomy_raw %>% 
    slice(0) %>% 
    bind_rows(pred_spp) %>%
    get_row_base() %>% 
    worrms_validate() %>%
    select(-(phylum:genus))

## process-worms_classify-pred-taxonomy ----
pred_classification <- worrms::wm_classification_(name = pred_worms$base_name) %>% 
    # convert rank to lower case
    mutate(rank = tolower(rank)) %>%
    # filter for taxonomic info matching raw taxonomy column names
    filter(rank %in% names(taxonomy_raw))  %>%  
    # remove non base taxonomic AphiaID
    select(-AphiaID) %>%
    # covenrt to wide to match taxonomy
    tidyr::spread(., key = rank, value = scientificname)

## combine-pred-worms_taxo-classification ----   
taxonomy_pred <- taxonomy_raw %>% 
    slice(0) %>%
    bind_rows(pred_classification) %>% 
    select(-id) %>% 
    left_join(pred_worms, by = "species") %>% 
    mutate(role = "pred")
    
## combine-prey-pred-taxonomy-write_out    
taxonomy_prey %>% 
    bind_rows(taxonomy_pred) %>%
    readr::write_csv(here::here("data", "metadata", "taxonomy.csv"))
