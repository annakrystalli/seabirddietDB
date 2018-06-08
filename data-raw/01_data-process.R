# load-libraries ----
library(dplyr)

# read-raw-data ----
ms <- readxl::read_excel(here::here("data-raw", "Master File 20171020.xlsx")) %>% 
    janitor::clean_names()



# validate proportional frequencies
ms %>% group_by(year, location, species, age_group, sample_size) %>% 
    summarise(fo_o_sum = sum(fo_o)) %>% 
    mutate(valip_prop = near(fo_o_sum, 1)) %>% arrange(desc(fo_o_sum)) %>%
    filter(valip_prop == F) %>% 
    readr::write_csv(here::here("data-raw", "validation", 
                                "foo_unvalidated.csv"))


library(dplyr)
readr::read_csv("/Users/Anna/Documents/workflows/MERP/seabirdPrey/data-raw/validation/foo_unvalidated.csv") %>% knitr::kable()

