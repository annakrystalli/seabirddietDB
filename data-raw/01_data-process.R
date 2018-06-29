# ---- load-libraries ----
library(seabirdPrey)

# ---- write-data ----
seabirddiet <- readr::read_csv(
    here::here("data-raw", 
               "Seabird Diets British Isles revised 20180620.csv")) %>% 
    janitor::clean_names() %>%
    bind_cols(ID =  1:nrow(seabirddiet), .)




