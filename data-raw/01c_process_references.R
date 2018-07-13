library(dplyr)
load(here::here("data", "seabirddiet.rda"))

check.dims <- dim(seabirddiet) + c(0, 1)

# read-manual-corrections ----
# read in and post process manual corrections
# ref_manual <- readr::read_csv(here::here("data-raw", 
ref_manual <- readr::read_csv(here::here("data-raw", 
                                         "validation", 
                                         "reference_manual_clean.csv")) %>%  
    mutate(rename = stringr::str_replace(rename, "–", "-")) %>% # get rid of long hyphen
    mutate(rename = stringr::str_replace(rename, "\\.$", "")) # get rid of trailing .




n_ref <- stringr::str_count(ref_manual$rename, ";") %>% max() + 1

# tidy-references ----
ref_tidy <- ref_manual %>% 
    mutate(raw_id = get_ref_code(1:nrow(.), type = "raw")) %>%
    tidyr::separate(rename, into = as.character(1:n_ref), sep = ";") %>%
    tidyr::gather(key = ref_n, value = ref_valid, as.character(1:4)) %>%
    filter(!is.na(ref_valid)) %>%
    mutate(ref_valid = stringr::str_trim(ref_valid)) 

# pro
ref <- ref_tidy %>% distinct(ref_valid) %>%
    mutate(ref_id = get_ref_code(1:nrow(.), type = "ref")) %>%
    select(ref_id, ref_valid) %>%
    distinct() 

ref %>% readr::write_csv(here::here("data", "metadata", "references.csv"))

# join-ref_ids ----
seabirddiet <- ref_tidy %>% left_join(ref, by = "ref_valid") %>% group_by(raw_id) %>%
    mutate(ref_ids = paste0(unique(ref_id), collapse = "; "),
           ref_n = as.numeric(max(ref_n))) %>%
    ungroup() %>%
    select(reference, ref_n, ref_ids) %>% 
    left_join(seabirddiet, ., by = "reference") %>%
    select(-reference)

seabirddiet %>% 
    assertr::assert(assertr::not_na("ref_ids")) %>%
    assertr::assert(is.numeric("ref_n")) %>%
    assertr::verify(dim(.) == check.dims)


