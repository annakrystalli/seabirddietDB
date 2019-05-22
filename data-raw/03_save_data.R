seabirddiet <- readr::read_csv(here::here("inst", "csv", "seabirddiet.csv"), guess_max = Inf)

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
