# ---- load-libraries ----
library(seabirddiet.devtools)
library(dplyr)

# read-data ----
seabirddiet_raw <- readxl::read_excel(here::here("data-raw", 
                                                 "Seabird Diets British Isles revised 20180524.xlsx"),
                                      guess_max = Inf, na = c("", "NA")) %>% 
    janitor::clean_names()

# clean-prey-type ----
seabirddiet <- seabirddiet_raw %>%
    recode_spp_manual(df_type = "data") %>% 
    
    # fill missing prey type entries found in prey species
    mutate(prey_type = 
               case_when(
                   prey_species == "0 Group Sandeel" ~ "Sandeel 0 Group",
                   prey_species == "1+ Group Sandeel" ~ "Sandeel 1+ Group",
                   TRUE ~ prey_type),
           # clean prey type
           prey_type = stringr::str_to_lower(prey_type),
           prey_type = dplyr::recode(prey_type,
                                     `pisces-offal` = "offal"),
           prey_type = stringr::str_replace(prey_type, "o group|o-group|0-group", "0 group"),
           prey_type = stringr::str_replace(prey_type, "1\\+-group|1\\+", "1+ group"),
           prey_type = stringr::str_replace_all(prey_type, "sandeels|sandeeks|sandeel \\(ammodytes\\)|^ammodytes$", "sandeel"),
           prey_type = stringr::str_replace(prey_type, "all ages", "all age groups"),
           prey_type = stringr::str_replace(prey_type, "gadid.*|gadoid fish|gadoid.*", "gadidae"),
           prey_type = stringr::str_replace(prey_type, "gadid.*|gadoid fish|gadoid.*", "gadidae"),
           prey_type = stringr::str_replace(prey_type, "fishes|pisces", "fish"),
           prey_type = stringr::str_replace(prey_type, "cephalopod$", "cephalopods"),
           prey_type = stringr::str_replace(prey_type, "clupeid$|clupeiidae|clup.*ids", "clupeidae"),
           prey_type = stringr::str_replace_all(prey_type, "polychaet.*e*.|polycheates|polychaetas", "polychaeta"),
           prey_type = stringr::str_replace(prey_type, "gobies|goby", "gobiidae"),
           prey_type = stringr::str_replace(prey_type, "cottidea", "cottidae"),
           prey_type = stringr::str_replace(prey_type, "crustacean", "crustacea"),
           prey_type = stringr::str_replace(prey_type, "eel pout", "eelpout"),
           prey_type = stringr::str_replace_all(prey_type, "poor-cod$", "poor cod"),
           prey_type = stringr::str_replace_all(prey_type, "rockling.*", "rockling"),
           prey_type = stringr::str_replace_all(prey_type, "salmon.*", "salmonidae"),
           prey_type = stringr::str_replace(prey_type, "mollusc$", "molluscs"),
           prey_type = stringr::str_replace_all(prey_type, "(wrass sp)|(wrass$)", "wrasse"),
           prey_type = stringr::str_replace_all(prey_type, "1 gadidae", "gadidae 1+ group"),
           prey_type = stringr::str_replace_all(prey_type, "0 gadidae", "gadidae 0 group"),
           prey_type = stringr::str_replace_all(prey_type, "(sprats)\\b|spart", "sprat"),
           prey_type = stringr::str_replace_all(prey_type, "laval", "larval"),
           prey_type = stringr::str_replace_all(prey_type, "others", "other"),
           prey_type = stringr::str_replace_all(prey_type, "unidentified/other", "other"),
           prey_type = stringr::str_replace_all(prey_type, "\\(|\\)|\\?|,|-", ""),
           # clean prey_species to remove
           prey_species = dplyr::recode(prey_species,
                                        `0 Group Sandeel` = "Ammodytidae",
                                        `1+ Group Sandeel` = "Ammodytidae",
                                        `Sandeel 0 Group` = "Ammodytidae",
                                        `Sandeel 1+ Group` = "Ammodytidae",
                                        others = "other",
                                        Other = "other"),
           age_group = dplyr::recode(age_group,
                                        Chicks = "chick"),
           # fill in NAs
           prey_species = 
               case_when(is.na(prey_species) & 
                             stringr::str_detect(prey_type, "sandeel") ~ "Ammodytidae",
                         is.na(prey_species) & 
                         stringr::str_detect(prey_type, "gadidae") ~ "Gadidae",
                         is.na(prey_species) & 
                         stringr::str_detect(prey_type, "other") ~ "Others",
                         TRUE ~ prey_species),
           
           # fill prey_age_group column
           prey_age_group = 
               case_when(stringr::str_detect(prey_type, "0") ~ "0",
                         stringr::str_detect(prey_type, "1|(older)") ~ ">= 1"),
           #prey_size = stringr::str_replace_all(prey_size, "m", "")
           # ensure start and end year are single year, not range
           startyear = stringr::str_extract(startyear, "\\d*") %>% as.numeric(),
           endyear = stringr::str_extract(endyear, "\\d*$") %>% as.numeric()
           ) %>%
    distinct() %>%
    bind_cols(id =  1:nrow(.), .) 

