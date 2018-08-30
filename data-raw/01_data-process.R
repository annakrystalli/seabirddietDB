# ---- load-libraries ----
library(seabirdPrey)
library(dplyr)

# read-data ----
seabirddiet_raw <- readr::read_csv(
    here::here("data-raw", 
               "Seabird Diets British Isles revised 20180620.csv")) %>% 
    janitor::clean_names() %>%
    bind_cols(id =  1:nrow(.), .) 


# clean-prey-type ----
seabirddiet <- seabirddiet_raw %>% 
    # fill missing prey type entries found in prey species
    mutate(prey_type = 
               case_when(
                   prey_species == "0 Group Sandeel" ~ "0 Group Sandeel",
                   prey_species == "1+ Group Sandeel" ~ "1+ Group Sandeel",
                   TRUE ~ prey_type),
           # clean prey type
           prey_type = stringr::str_to_lower(prey_type),
           prey_type = stringr::str_replace(prey_type, "o group", "0 group"),
           prey_type = stringr::str_replace(prey_type, "o-group", "0 group"),
           # clean prey_species to remove
           prey_species = dplyr::recode(prey_species,
                                        `0 Group Sandeel` = "Ammodytidae",
                                        `1+ Group Sandeel` = "Ammodytidae",
                                        `Sandeel 0 Group` = "Ammodytidae",
                                        `Sandeel 1+ Group` = "Ammodytidae",
                                        others = "other",
                                        Other = "other"),
           # fill in NAs
           prey_species = 
               case_when(is.na(prey_species) & 
                             stringr::str_detect(prey_type, "sandeel") ~ "Ammodytidae",
                         is.na(prey_species) & 
                         stringr::str_detect(prey_type, "gadoids") ~ "Gadidae",
                         is.na(prey_species) & 
                         stringr::str_detect(prey_type, "other") ~ "Others",
                         TRUE ~ prey_species),
           
           # fill prey_age_group column
           prey_age_group = 
               case_when(stringr::str_detect(prey_type, "0") ~ "0",
                         stringr::str_detect(prey_type, "1|(older)") ~ "+1"),
           #prey_size = stringr::str_replace_all(prey_size, "m", "")
           )

#source(here::here("data-raw", "01c_process_references.R"))

ref_join <- readr::read_csv(here::here("data-raw", "joins", "ref_join.csv")) %>% 
    assertr::assert(assertr::is_uniq, reference)
taxonomy <- readr::read_csv(here::here("data-raw", "metadata", "taxonomy.csv")) %>%
    janitor::clean_names() %>% 
    assertr::assert(assertr::is_uniq, base_name) 


# join-taxo-ref ----
seabirddiet <- seabirddiet %>% 
    left_join(taxonomy %>% 
                  select(base_name, base_rank, aphia_id:valid_aphia_id) %>% 
                  setNames(paste0('prey_', names(.))), 
              by = c("prey_species" = "prey_base_name")) %>% 
    left_join(taxonomy %>% 
                  select(base_name, aphia_id:valid_aphia_id) %>% 
                  setNames(paste0('pred_', names(.))), 
              by = c("species" = "pred_base_name")) %>%
    left_join(ref_join, by = "reference") %>% 
    select(-reference)  %>%
    assertr::verify(nrow(.) == nrow(seabirddiet_raw))

# rename-vars ----
# create manual recode table
# mn_recode_tbl(tibble(names = names(seabirddiet)), names)
mn_names <- readr::read_csv(
    here::here("data-raw", "validation",
               "mn_seabirddiet_rename.csv")) 
seabirddiet <- seabirddiet %>% rename_at(vars(mn_names$names), ~ mn_names$rename)





# clean-factors
factor_vars <- c("pred_breeding_status", "pred_age_group", "prey_age_group",
                 "source", "sample_type")
seabirddiet <- seabirddiet %>%
    mutate_at(factor_vars, stringr::str_to_lower) 



# reorder-vars ----
seabirddiet <- seabirddiet %>% 
    dplyr::select(id, year:longitude, 
                  dplyr::starts_with("pred"),
                  dplyr::starts_with("prey"),
                  dplyr::starts_with("freq"),
                  dplyr::starts_with("sample"),
                  dplyr::starts_with("ref"),
                  everything())

# write-out ----
readr::write_csv(seabirddiet, here::here("output", "seabirddiet.csv"))

