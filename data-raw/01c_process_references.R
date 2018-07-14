library(dplyr)
library(seabirdPrey)
load(here::here("data", "seabirddiet.rda"))

# read-manual-corrections ----
# read in and post process manual corrections
# ref_manual <- readr::read_csv(here::here("data-raw", 
ref_manual <- readr::read_csv(here::here("data-raw", 
                                         "validation", 
                                         "reference_manual_clean.csv")) %>%  
    mutate(rename = stringr::str_replace(rename, "–", "-")) %>% # get rid of long hyphen
    mutate(rename = stringr::str_replace(rename, "\\.$", "")) # get rid of trailing .

# tidy-references ----
ref_tidy <- tidy_refs(ref_manual)

# get_ref_table ----
ref <- get_ref_tbl(ref_tidy)

# writeout-ref_table ----
ref %>% readr::write_csv(here::here("data", "metadata", "references.csv"))

# get-join_ref ----
join_ref <- get_join_ref(ref_tidy, ref)

# writeout-join_ref ----
join_ref %>% 
    # validate
    assertr::assert(is.numeric("ref_n")) %>%
    assertr::verify(nrow(.) == length(unique(seabirddiet$reference))) %>%
    assertr::verify(all(seabirddiet$reference %in% .$reference )) %>%
    assertr::verify(assertr::not_na("ref_ids"))%>% 
    # write out
    readr::write_csv(here::here("data-raw", "joins", "ref_join.csv"))
    



