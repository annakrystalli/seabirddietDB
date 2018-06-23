# ---- load-libraries ----
library(seabirdPrey)

# ---- write-data ----
seabirddiet <- readr::read_csv(
    here::here("data-raw", 
               "Seabird Diets British Isles revised 20180620.csv")) %>% 
    janitor::clean_names() 

create_ID <- function(df, name, identifiers){
    mutate = paste0()
    df %>% dplyr::select((!!rlang::sym(identifiers[1])))
}

seabirddiet <- bind_cols(ID =  1:nrow(seabirddiet), seabirddiet)

seabirddiet %>% janitor::get_dupes(startyear, location, species, prey_species,
                                   breeding_status, age_group) %>% View()



