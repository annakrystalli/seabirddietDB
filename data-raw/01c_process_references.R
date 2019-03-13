library(dplyr)
library(seabirdPrey)

# read-manual-corrections ----

## read-in-raw-prey-taxonomy ----
seabirddiet <- readr::read_csv(here::here("data-raw", "intermediate", "seabirddiet.csv"),
                               guess_max = Inf, na = c("", "NA")) 
# read in and post process manual corrections
ref_manual <- readr::read_csv(here::here("data-raw", 
                                         "manual_corrections", 
                                         "reference_manual_clean.csv")) %>%  
    # get rid of long hyphen
    mutate(rename = stringr::str_replace(rename, "–", "-")) %>% 
    # get rid of trailing .
    mutate(rename = stringr::str_replace(rename, "\\.$", "")) %>% 
    # fuzzy match missing references in seabirddiet to ref_manual
    ref_bind_matched_missing_manual(seabirddiet, .) 


missing <- ref_find_missing_manual(seabirddiet, ref_manual)
#inspect missing
missing
# if all good, add to ref_manual
#ref_add_manual(missing$reference, ref_manual) 

# tidy-references ----
ref_tidy <- tidy_refs(ref_manual)


# get_ref_table ----
ref <- get_ref_tbl(ref_tidy)

# writeout-ref_table ----
ref %>% 
    assertr::assert(assertr::is_uniq(c("ref_valid", "ref_id"))) %>%
    assertr::assert(stringr::str_detect("ref_valid", "–") == F) %>%
    assertr::verify(assertr::has_all_names("ref_id", "ref_valid")) %>%
    readr::write_csv(here::here("data-raw", "metadata", "references.csv"))

# get-join_ref ----
join_ref <- get_join_ref(ref_tidy, ref)
join_ref <- join_ref %>% dplyr::bind_rows(
    join_ref %>% 
        mutate(reference = stringr::str_replace_all(reference, "–", "?"))) %>%
    distinct()

# writeout-join_ref ----
join_ref %>% 
    # validate
    assertr::assert(is.numeric("ref_n")) %>%
    assertr::verify(nrow(.) == 309) %>% 
    assertr::assert(assertr::is_uniq, reference) %>%
    assertr::verify(all(seabirddiet$reference %in% .$reference)) %>%
    assertr::verify(assertr::not_na("ref_ids")) %>% 
    assertr::verify(assertr::has_all_names("reference", "ref_n", "ref_ids")) %>%
    # write out
    readr::write_csv(here::here("data-raw", "joins", "ref_join.csv"))
    



