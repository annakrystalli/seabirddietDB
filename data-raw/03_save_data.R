seabirddiet <- readr::read_csv(here::here("inst", "csv", "seabirddiet.csv"), guess_max = Inf)

usethis::use_data(seabirddiet, overwrite = T)

# sf
seabirddiet_ <- sf::st_as_sf(seabirddiet, coords = c("latitude", "longitude"), crs = 4326) 
usethis::use_data(seabirddiet_, overwrite = T)
