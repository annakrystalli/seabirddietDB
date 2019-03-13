library("seabirdPrey")
library(dplyr)

## read-in-raw-prey-taxonomy ----
seabirddiet <- readr::read_csv(here::here("data-raw", "intermediate", "seabirddiet.csv"),
                               guess_max = Inf, na = c("", "NA")) 

## process-worms_validate-prey-taxonomy ----
prey_taxonomy <-  worrms_validate(seabirddiet$prey_species)
pred_taxonomy <-  worrms_validate(seabirddiet$species)

## prepare classification table ----
classification <- classify_validname(unique(prey_taxonomy$valid_name,
                                            pred_taxonomy$valid_name), 
                                     ranks = c("phylum", "subphylum", "class", "order", 
                                               "family", "genus", "species"))  
classification %>%
    dplyr::arrange(phylum, subphylum, class, order, family, genus, species) %>%
    readr::write_csv(here::here("data-raw", "metadata", "classification.csv"))