# remove rows where there is no data on prey occurrence
seabirddiet <- seabirddiet[as.logical(rowSums(
        !is.na(seabirddiet[, c("fo_o", "num_freq", "freq_biomass"), drop = F])
        )),] 

# remove sd column
seabirddiet <- seabirddiet %>% dplyr::select(-.data$sd)

readr::write_csv(seabirddiet, here::here("data-raw", "intermediate", "seabirddiet.csv"))
#source(here::here("data-raw", "01c_process_references.R"))

# calculate year ----
seabirddiet <- dplyr::mutate(seabirddiet,
                             year = ceiling(startyear + (endyear - startyear)/2),
                             multiyear = case_when(endyear > startyear ~ TRUE,
                                                   TRUE ~ FALSE)) %>%
    select(id:endyear, multiyear, everything())

# join-taxo ----
seabirddiet <- seabirddiet %>% 
    bind_taxonomy(role = "pred") %>% 
    bind_taxonomy(role = "prey") 


# join-ref ----
ref_join <- readr::read_csv(here::here("data-raw", "joins", "ref_join.csv")) %>% 
    assertr::assert(assertr::is_uniq, reference)
seabirddiet <- seabirddiet %>% 
    df_recode_report() %>% # correct ref/notes/source column shift
    left_join(ref_join, by = "reference") %>% 
    assertr::assert(assertr::not_na, ref_ids) %>% 
    select(-reference) 



# rename-vars ----
# create manual recode table
# mn_recode_tbl(tibble(names = names(seabirddiet)), names)
mn_names <- readr::read_csv(
    here::here("data-raw", "manual_corrections",
               "mn_seabirddiet_rename.csv"))

seabirddiet <- seabirddiet %>% rename_at(vars(mn_names$names), ~ mn_names$rename)


# clean-funny-characters ----
seabirddiet <- seabirddiet %>%
    mutate(
        # freq-biomass
        freq_biomass = readr::parse_number(freq_biomass),
        # prey_size
        prey_size = stringr::str_replace_all(prey_size, "\xf1|ñ", "+/-") %>%  
            stringr::str_replace_all("\\+/[^\\-]", "+/-") %>% 
            stringr::str_replace_all("([<>=])\\s*", "\\1 ") %>%
            stringr::str_replace_all("(\\d+)\\s*-\\s*(\\d+)", "\\1 - \\2")  %>% 
            stringr::str_replace_all("\\s*(cm|mm)", " \\1") %>% 
            stringr::str_replace_all("\\s*\\+/-\\s*", " +/- "))




# clean-factors
factor_vars <- c("pred_breeding_status", "pred_age_group", "prey_age_group",
                 "source", "sample_type", "prey_rank", "pred_rank")
seabirddiet <- seabirddiet %>%
    mutate_at(factor_vars, stringr::str_to_lower) 

# reorder-vars ----
seabirddiet <- seabirddiet %>% 
    # move variables to back for better order when using starts_with
    dplyr::select( -pred_breeding_status,
                   -pred_breeding_status, 
                   -pred_age_group, 
                   -prey_age_group, 
                   -prey_size, 
                   everything()) %>%
    # variable group reorder
    dplyr::select(id, year:longitude, 
                  dplyr::starts_with("pred"),
                  dplyr::starts_with("prey"),
                  dplyr::starts_with("freq"),
                  dplyr::starts_with("sample"),
                  dplyr::starts_with("ref"),
                  everything())

# ---- SAVE_DATA ----
# dataset-validate
seabirddiet %>%
    assertr::assert(is.numeric, year, startyear, endyear, 
                    latitude, longitude, freq_occ, freq_num, freq_biomass) %>%
    assertr::assert(is.logical, multiyear) %>%
    assertr::assert(is.character, prey_age_group) %>%
    assertr::assert(assertr::not_na, ref_ids, prey_taxon, pred_rank, year, multiyear) %>%
    assertr::assert(assertr::is_uniq, id) %>%
    assertr::assert(assertr::within_bounds(0, 1), freq_occ, freq_num, freq_biomass) %>%
# csv ----
readr::write_csv(here::here("inst", "csv", "seabirddiet.csv"))

# convert to tibble
seabirddiet <- tibble::as_tibble(seabirddiet)

# seabirddiet_ ----
usethis::use_data(seabirddiet, overwrite = T)

# seabirddiet_ ----
# sf
seabirddiet_ <- sf::st_as_sf(seabirddiet, coords = c("latitude", "longitude"), crs = 4326) 

seabirddiet_ <- dplyr::mutate(seabirddiet_, 
                              # set factors                          
                              prey_rank = factor(prey_rank, 
                                                 levels = c("phylum", "subphylum", "class",
                                                            "order","family","genus","species")),
                              pred_rank = factor(pred_rank),
                              pred_age_group = factor(pred_age_group,
                                                      levels = c("chick","adult & chick","adult")),
                              pred_breeding_status = factor(pred_breeding_status),
                              prey_age_group = factor(prey_age_group),
                              sample_type = factor(sample_type),
                              source = factor(source)) %>% 
    # set integers
    mutate_at(vars(c("year", "startyear", "endyear", "id"),
                   contains("aphia_id")), as.integer)

usethis::use_data(seabirddiet_, overwrite = T)
devtools::install(quick = TRUE, dependencies = FALSE)
