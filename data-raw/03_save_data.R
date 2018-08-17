seabirddiet <- readr::read_csv(here::here("data-raw", "seabirddiet.csv"))

usethis::use_data(seabirddiet)
usethis::use_data(seabirddiet_)